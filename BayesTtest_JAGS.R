##############################################################################
##############################################################################
#
# JAGS and R code to compares relative weight between two groups using a 
# Bayesian two-sample t-test
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

#Likelihood

for ( i in 1:Ntotal ) {
  y[i] ~ dnorm( mu[x[i]] , 1/(sigma[x[i]]^2))
}

#Priors
for ( j in 1:2 ) {
  mu[j] ~ dnorm( 0 , 1/(1000)^2 ) #note 1/(1000)^2 for precision is equivalent to standard deviation = 1000
  sigma[j] ~ dunif(0,20)
}


#Derrived quantities
diff<-mu[1]-mu[2]  #difference between means
diffSD<-sigma[1]-sigma[2]  #difference between standard deviation

}

" # close quote for modelstring
writeLines(modelstring,con="Bayes_t_test.txt")


# THE DATA.

#fish<-read.csv("LMB_Wr.csv")
fish<-read.csv("wr.csv")

y = fish$Wr
y1=subset(y,fish$Year==1992)
y2=subset(y,fish$Year==2002)
y=c(y1,y2)

x = c( rep(1,length(y1)) , rep(2,length(y2)) ) # create group membership code

# Specify the data in a list, for later shipment to JAGS:
dataList = list(
  y = y ,
  x = x ,
  Ntotal = length(x)
)


# INTIALIZE THE CHAINS.
# Initial values of MCMC chains based on arithmetic mean and sd of the data:

mu = mean(y)
sigma = sd(y)

# initial values are used to start the chain near reasonable values
# The starting point are based on the data but randomly selected so the 
# three chains start at different values
initsList = lapply(1:3,function(i) {list(mu = rnorm(2,mu,1) , sigma = rnorm(1,sigma,1) )})


# RUN THE CHAINS

parameters = c( "mu" , "sigma" , "diff" , "diffSD")  # beta The parameter(s) to be monitored.
adaptSteps = 500              # Number of steps to "tune" the samplers.
burnInSteps = 500            # Number of steps to "burn-in" the samplers.
nChains = 3                   # Number of chains to run.
numSavedSteps=1000           # Total number of steps in chains to save.
thinSteps= 3                   # Number of steps to "thin" (1=keep every step).
nPerChain = ceiling( ( numSavedSteps * thinSteps ) / nChains ) # Steps per chain.

# Create, initialize, and adapt the model:
jagsModel = jags.model( "Bayes_t_test.txt" , data=dataList ,#  inits=initsList ,
                        n.chains=nChains , n.adapt=adaptSteps )

# Burn-in:
cat( "Burning in the MCMC chain...\n" )
update( jagsModel , n.iter=burnInSteps )

#Evaluate DIC if you are doing model comparisons. Not needed to here.
Jagsttest = coda.samples( jagsModel , variable.names=parameters , 
                        n.iter=nPerChain , thin=thinSteps )

summary(Jagsttest)

#convergence diagnostics
gelman.diag(Jagsttest,confidence=0.95,multivariate=FALSE)

#View traceplot of mu and sigma
mcmc_trace(Jagsttest,pars=c("mu[1]","mu[2]","sigma[1]","sigma[2]"))+
  ggtitle("Traceplot of of two-sample Bayesian t-test")


#convert Jags output to matrix
WR_mcmc= as.matrix(Jagsttest)

#determine percent of iterations of Wr in 2002 that is less than or equal to 73
length(subset(WR_mcmc,WR_mcmc[,4] <=73))/length(WR_mcmc)

