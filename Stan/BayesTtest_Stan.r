#This line sets the working directory to the location of this file
#In Rstudio
#This director must have all data files and Stan model code needed.
#If you receive an error, manually set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


#load libraries
library(rstan)

# THE DATA.
#read data
fish<-read.csv("wr.csv")

#assign Wr values to y
y = fish$Wr

#subset data to calculate values for initializing chain
y1=subset(y,fish$Year==1992)
y2=subset(y,fish$Year==2002)

#Generate group membership numbers
x = c( rep(1,length(y1)) , rep(2,length(y2)) )

# Specify the data in a list, for later shipment to Stan:
dataList = list(
  y = y ,
  group = x ,
  Ntotal = length(y)
)

# Initial values of MCMC chains based on data:
mu = mean(y)
sigma = sd(y)


initslst <- lapply(1:3,function(i) {
  list(mu = rnorm(2,mu,1) , sigma = rnorm(2,sigma,1) )
})

#Compile and fit model using Stan 
stanTtest<- stan(file = 'BayesTtest_Stan.stan',
                 data = dataList , 
                 init = initslst,
                 chains = 3,
                 iter = 1000 , 
                 warmup = 500 ,  
                 thin = 3)

#Examine results
stanTtest

#View traceplots for diagnostics
traceplot(stanTtest,pars=c("mu[1]","mu[2]","sigma[1]","sigma[2]"),nrow=3)+
               ggtitle("Traceplot of two-sample Bayesian t-test")

