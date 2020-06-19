library(fpp)
library(TSA)
library(ggplot2)

# ARIMAX model/Regression with ARIMA Errors - forecast 7 days
datapath<-"~/Desktop/data"
df_il<-read.csv(file=paste(datapath,"df_il.csv",sep="/"),header=TRUE,sep=",")
df_il

confirmed_cases <- ts(df_il$confirmed_cases, start=1, frequency=1)
confirmed_cases <- log(confirmed_cases)
confirmed_cases_train <- window(confirmed_cases, start=1, end=100)
#autoplot(confirmed_cases_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
confirmed_cases_test <- window(confirmed_cases, start=101, end=107)
#autoplot(confirmed_cases_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
confirmed_cases_mean <- mean(confirmed_cases_test)

policyRetail <- ts(df_il$policyScore_retail, start=1, frequency=1)
policyRetail_train <- window(policyRetail, start=1, end=100)
#autoplot(policyRetail_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
policyRetail_test <- window(policyRetail, start=101, end=107)
#autoplot(policyRetail_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
policyRetail_mean <- mean(policyRetail_test)

# Retail and recreation
mobilityRetail <- ts(df_il$retail_and_recreation, start=1, end = 114, frequency=1)
#autoplot(mobilityRetail,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation")
mobilityRetail_train <- window(mobilityRetail, start=8, end=107)
#autoplot(mobilityRetail_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
mobilityRetail_test <- window(mobilityRetail, start=108, end=114)
#autoplot(mobilityRetail_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")

fit_Regression_ARMA_retail <- auto.arima(mobilityRetail_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyRetail_train))
summary(fit_Regression_ARMA_retail)
checkresiduals(fit_Regression_ARMA_retail)

forecast_Regression_ARMA_retail <- forecast(fit_Regression_ARMA_retail, xreg=cbind(rep(confirmed_cases_mean,7), rep(policyRetail_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_retail, mobilityRetail_test)

plot(forecast_Regression_ARMA_retail, col=1, include=12)
lines(mobilityRetail_test, type="l",col=2)



## Try other days_diff
confirmed_cases_train <- window(confirmed_cases, start=1, end=93)
confirmed_cases_test <- window(confirmed_cases, start=94, end=107)
confirmed_cases_mean <- mean(confirmed_cases_test)

policyRetail_train <- window(policyRetail, start=1, end=93)
policyRetail_test <- window(policyRetail, start=94, end=107)
policyRetail_mean <- mean(policyRetail_test)

mobilityRetail_train <- window(mobilityRetail, start=8, end=100)
mobilityRetail_test <- window(mobilityRetail, start=101, end=114)

fit_Regression_ARMA_retail <- auto.arima(mobilityRetail_train, trace = TRUE, ic = 'aicc', xreg=cbind(confirmed_cases_train, policyRetail_train))
forecast_Regression_ARMA_retail <- forecast(fit_Regression_ARMA_retail, xreg=cbind(rep(confirmed_cases_mean,14), rep(policyRetail_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_retail, mobilityRetail_test)
plot(forecast_Regression_ARMA_retail, col=1, include=12)
lines(mobilityRetail_test, type="l",col=2)



# Grocery and pharmacy
mobilityGrocery <- ts(df_il$grocery_and_pharmacy, start=1, end = 114, frequency=1)


# Parks
mobilityParks <- ts(df_il$parks, start=1, end = 114, frequency=1)


# Transit
mobilityTransit <- ts(df_il$transit_stations, start=1, end = 114, frequency=1)


# Workplaces
mobilityWorkplaces <- ts(df_il$workplaces, start=1, end = 114, frequency=1)


# Residential
mobilityResidential <- ts(df_il$residential, start=1, end = 114, frequency=1)





