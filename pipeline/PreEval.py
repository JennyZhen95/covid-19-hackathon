# policy of previous day
# confirmed cases trending
import pandas as pd
import datetime
import matplotlib.pyplot as plt
import seaborn as sns

def DecodePolicy(policy):
    dict = {'STEMERG': 'State of emergency',
            'CLSCHOOL': 'Date closed K-12 schools',
            'CLDAYCR': 'Closed day cares',
            'CLNURSHM': 'Date banned visitors to nursing homes',
            'FM_ALL': 'Mandate face mask use by all individuals in public spaces',
            'FM_EMP': 'Mandate face mask use by employees in public-facing businesses',
            'EVICINTN': 'Stop Initiation of Evictions overall or due to COVID related issues',
            'EVICENF': 'Stop enforcement of evictions overall or due to COVID related issues',
            'STAYHOME': 'Stay at home/ shelter in place',
            'END_STHM': 'End/relax stay at home/shelter in place',
            'CLBSNS': 'Closed non-essential businesses',
            'END_BSNS': 'Began to reopen businesses',
            'CLREST': 'Closed restaurants except take out',
            'ENDREST':'Reopen restaurants',
            'CLGYM': 'Closed gyms',
            'ENDGYM': 'Reopened gyms',
            'CLMOVIE': 'Closed movie theaters',
            'END_MOV': 'Reopened movie theaters'}
    policy = [dict[i] for i in policy]

    return policy



def PolicyDayBefore(df, state, policy_lst):
    df = df[df['a_state'] == state]
    df = df.sort_values('a_date', ascending=False)
    df = df[policy_lst]
    policy = df.iloc[0].replace(1, 'active')
    policy = policy.replace(0, 'inactive')

    output = pd.DataFrame()
    output['policy'] = policy.index
    output['description'] = DecodePolicy(policy_lst)
    output['status'] = policy.values

    return output


class ConfirmedCases:
    def __init__(self, data, state, start=None, end=None):
        self.state = state
        self.data = data[data['a_state'] == self.state]
        self.data = self.data[['a_state', 'a_date', 'confirmed_cases_state']]
        self.data['a_date'] = pd.to_datetime(self.data['a_date'])

        # If user specifies one of start and end
        if start is not None or end is not None:
            if start is None:
                self.start = self.data.sort_values(['a_date'])['a_date'].iloc[0]
            else:
                self.start = datetime.datetime.strptime(start, '%Y-%m-%d')

            if end is None:
                self.end = self.data.sort_values(['a_date'], ascending=False)['a_date'].iloc[0]
            else:
                self.end = datetime.datetime.strptime(end, '%Y-%m-%d')

            self.data = self.data[(self.data['a_date']<=self.end) & (self.data['a_date']>=self.start)]

    def show_total(self):
        plt.subplots(figsize=(12,7))
        sns.barplot('a_date', 'confirmed_cases_state', data=self.data, color='blue')
        plt.xticks([], range(0, self.data.shape[0]))
        plt.title('Total confirmed cases')
        plt.show()

    def show_daily_new(self):
        self.data['new_cases'] = self.data['confirmed_cases_state'].diff()

        plt.subplots(figsize=(12,7))
        sns.lineplot('a_date', 'new_cases', data=self.data, color='blue')
        plt.xticks([], range(0, self.data.shape[0]))
        plt.title('Daily new cases')
        plt.show()




# policy_lst = ['STEMERG', 'CLSCHOOL', 'CLDAYCR',
#        'FM_ALL', 'FM_EMP', 'CLNURSHM', 'EVICINTN', 'EVICENF',
#        'STAYHOME', 'END_STHM', 'CLBSNS', 'END_BSNS', 'CLREST', 'ENDREST',
#        'CLGYM', 'ENDGYM', 'CLMOVIE', 'END_MOV']
# import pandas as pd
# data = pd.read_csv('/Users/Jenny/Desktop/COVID19/cleaned/policy_mobiliy.csv')
# PolicyDayBefore(data, 'IL', policy_lst)
# ConfirmedCases(data, 'IL').show_daily_new()
