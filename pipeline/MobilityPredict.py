import datetime
import pandas as pd
import numpy as np
import pickle
import pystan
import arviz as az
import matplotlib.pyplot as plt
import seaborn as sns


# Clean the data and format
def clean(df, policy_lst, state, mobility):
    """
    Clean data
    :return: pd.DataFrame
    """
    # state data
    df = df[df['a_state'] == state]
    # datetime object
    df['a_date'] = pd.to_datetime(df['a_date'])
    # cols we need: a_date, policy_lst, confirmed_cases_state, mobility
    df = df[['a_date', mobility, 'confirmed_cases_state']+policy_lst]
    df = df.sort_values('a_date')

    return df


# Add future data in
def add_future(df, new_active, new_inactive, policy_lst):
    # add future data
    future_date = [df.a_date.iloc[-1] + datetime.timedelta(days=i) for i in range(1, 8)]

    # future data
    future = pd.DataFrame(columns=df.columns)
    future['a_date'] = future_date
    for i in policy_lst:
        if i in new_active:
            future[i] = 1
        elif i in new_inactive:
            future[i] = 0
        else:
            future[i] = df[i].iloc[-1]

    # concatenate
    output = pd.concat([df, future])

    # future unchanged data
    future_unchanged = pd.DataFrame(columns=df.columns)
    future_unchanged['a_date'] = future_date
    for i in policy_lst:
        future_unchanged[i] = df[i].iloc[-1]
    output_unchanged = pd.concat([df, future_unchanged])

    return output, output_unchanged


# weekend indicator
def weekend(df):
    df['weekno'] = df['a_date'].apply(lambda x: x.weekday())
    df['sat'] = np.where(df['weekno'] == 5, 1, 0)
    df['sun'] = np.where(df['weekno'] == 6, 1, 0)
    df = df.drop('weekno', axis=1)

    return df


# log and shifted confirmed cases
def new_confirmed_log_shifted(df):
    new = df['confirmed_cases_state'].diff()
    new = new.fillna(np.nan)
    # new = np.log(new).replace(-np.inf,0)
    new = new.fillna(0)
    df['new_confirmed_shifted'] = new
    df['new_confirmed_shifted'] = df['new_confirmed_shifted'].shift(7)
    df['new_confirmed_shifted'] = df['new_confirmed_shifted'].fillna(0)
    df = df.drop('confirmed_cases_state', axis=1)
    return df


# cumsum of policy
def policy_cumsum(df, policy_lst):
    df[policy_lst] = df[policy_lst].cumsum()
    return df


def add_weights(df, state, mobility, policy_lst):
    dict = {'retail_and_recreation': '/Users/Jenny/Desktop/COVID19/cleaned/policies_retail.csv'}
    weights = pd.read_csv(dict[mobility])
    weights = weights.set_index('POLICIES')[state]

    for i in policy_lst:
        try:
            df[i] = df[i] * weights[i]
        except:
            continue
    return df


def feature(df, state, mobility, policy_lst):
    # add weekend indicator
    df = weekend(df)
    #confirmed cases
    df = new_confirmed_log_shifted(df)
    #cumsum of policy
    # df = policy_cumsum(df, policy_lst)
    # weights
    df = add_weights(df, state, mobility, policy_lst)
    return df


# split labeled and unlabeled
def labeled_unlabeled(df, mobility, df_unchanged):
    # set index
    df = df.set_index('a_date')
    df_unchanged = df_unchanged.set_index('a_date')
    # split
    labeled = df[df[mobility].notna()]
    unlabeled = df[df[mobility].isna()]
    unchanged = df_unchanged[df_unchanged[mobility].isna()]

    return labeled, unlabeled, unchanged


# train_test_split
def train_test_split(df, days):
    try:
        # set index
        df = df.set_index('a_date')
    except:
        None
    # split
    train = df.iloc[:df.shape[0] - (days + 1)]
    test = df.iloc[df.shape[0] - days:]

    return train, test


# prepare data list for Bayesian model
def data_list(train, test, unchanged, target):
    x = train.drop(target, axis=1)
    y = train[target].astype(int)
    N = x.shape[0]
    Nx = x.shape[1]
    N_tilda = test.shape[0]
    x_tilda = test.drop(target, axis=1)
    x_tilda_unchanged = unchanged.drop(target, axis=1)

    datalist = {'N': N,
                'Nx': Nx,
                'y': y,
                'x': x,
                'N_tilda': N_tilda,
                'x_tilda': x_tilda,
                'x_tilda_unchanged': x_tilda_unchanged}

    return datalist


