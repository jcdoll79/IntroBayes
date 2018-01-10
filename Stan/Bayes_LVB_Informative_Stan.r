#This line sets the working directory to the location of this file
#In Rstudio
#This director must have all data files and Stan model code needed.
#If you receive an error, manually set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(rstan)

# read data.
fish<-read.csv("Monroe_11.csv")
priors<-read.csv("priors.csv")

#Generate mean and standard deviation for prior probability distribuiton
linf_mean<-mean(log(priors$Loo))
k_mean<-mean(log(priors$K))
t0_mean<-mean(priors$to)
linf_sd<-sqrt(sd(log(priors$Loo)))
k_sd<-sqrt(sd(log(priors$K)))
t0_sd<-sqrt(sd(priors$to))

# Specify the data in a list, for later shipment to JAGS:
dataListInf = list(
  TL = fish$TL,
  AGE = fish$Age ,
  N = length((fish$Age)),
  muLinf = linf_mean,
  muk = k_mean,
  mut0 = t0_mean,
  sdLinf = linf_sd,
  sdk = k_sd,
  sdt0 = t0_sd
)

# Initial values of MCMC chains based on data:
initslstInf <- lapply(1:3,function(i) {
  list( logLinf = log(rnorm(1,max(dataListInf$TL),1)) , logK = log(runif(1,0.01,5)), sigma=runif(1,1,10), t0=rnorm(1,1,1) )
})

#Compile and fit model using Stan 
stanfitInformative<- stan(file = 'Bayes_LVB_Informative_Stan.stan',
                          data = dataListInf , 
                          init = initslstInf,
                          chains = 3,
                          iter = 1000 ,
                          warmup = 500 ,
                          thin = 3)
#Examine results
stanfitInformative

#View traceplots for diagnostics
traceplot(stanfitInformative,pars=c("sigma_y","t0","logLinf","logk","Linf","k"),nrow=3)+
  ggtitle("Traceplot of von Bertalanffy growth model with informative prior probabilty distributions")

