library(fpp)
library(TSA)
library(ggplot2)

# ARIMAX model/Regression with ARIMA Errors - forecast 14 days
datapath<-"~/Desktop/data"
df_il<-read.csv(file=paste(datapath,"df_il.csv",sep="/"),header=TRUE,sep=",")
df_il

df_il_confirmed_cases <- ts(df_il$confirmed_cases, start=1, frequency=1)
df_il_confirmed_cases <- log(df_il_confirmed_cases)
df_il_confirmed_cases_train <- window(df_il_confirmed_cases, start=1, end=100)
autoplot(df_il_confirmed_cases_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_confirmed_cases_test <- window(df_il_confirmed_cases, start=101, end=114)
autoplot(df_il_confirmed_cases_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
df_il_confirmed_cases_mean <- mean(df_il_confirmed_cases_test)

df_il_policy <- ts(df_il$policy, start=1, frequency=1)
df_il_policy_train <- window(df_il_policy, start=1, end=100)
autoplot(df_il_policy_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_policy_test <- window(df_il_policy, start=101, end=114)
autoplot(df_il_policy_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
df_il_policy_mean <- mean(df_il_policy_test)

#df_il_death <- ts(df_il$deaths, start=1, frequency=1)
#df_il_death_train <- window(df_il_death, start=1, end=100)
#autoplot(df_il_death_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
#df_il_death_test <- window(df_il_death, start=101, end=114)
#autoplot(df_il_death_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
#df_il_death_mean <- mean(df_il_death_test)


# Retail and recreation
df_il_retail <- ts(df_il$retail_and_recreation, start=1, end = 114, frequency=1)
autoplot(df_il_retail,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation")
df_il_retail_train <- window(df_il_retail, start=1, end=100)
autoplot(df_il_retail_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_retail_test <- window(df_il_retail, start=101, end=114)
autoplot(df_il_retail_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")

fit_Regression_ARMA_retail <- auto.arima(df_il_retail_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_retail)
checkresiduals(fit_Regression_ARMA_retail)

forecast_Regression_ARMA_retail <- forecast(fit_Regression_ARMA_retail, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)

plot(forecast_Regression_ARMA_retail, col=1, include=12)
lines(df_il_retail_test, type="l",col=2)

# Grocery and pharmacy
df_il_grocery <- ts(df_il$grocery_and_pharmacy, start=1, end = 114, frequency=1)
autoplot(df_il_grocery,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy")
df_il_grocery_train <- window(df_il_grocery, start=1, end=100)
autoplot(df_il_grocery_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy  (train dataset)")
df_il_grocery_test <- window(df_il_grocery, start=101, end=114)
autoplot(df_il_grocery_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy (test dataset)")

fit_Regression_ARMA_grocery <- auto.arima(df_il_grocery_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_grocery)
checkresiduals(fit_Regression_ARMA_grocery)

forecast_Regression_ARMA_grocery <- forecast(fit_Regression_ARMA_grocery, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)

plot(forecast_Regression_ARMA_grocery, col=1, include=12)
lines(df_il_grocery_test, type="l",col=2)

# Parks
df_il_parks <- ts(df_il$parks, start=1, end = 114, frequency=1)
autoplot(df_il_parks,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks")
df_il_parks_train <- window(df_il_parks, start=1, end=100)
autoplot(df_il_parks_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks  (train dataset)")
df_il_parks_test <- window(df_il_parks, start=101, end=114)
autoplot(df_il_parks_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks (test dataset)")

fit_Regression_ARMA_parks <- auto.arima(df_il_parks_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_parks)
checkresiduals(fit_Regression_ARMA_parks)

forecast_Regression_ARMA_parks <- forecast(fit_Regression_ARMA_parks, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)

plot(forecast_Regression_ARMA_parks, col=1, include=12)
lines(df_il_parks_test, type="l",col=2)

# Transit
df_il_transit <- ts(df_il$transit_stations, start=1, end = 114, frequency=1)
autoplot(df_il_transit,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations")
df_il_transit_train <- window(df_il_transit, start=1, end=100)
autoplot(df_il_transit_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations  (train dataset)")
df_il_transit_test <- window(df_il_transit, start=101, end=114)
autoplot(df_il_transit_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations (test dataset)")

fit_Regression_ARMA_transit <- auto.arima(df_il_transit_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_transit)
checkresiduals(fit_Regression_ARMA_transit)

forecast_Regression_ARMA_transit <- forecast(fit_Regression_ARMA_transit, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)

plot(forecast_Regression_ARMA_transit, col=1, include=12)
lines(df_il_transit_test, type="l",col=2)

# Workplaces
df_il_workplaces <- ts(df_il$workplaces, start=1, end = 114, frequency=1)
autoplot(df_il_workplaces,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces")
df_il_workplaces_train <- window(df_il_workplaces, start=1, end=100)
autoplot(df_il_workplaces_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces  (train dataset)")
df_il_workplaces_test <- window(df_il_workplaces, start=101, end=114)
autoplot(df_il_workplaces_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces (test dataset)")

fit_Regression_ARMA_workplaces <- auto.arima(df_il_workplaces_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_workplaces)
checkresiduals(fit_Regression_ARMA_workplaces)

forecast_Regression_ARMA_workplaces <- forecast(fit_Regression_ARMA_workplaces, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)

plot(forecast_Regression_ARMA_workplaces, col=1, include=12)
lines(df_il_workplaces_test, type="l",col=2)

# Residential
df_il_residential <- ts(df_il$residential, start=1, end = 114, frequency=1)
autoplot(df_il_residential,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential")
df_il_residential_train <- window(df_il_residential, start=1, end=100)
autoplot(df_il_residential_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential  (train dataset)")
df_il_residential_test <- window(df_il_residential, start=101, end=114)
autoplot(df_il_residential_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential (test dataset)")

fit_Regression_ARMA_residential <- auto.arima(df_il_residential_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_residential)
checkresiduals(fit_Regression_ARMA_residential)

forecast_Regression_ARMA_residential <- forecast(fit_Regression_ARMA_residential, xreg=cbind(rep(df_il_confirmed_cases_mean,14), rep(df_il_policy_mean,14)), h=14)
accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)

plot(forecast_Regression_ARMA_residential, col=1, include=12)
lines(df_il_residential_test, type="l",col=2)


arimax_rmse_retail_train = accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)[1,2]
arimax_rmse_retail_test = accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)[2,2]
arimax_rmse_grocery_train = accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)[1,2]
arimax_rmse_grocery_test = accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)[2,2]
arimax_rmse_parks_train = accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)[1,2]
arimax_rmse_parks_test = accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)[2,2]
arimax_rmse_transit_train = accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)[1,2]
arimax_rmse_transit_test = accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)[2,2]
arimax_rmse_workplaces_train = accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)[1,2]
arimax_rmse_workplaces_test = accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)[2,2]
arimax_rmse_residential_train = accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)[1,2]
arimax_rmse_residential_test = accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)[2,2]

a = rbind(c(arimax_rmse_retail_train,arimax_rmse_retail_test), c(arimax_rmse_grocery_train,arimax_rmse_grocery_test), c(arimax_rmse_parks_train,arimax_rmse_parks_test), c(arimax_rmse_transit_train,arimax_rmse_transit_test), c(arimax_rmse_workplaces_train,arimax_rmse_workplaces_test), c(arimax_rmse_residential_train,arimax_rmse_residential_test))
colnames(a) <- c("train","test")
rownames(a) <- c("retail","grocery","parks","transit","workplaces","residential")
a




# ARIMAX model/Regression with ARIMA Errors - forecast 7 days
datapath<-"~/Desktop/data"
df_il<-read.csv(file=paste(datapath,"df_il.csv",sep="/"),header=TRUE,sep=",")
df_il

df_il_confirmed_cases <- ts(df_il$confirmed_cases, start=1, frequency=1)
df_il_confirmed_cases <- log(df_il_confirmed_cases)
df_il_confirmed_cases_train <- window(df_il_confirmed_cases, start=1, end=107)
autoplot(df_il_confirmed_cases_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_confirmed_cases_test <- window(df_il_confirmed_cases, start=108, end=114)
autoplot(df_il_confirmed_cases_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
df_il_confirmed_cases_mean <- mean(df_il_confirmed_cases_test)

df_il_policy <- ts(df_il$policy, start=1, frequency=1)
df_il_policy_train <- window(df_il_policy, start=1, end=107)
autoplot(df_il_policy_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_policy_test <- window(df_il_policy, start=108, end=114)
autoplot(df_il_policy_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
df_il_policy_mean <- mean(df_il_policy_test)

#df_il_death <- ts(df_il$deaths, start=1, frequency=1)
#df_il_death_train <- window(df_il_death, start=1, end=107)
#autoplot(df_il_death_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
#df_il_death_test <- window(df_il_death, start=108, end=114)
#autoplot(df_il_death_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")
#df_il_death_mean <- mean(df_il_death_test)


# Retail and recreation
df_il_retail <- ts(df_il$retail_and_recreation, start=1, end = 114, frequency=1)
autoplot(df_il_retail,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation")
df_il_retail_train <- window(df_il_retail, start=1, end=107)
autoplot(df_il_retail_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation  (train dataset)")
df_il_retail_test <- window(df_il_retail, start=108, end=114)
autoplot(df_il_retail_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Retail and Recreation (test dataset)")

fit_Regression_ARMA_retail <- auto.arima(df_il_retail_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_retail)
checkresiduals(fit_Regression_ARMA_retail)

forecast_Regression_ARMA_retail <- forecast(fit_Regression_ARMA_retail, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)

plot(forecast_Regression_ARMA_retail, col=1, include=12)
lines(df_il_retail_test, type="l",col=2)

# Grocery and pharmacy
df_il_grocery <- ts(df_il$grocery_and_pharmacy, start=1, end = 114, frequency=1)
autoplot(df_il_grocery,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy")
df_il_grocery_train <- window(df_il_grocery, start=1, end=107)
autoplot(df_il_grocery_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy  (train dataset)")
df_il_grocery_test <- window(df_il_grocery, start=108, end=114)
autoplot(df_il_grocery_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Grocery and Pharmacy (test dataset)")

fit_Regression_ARMA_grocery <- auto.arima(df_il_grocery_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_grocery)
checkresiduals(fit_Regression_ARMA_grocery)

forecast_Regression_ARMA_grocery <- forecast(fit_Regression_ARMA_grocery, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)

plot(forecast_Regression_ARMA_grocery, col=1, include=12)
lines(df_il_grocery_test, type="l",col=2)

# Parks
df_il_parks <- ts(df_il$parks, start=1, end = 114, frequency=1)
autoplot(df_il_parks,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks")
df_il_parks_train <- window(df_il_parks, start=1, end=107)
autoplot(df_il_parks_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks  (train dataset)")
df_il_parks_test <- window(df_il_parks, start=108, end=114)
autoplot(df_il_parks_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Parks (test dataset)")

fit_Regression_ARMA_parks <- auto.arima(df_il_parks_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_parks)
checkresiduals(fit_Regression_ARMA_parks)

forecast_Regression_ARMA_parks <- forecast(fit_Regression_ARMA_parks, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)

plot(forecast_Regression_ARMA_parks, col=1, include=12)
lines(df_il_parks_test, type="l",col=2)

# Transit
df_il_transit <- ts(df_il$transit_stations, start=1, end = 114, frequency=1)
autoplot(df_il_transit,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations")
df_il_transit_train <- window(df_il_transit, start=1, end=107)
autoplot(df_il_transit_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations  (train dataset)")
df_il_transit_test <- window(df_il_transit, start=108, end=114)
autoplot(df_il_transit_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Transit Stations (test dataset)")

fit_Regression_ARMA_transit <- auto.arima(df_il_transit_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_transit)
checkresiduals(fit_Regression_ARMA_transit)

forecast_Regression_ARMA_transit <- forecast(fit_Regression_ARMA_transit, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)

plot(forecast_Regression_ARMA_transit, col=1, include=12)
lines(df_il_transit_test, type="l",col=2)

# Workplaces
df_il_workplaces <- ts(df_il$workplaces, start=1, end = 114, frequency=1)
autoplot(df_il_workplaces,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces")
df_il_workplaces_train <- window(df_il_workplaces, start=1, end=107)
autoplot(df_il_workplaces_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces  (train dataset)")
df_il_workplaces_test <- window(df_il_workplaces, start=108, end=114)
autoplot(df_il_workplaces_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Workplaces (test dataset)")

fit_Regression_ARMA_workplaces <- auto.arima(df_il_workplaces_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_workplaces)
checkresiduals(fit_Regression_ARMA_workplaces)

forecast_Regression_ARMA_workplaces <- forecast(fit_Regression_ARMA_workplaces, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)

plot(forecast_Regression_ARMA_workplaces, col=1, include=12)
lines(df_il_workplaces_test, type="l",col=2)

# Residential
df_il_residential <- ts(df_il$residential, start=1, end = 114, frequency=1)
autoplot(df_il_residential,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential")
df_il_residential_train <- window(df_il_residential, start=1, end=107)
autoplot(df_il_residential_train,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential  (train dataset)")
df_il_residential_test <- window(df_il_residential, start=108, end=114)
autoplot(df_il_residential_test,color = "darkblue")+ xlab("Week") + ylab("Percentage")+ggtitle("Residential (test dataset)")

fit_Regression_ARMA_residential <- auto.arima(df_il_residential_train, trace = TRUE, ic = 'aicc', xreg=cbind(df_il_confirmed_cases_train, df_il_policy_train))
summary(fit_Regression_ARMA_residential)
checkresiduals(fit_Regression_ARMA_residential)

forecast_Regression_ARMA_residential <- forecast(fit_Regression_ARMA_residential, xreg=cbind(rep(df_il_confirmed_cases_mean,7), rep(df_il_policy_mean,7)), h=7)
accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)

plot(forecast_Regression_ARMA_residential, col=1, include=12)
lines(df_il_residential_test, type="l",col=2)


arimax_rmse_retail_train = accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)[1,2]
arimax_rmse_retail_test = accuracy(forecast_Regression_ARMA_retail, df_il_retail_test)[2,2]
arimax_rmse_grocery_train = accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)[1,2]
arimax_rmse_grocery_test = accuracy(forecast_Regression_ARMA_grocery, df_il_grocery_test)[2,2]
arimax_rmse_parks_train = accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)[1,2]
arimax_rmse_parks_test = accuracy(forecast_Regression_ARMA_parks, df_il_parks_test)[2,2]
arimax_rmse_transit_train = accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)[1,2]
arimax_rmse_transit_test = accuracy(forecast_Regression_ARMA_transit, df_il_transit_test)[2,2]
arimax_rmse_workplaces_train = accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)[1,2]
arimax_rmse_workplaces_test = accuracy(forecast_Regression_ARMA_workplaces, df_il_workplaces_test)[2,2]
arimax_rmse_residential_train = accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)[1,2]
arimax_rmse_residential_test = accuracy(forecast_Regression_ARMA_residential, df_il_residential_test)[2,2]

b = rbind(c(arimax_rmse_retail_train,arimax_rmse_retail_test), c(arimax_rmse_grocery_train,arimax_rmse_grocery_test), c(arimax_rmse_parks_train,arimax_rmse_parks_test), c(arimax_rmse_transit_train,arimax_rmse_transit_test), c(arimax_rmse_workplaces_train,arimax_rmse_workplaces_test), c(arimax_rmse_residential_train,arimax_rmse_residential_test))
colnames(b) <- c("train","test")
rownames(b) <- c("retail","grocery","parks","transit","workplaces","residential")
b

cor(df_il$confirmed_cases,df_il$deaths)
cor(df_il$confirmed_cases,df_il$policy)

# forecasting 14 days
a
# forecasting 7 days
b

