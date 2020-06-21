library(fpp)
library(TSA)
library(ggplot2)

# ARIMAX model/Regression with ARIMA Errors - forecast 7 days
datapath<-"~/Desktop/data"
df_il<-read.csv(file=paste(datapath,"df_il.csv",sep="/"),header=TRUE,sep=",")
df_il

confirmed_cases <- ts(df_il$confirmed_cases, start=1/7, frequency=7)
confirmed_cases <- log(confirmed_cases)
confirmed_cases_train <- window(confirmed_cases, start=1/7, end=100/7)
confirmed_cases_test <- window(confirmed_cases, start=101/7, end=107/7)
confirmed_cases_mean <- mean(confirmed_cases_test)


# Retail and recreation - no seasonality
policyRetail <- ts(df_il$policyScore_retail, start=1/7, frequency=7)
policyRetail_train <- window(policyRetail, start=1/7, end=100/7)
policyRetail_test <- window(policyRetail, start=101/7, end=107/7)
policyRetail_mean <- mean(policyRetail_test)

mobilityRetail <- ts(df_il$retail_and_recreation, start=1/7, frequency=7)
mobilityRetail_train <- window(mobilityRetail, start=8/7, end=107/7)
mobilityRetail_test <- window(mobilityRetail, start=108/7, end=114/7)

fit_Regression_ARMA_retail <- auto.arima(mobilityRetail_train, seasonal = FALSE, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyRetail_train))
summary(fit_Regression_ARMA_retail)
checkresiduals(fit_Regression_ARMA_retail)

forecast_Regression_ARMA_retail <- forecast(fit_Regression_ARMA_retail, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyRetail_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_retail, mobilityRetail_test)

plot(forecast_Regression_ARMA_retail, col=1, include=12)
lines(mobilityRetail_test, type="l",col=2)


# Grocery and pharmacy - no seasonality
policyGrocery <- ts(df_il$policyScore_grocery, start=1/7, frequency=7)
policyGrocery_train <- window(policyGrocery, start=1/7, end=100/7)
policyGrocery_test <- window(policyGrocery, start=101/7, end=107/7)
policyGrocery_mean <- mean(policyGrocery_test)

mobilityGrocery <- ts(df_il$grocery_and_pharmacy, start=1/7, frequency=7)
mobilityGrocery_train <- window(mobilityGrocery, start=8/7, end=107/7)
mobilityGrocery_test <- window(mobilityGrocery, start=108/7, end=114/7)

fit_Regression_ARMA_grocery <- auto.arima(mobilityGrocery_train, seasonal = FALSE, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyGrocery_train))
summary(fit_Regression_ARMA_grocery)
checkresiduals(fit_Regression_ARMA_grocery)

forecast_Regression_ARMA_grocery <- forecast(fit_Regression_ARMA_grocery, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyGrocery_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_grocery, mobilityGrocery_test)

plot(forecast_Regression_ARMA_grocery, col=1, include=12)
lines(mobilityGrocery_test, type="l",col=2)


# Parks
policyParks <- ts(df_il$policyScore_parks, start=1/7, frequency=7)
policyParks_train <- window(policyParks, start=1/7, end=100/7)
policyParks_test <- window(policyParks, start=101/7, end=107/7)
policyParks_mean <- mean(policyParks_test)

mobilityParks <- ts(df_il$parks, start=1/7, frequency=7)
mobilityParks_train <- window(mobilityParks, start=8/7, end=107/7)
mobilityParks_test <- window(mobilityParks, start=108/7, end=114/7)

fit_Regression_ARMA_parks <- auto.arima(mobilityParks_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyParks_train))
summary(fit_Regression_ARMA_parks)
checkresiduals(fit_Regression_ARMA_parks)

forecast_Regression_ARMA_parks <- forecast(fit_Regression_ARMA_parks, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyParks_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_parks, mobilityParks_test)

plot(forecast_Regression_ARMA_parks, col=1, include=12)
lines(mobilityParks_test, type="l",col=2)


# Transit
policyTransit <- ts(df_il$policyScore_transit, start=1/7, frequency=7)
policyTransit_train <- window(policyTransit, start=1/7, end=100/7)
policyTransit_test <- window(policyTransit, start=101/7, end=107/7)
policyTransit_mean <- mean(policyTransit_test)

mobilityTransit <- ts(df_il$transit_stations, start=1/7, frequency=7)
mobilityTransit_train <- window(mobilityTransit, start=8/7, end=107/7)
mobilityTransit_test <- window(mobilityTransit, start=108/7, end=114/7)

fit_Regression_ARMA_transit <- auto.arima(mobilityTransit_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyTransit_train))
summary(fit_Regression_ARMA_transit)
checkresiduals(fit_Regression_ARMA_transit)

forecast_Regression_ARMA_transit <- forecast(fit_Regression_ARMA_transit, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyTransit_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_transit, mobilityTransit_test)

plot(forecast_Regression_ARMA_transit, col=1, include=12)
lines(mobilityTransit_test, type="l",col=2)


# Workplaces
policyWorkplaces <- ts(df_il$policyScore_workplaces, start=1/7, frequency=7)
policyWorkplaces_train <- window(policyWorkplaces, start=1/7, end=100/7)
policyWorkplaces_test <- window(policyWorkplaces, start=101/7, end=107/7)
policyWorkplaces_mean <- mean(policyWorkplaces_test)

mobilityWorkplaces <- ts(df_il$workplaces, start=1/7, frequency=7)
mobilityWorkplaces_train <- window(mobilityWorkplaces, start=8/7, end=107/7)
mobilityWorkplaces_test <- window(mobilityWorkplaces, start=108/7, end=114/7)

fit_Regression_ARMA_workplaces <- auto.arima(mobilityWorkplaces_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyWorkplaces_train))
summary(fit_Regression_ARMA_workplaces)
checkresiduals(fit_Regression_ARMA_workplaces)

forecast_Regression_ARMA_workplaces <- forecast(fit_Regression_ARMA_workplaces, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyWorkplaces_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_workplaces, mobilityWorkplaces_test)

plot(forecast_Regression_ARMA_workplaces, col=1, include=12)
lines(mobilityWorkplaces_test, type="l",col=2)

# Residential
policyResidential <- ts(df_il$policyScore_residential, start=1/7, frequency=7)
policyResidential_train <- window(policyResidential, start=1/7, end=100/7)
policyResidential_test <- window(policyResidential, start=101/7, end=107/7)
policyResidential_mean <- mean(policyResidential_test)

mobilityResidential <- ts(df_il$residential, start=1/7, frequency=7)
mobilityResidential_train <- window(mobilityResidential, start=8/7, end=107/7)
mobilityResidential_test <- window(mobilityResidential, start=108/7, end=114/7)

fit_Regression_ARMA_residential <- auto.arima(mobilityResidential_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyResidential_train))
summary(fit_Regression_ARMA_residential)
checkresiduals(fit_Regression_ARMA_residential)

forecast_Regression_ARMA_residential <- forecast(fit_Regression_ARMA_residential, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyResidential_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_residential, mobilityResidential_test)

plot(forecast_Regression_ARMA_residential, col=1, include=12)
lines(mobilityResidential_test, type="l",col=2)


#summary
c = cbind(forecast_Regression_ARMA_retail$mean, forecast_Regression_ARMA_grocery$mean, forecast_Regression_ARMA_parks$mean,forecast_Regression_ARMA_transit$mean, forecast_Regression_ARMA_workplaces$mean, forecast_Regression_ARMA_residential$mean)
colnames(c) <- c("retail","grocery","parks","transit","workplaces","residential")
write.csv(c, 'forecast.csv')
c

