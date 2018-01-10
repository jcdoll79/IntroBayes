##############################################################################
##############################################################################
#
# JAGS and R code for fitting the von Bertalanffy growth model with reference 
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

#Priors
logLinf ~ dnorm(0,1/1000)T(-10,10)
logK ~ dnorm(0,1/1000)T(-5,5)
t0 ~ dnorm(0,1/1000)

tau = 1/(sigma^2)
sigma ~ dunif(0,100)

#Exponentiate parameters
Linf = exp(logLinf)
K = exp(logK)

}


" # close quote for modelstring
writeLines(modelstring,con="LVBmodel_ref.txt")

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# THE DATA.

fish<-read.csv("Monroe_11.csv")

# Specify the data in a list, for later shipment to JAGS:
dataList = list(
  tl = fish$TL,
  age = fish$Age ,
  N = length((fish$Age))
)

#------------------------------------------------------------------------------
# INTIALIZE THE CHAINS.
# Initial values of MCMC chains:

# initial values are used to start the chain near reasonable values
# The starting point are based on the data but randomly selected so the 
# three chains start at different values
initsList = lapply(1:3,function(i) {list( logLinf = log(rnorm(1,max(dataList$tl),1)) , logK = log(runif(0.01,5)), sigma=runif(1,1,10), t0=rnorm(1,1,1) )})



#------------------------------------------------------------------------------

# RUN THE CHAINS


parameters = c( "Linf" , "K" , "t0" , "sigma")  # beta The parameter(s) to be monitored.
adaptSteps = 500              # Number of steps to "tune" the samplers.
burnInSteps = 50000            # Number of steps to "burn-in" the samplers.
nChains = 3                   # Number of chains to run.
numSavedSteps=500000           # Total number of steps in chains to save.
thinSteps= 15                    # Number of steps to "thin" (1=keep every step).
nPerChain = ceiling( ( numSavedSteps * thinSteps ) / nChains ) # Steps per chain.

# Create, initialize, and adapt the model:
jagsModel = jags.model( "LVBmodel_ref.txt" , data=dataList , inits=initsList ,
                        n.chains=nChains , n.adapt=adaptSteps )

# Burn-in:
cat( "Burning in the MCMC chain...\n" )
update( jagsModel , n.iter=burnInSteps )

#This could take several minutes
#saved itterations for with reference priors
mcmcLVB_ref = coda.samples( jagsModel , variable.names=parameters , 
                          n.iter=nPerChain , thin=thinSteps )



summary(mcmcLVB_ref)
gelman.diag(mcmcLVB_ref,confidence=0.95,multivariate=T)

mcmc_trace(mcmcLVB_ref,pars=c("sigma","t0","Linf","K"))+
    ggtitle("Traceplot of von Bertalanffy growth model with reference \n prior probabilty distributions")


