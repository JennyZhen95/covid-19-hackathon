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


#### 2nd meeting 6/16/20

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

#####Todo:

###### Big goal: calculate weights for each policy

1. Yang
   1. Use mobility change around policy date to cluster policies. Assumption: policy weights apply the same to all states
2. Li
   1. Use mobility change around policy date to cluster states. Assumption: policy weights apply differently to states
3. Jenny
   1. Regression model of Mobility ~ Policys with Bayesian framework. Assumption: policy weights apply differently to states