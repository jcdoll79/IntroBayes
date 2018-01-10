#This line sets the working directory to the location of this file
#In Rstudio
#This director must have all data files and Stan model code needed.
#If you receive an error, manually set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(rstan)

# read data.
fish<-read.csv("Monroe_11.csv")


# Specify the data in a list, for later shipment to JAGS:
dataListRef = list(
  TL = fish$TL,
  AGE = fish$Age ,
  N = length((fish$Age))
)

# Initial values of MCMC chains based on data:
initslstRef <- lapply(1:3,function(i) {
    list( logLinf = log(rnorm(1,max(dataListRef$TL),1)) , logK = log(runif(1,0.01,5)), sigma=runif(1,1,10), t0=rnorm(1,1,1) )
})

#Compile and fit model using Stan 
stanfitReference <- stan(file = 'Bayes_LVB_Reference_Stan.stan',
                          data = dataListRef , 
                          init = initslstRef,
                          chains = 3,
                          iter = 1000 ,
                          warmup = 500 , 
                          thin = 3)
#Examine results
stanfitReference

#View traceplots for diagnostics
traceplot(stanfitReference,pars=c("sigma_y","t0","logLinf","logk","Linf","k"),nrow=3)+
          ggtitle("Traceplot of von Bertalanffy growth model with reference prior probabilty distributions")
