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
