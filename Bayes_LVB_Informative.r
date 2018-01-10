
##############################################################################
##############################################################################
#
# JAGS and R code for fitting the von Bertalanffy growth model with informative 
# prior probability distributions on L-infinity, K, and t0.
#
# To accompany:
# Doll, J.C. and S.J. Jacquemin. In press. An introduction to Bayesian inference 
# for fisheries scientists. Fisheries Magazine.
#
# Jason Doll
#
##############################################################################
##############################################################################



#This line sets the working directory to the location of this file in Rstudio
#This directory must have all data files needed.
#If you receive an error, manually set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

require(bayesplot)
require(ggplot2)
require(rjags)

#THE MODEL.
modelstring = "
model {

#Likelihood for each individual
for (i in 1:N) { 
  tl[i] ~ dnorm(mu[i],tau)
  mu[i] = Linf*(1-exp(-K*(age[i]-t0)))  
}

#informative priors
logLinf ~ dnorm(linf_mean,1/linf_var)
logK ~ dnorm(k_mean,1/k_var)
t0 ~ dnorm(t0_mean,1/t0_var)

tau = 1/(sigma^2)
sigma ~ dunif(0,100)

#Exponentiate parameters
Linf = exp(logLinf)
K = exp(logK)

}



" # close quote for modelstring
writeLines(modelstring,con="LVBmodel_inform.txt")

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# THE DATA.

fish<-read.csv("Monroe_11.csv")
priors<-read.csv("priors.csv")

linf_mean<-mean(log(priors$Loo))
linf_var<-(sd(log(priors$Loo)))^2
k_mean<-mean(log(priors$K))
k_var<-(sd(log(priors$K)))^2
t0_mean<-mean(priors$to)
t0_var<-(sd(priors$to))^2

# Specify the data in a list, for later shipment to JAGS:
dataList = list(
  tl = fish$TL,
  age = fish$Age ,
  N = length((fish$Age)),
  linf_mean = linf_mean,
  linf_var = linf_var,
  k_mean = k_mean,
  k_var = k_var,
  t0_mean = t0_mean,
  t0_var = t0_var
)

#------------------------------------------------------------------------------
# INTIALIZE THE CHAINS.
# Initial values of MCMC chains:

# initial values are used to start the chain near reasonable values
# The starting point are based on the data but randomly selected so the 
# three chains start at different values
initsList = lapply(1:3,function(i) {list( logLinf = log(rnorm(1,max(dataList$tl),1)) , logK = log(runif(1,0.01,5)), sigma=runif(1,1,10), t0=rnorm(1,1,1) )})


#------------------------------------------------------------------------------

# RUN THE CHAINS
parameters = c( "Linf" , "K" , "t0" , "sigma")  # beta The parameter(s) to be monitored.
adaptSteps = 500              # Number of steps to "tune" the samplers.
burnInSteps = 50000            # Number of steps to "burn-in" the samplers.
nChains = 3                   # Number of chains to run.
numSavedSteps=500000           # Total number of steps in chains to save.
thinSteps= 15                   # Number of steps to "thin" (1=keep every step).
nPerChain = ceiling( ( numSavedSteps * thinSteps ) / nChains ) # Steps per chain.

# Create, initialize, and adapt the model:
jagsModel = jags.model( "LVBmodel_inform.txt" , data=dataList , inits=initsList ,
                        n.chains=nChains , n.adapt=adaptSteps )

# Burn-in:
cat( "Burning in the MCMC chain...\n" )
update( jagsModel , n.iter=burnInSteps )

#This could take several minutes
#Evaluate samples
mcmcLVB_inform = coda.samples( jagsModel , variable.names=parameters , 
                              n.iter=nPerChain , thin=thinSteps )


summary(mcmcLVB_inform)
gelman.diag(mcmcLVB_inform,confidence=0.95,multivariate=T)


mcmc_trace(mcmcLVB_inform,pars=c("sigma","t0","Linf","K"))+
    ggtitle("Traceplot of von Bertalanffy growth model with informative \n prior probabilty distributions")

