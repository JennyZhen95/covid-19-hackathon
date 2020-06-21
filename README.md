### 6/15/20

1. Plot with mobility pattern and date of measure taken (parameters: mobility category, measure category, timeframe)
2. plot with cases and mobility pattern



### Paper

- Predict case counts with mobility pattern in China (glm model with time-series) https://science.sciencemag.org/content/368/6490/493
- 





### Problem Statement

1. Estimate future mobility pattern with policy interventions
2. Predict cases with future mobility pattern 
3. Add onto policy interventions and see prediction changes



### Note

1. parks imputation (time-series prediction or previous-day)
   1. parks have peak
2. deaths, confirmed cases.diff()
3. 





#### 1st Meeting 6/14/20

General Goal:

1. Predict mobility score (currently working on this)
   1. Multivaraite time-series (outputs six mobility score + considering the interactions between)
   2. Hierarchical time-series (predict country first and then dsitribute to states/cluster)
2. Predict confirmed cases based on estimated mobility score

Todo:

1. Jenny- Clustering
   1. pop density
   2. state policy (corr/consine between state; quantify date change)
   3. economy
   4. confirmed cases
   5. death
2. Li, Yang - baseline model for mobility prediction   (IL first)
   1. Li - Hierarchical
   2. Yang - timeseries+regression
   3. IVs
      1. policy measures (counts, dummy)
      2. date
      3. confirmed cases (consider transforming)
      4. death (consider transforming)





### Clustering

- Variables
  - stay at home length
  - business closure length
  - restaurant closure length
  - gyms closure length
  - movie theatre closure length

1. State correlation
   1. mobility change rate within length and then cluster
   2. 





### 2nd meeting 6/16/20

1. Time-series by Li
   1. Arima has best performance
   2. Features of mobility
2. Time series by Yang
   1. Arima + residual regression
   2. Conclustion
      1. arfima: transit, workplaces, residential 
      2. arimaX: retail, grocery, parks
   3. features of mobility + confirmed cases + policy
      1. Policy has been divided into three categories: date encouraging mobility, discourage mobility and flag encouraging mobility

Todo:

#### Big goal: calculate weights for each policy

1. Yang
   1. Use mobility change around policy date to cluster policies. Assumption: policy weights apply the same to all states
2. Li
   1. Use mobility change around policy date to cluster states. Assumption: policy weights apply differently to states
3. Jenny
   1. Regression model of Mobility ~ Policys with Bayesian framework. Assumption: policy weights apply differently to states







### Presentation Discussion

#### Main Topic

Problem statement

- How past policies affect mobility across six categories ()
- help them with future policy makings



Project purpose:

- Quantify policy's effect
- predict mobilities using quantified policies
- Provide a pipeline tool for policy makers's future decision making 
- Context
  - Mobility is related to and affects on COVID-19 spreading. Therefore, investigating how policies affects mobility can help us better understand and investigate the COVID-19 spreading. 
  - There are multiple phrases for recovery, therefore having a tool can help policy makers with decision on how to transition in to each phase. 

#### Dataset

policy: https://github.com/KristenNocka/COVID-19-US-State-Policy-Database

mobility: https://www.google.com/covid19/mobility/

COVID-19: https://console.cloud.google.com/marketplace/details/usafacts-public-data/covid19-us-cases?filter=category%3Acovid19&id=3eaff9c5-fbaf-47bb-a441-89db1e1395ab

time-window: mobility's time window (114 days), 2/15/2020 - 6/7/2020

Feature Engineering

1. policy dummy encoding (bayesian and ARIMA)
2. weight of policy (*) (Arima)
3. narrow down to 18 policies (domain knowledge, personal experience) 
4. weekend encoded5 (bayesian)
5. log of daily new cases (bayesian and ARIMA)
6. cumsum of policy encoding (bayesian)

Missing value imputation

1. park mobility, Na.kalman



#### Methodologies

1. How to quantify policies
   1. state cluster 
      1. visualizations
   2. policy cluster and calcualte weights
      1. explain in more details on the weights
2. Predict mobility using quantified policies  (eg: IL and retail)
   1. ARIMAX (all mobility and all states)
      1. parameters
      2. model pros and cons
      3. Tableau visualization
      4. Coefficient (total policy score)
   2. Bayesian framework on linear regression (to see each policy's effects on mobility )
      1. ensemble predictions (significant result on IL and retail)
      2. Time limit, only IL and retail
3. Pipeline
   1. 



### Future extension

1. dataset update
2. Better user interface
3. Limitations on options of policies
4. Prediction timewindow is only 7 days

