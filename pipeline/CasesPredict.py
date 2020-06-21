import pickle
import numpy as np
import pandas as pd
import datetime
import matplotlib.pyplot as plt
import seaborn as sns


with open('/Users/Jenny/Desktop/COVID19/models/casesModel.pkl', 'rb') as f:
    model = pickle.load(f)


def predict(x, x_unchanged):
    y_pred = np.exp(model.predict(x.reshape(-1, 1)))
    y_pred_unchanged = np.exp(model.predict(x_unchanged.reshape(-1,1)))
    return y_pred, y_pred_unchanged


def clean(df, state):
    df = df[df['a_state'] == state]
    df['a_date'] = pd.to_datetime(df['a_date'])
    df = df.sort_values('a_date')
    df['daily_new_cases'] = df['confirmed_cases_state'].diff()
    return df


def dates(df):
    past = df['a_date']
    future = [df['a_date'].iloc[-1] + datetime.timedelta(days=i) for i in range(1, 8)]
    return past, future


def print_prediction(y_pred, y_pred_unchanged, future_dates):
    df = pd.DataFrame(columns=['date', 'predicted daily new cases with changed policy',
                               'predicted daily new cases with old policy remained'])
    df['date'] = future_dates
    df['predicted daily new cases with changed policy'] = y_pred
    df['predicted daily new cases with old policy remained'] = y_pred_unchanged
    display(df)


def show_pred(df, y_pred, y_pred_unchanged, future_date):
    plt.subplots(figsize=(14, 7))
    ax = sns.lineplot(future_date, y_pred, label='future if change policy indicated above')
    ax.lines[0].set_linestyle("--")
    sns.lineplot(df.a_date, df.daily_new_cases, label='past', color='orange')
    sns.lineplot(future_date, y_pred_unchanged, label='future if remain same policy', color='orange')
    ax.lines[2].set_linestyle("--")
    plt.legend()
    plt.show()


def cases_predict(data, state, y_pred, y_pred_unchanged):
    y_pred, y_pred_unchanged = predict(y_pred, y_pred_unchanged)
    data = clean(data, state)
    past_dates, future_dates = dates(data)
    print_prediction(y_pred, y_pred_unchanged, future_dates)
    show_pred(data, y_pred, y_pred_unchanged, future_dates)