# Load model
def load_model(state, mobility):
    dict = {'IL':{'retail_and_recreation': '/Users/Jenny/Desktop/COVID19/models/BayesModel_IL_Retail.pkl'}}
    with open(dict[state][mobility], 'rb') as f:
        model = pickle.load(f)

    return model


# fitting model
def fit(model, datalist):
    model_fit = model.sampling(data=datalist, iter=1000, chains=2, seed=9, control={'max_treedepth': 15})
    return model_fit


# prediction
def predict(model_fit):
    y_pred = model_fit.extract()['y_tilda'].mean(axis=0)
    y_pred_unchanged = model_fit.extract()['y_tilda_unchanged'].mean(axis=0)
    return y_pred, y_pred_unchanged


# Visualize prediction
def show_pred(y_pred, y_pred_unchanged, labeled, unlabeled, mobility):
    plt.subplots(figsize = (14,7))
    ax = sns.lineplot(unlabeled.index, y_pred, label='future if change policy indicated above')
    ax.lines[0].set_linestyle("--")
    sns.lineplot(labeled.index, labeled[mobility].astype(int), label='past', color='orange')
    sns.lineplot(unlabeled.index, y_pred_unchanged, label='future if remain same policy', color='orange')
    ax.lines[2].set_linestyle("--")
    plt.legend()
    plt.show()

def print_pred(y_pred, y_pred_unchanged, unlabeled):
    df = pd.DataFrame(columns=['date', 'predicted mobility with changed policy', 'predicted mobility with old policy remained'])
    df['date'] = unlabeled.index
    df['predicted mobility with changed policy'] = y_pred
    df['predicted mobility with old policy remained'] = y_pred_unchanged

    display(df)


# modeling
def model_predict(df, policy_lst, state, mobility,
                  active, inactive, check_perform=False):
    # clean data
    df = clean(df, policy_lst, state, mobility)
    # add future
    df, df_unchanged = add_future(df, active, inactive, policy_lst)
    # feature engineering
    df = feature(df, state, mobility, policy_lst)
    df_unchanged = feature(df_unchanged, state, mobility, policy_lst)

    # prepare data for modeling
    train, pred, unchanged = labeled_unlabeled(df, mobility, df_unchanged)
    datalist = data_list(train, pred, unchanged, mobility)

    # training
    model = load_model(state, mobility)
    model_fit = fit(model, datalist)

    # predict
    y_pred, y_pred_unchanged = predict(model_fit)

    # Visualize
    print_pred(y_pred, y_pred_unchanged, unchanged)
    show_pred(y_pred, y_pred_unchanged, train, pred, mobility)

    return y_pred, y_pred_unchanged




# # # test
# data = pd.read_csv('/Users/Jenny/Desktop/COVID19/cleaned/policy_mobiliy.csv')
# cleaned = clean(data, policy_lst, 'IL', 'retail_and_recreation')
# alldata, alldata_unchanged = add_future(df=cleaned, new_active = ['END_MOV'], new_inactive=['CLDAYCR', 'CLMOVIE'], policy_lst=policy_lst)
# alldata = feature(alldata, 'IL', 'retail_and_recreation', policy_lst)
#
# labeled, unlabeled = labeled_unlabeled(alldata, 'retail_and_recreation')
# train, test = train_test_split(labeled, 7)
#
# dlt = data_list(labeled, unlabeled, 'retail_and_recreation')
# model = load_model('IL', 'retail_and_recreation')
# model_fit = model.sampling(dlt)
#
# y_pred = predict(model_fit)
#
# show_pred(y_pred, labeled, unlabeled, 'retail_and_recreation')



# data = pd.read_csv('/Users/Jenny/Desktop/COVID19/cleaned/policy_mobiliy.csv')
# policy_lst = ['STEMERG', 'CLSCHOOL', 'CLDAYCR',
#        'FM_ALL', 'FM_EMP', 'CLNURSHM', 'EVICINTN', 'EVICENF',
#        'STAYHOME', 'END_STHM', 'CLBSNS', 'END_BSNS', 'CLREST', 'ENDREST',
#        'CLGYM', 'ENDGYM', 'CLMOVIE', 'END_MOV']
# model_predict(data, policy_lst, 'IL', 'retail_and_recreation', ['END_MOV'], ['CLDAYCR', 'CLMOVIE'])