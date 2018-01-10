
data {
  int<lower=0> N ;  // number of observations
  real TL[N] ;      // Total lengths of individual fish
  int AGE[N] ;      // Age of individual fish
}

parameters {
  real<lower=0> sigma_y;              //LVB standard deviation
  real<lower=-5, upper=5> t0;         //LVB t0 parameters
  real<lower=-10, upper=10> logLinf;  //LVB log scale Linf
  real<lower=-5, upper=5> logk;       //LVB log scale k
}

transformed parameters{
  real Linf;
  real k;
  
  Linf = exp(logLinf);                //back transforming Linf to original scale
  k = exp(logk);                      //back transforming k to original scale
  
}

model {
  vector[N] ypred;
  
  sigma_y ~ uniform(0,100);           //reference prior for standard deviation
  
  //The next three lines of code specity reference prior probability distributions.
  logLinf ~ normal(0, 31.6);
  logk ~ normal(0, 31.6);
  t0 ~ normal(0, 31.6); 
  
  // calculate likelihood of data
  for(i in 1:N){
    ypred[i] =  Linf * (1-exp(-(k * (AGE[i]-t0) )) );
  }
  TL~normal(ypred, sigma_y);
  
}

generated quantities{
  //the nex four lines of code generate predicted values to use for inspecting model fit
  vector[N] predy;
  for(i in 1:N){
    predy[i] = normal_rng(Linf * (1-exp(-(k * (AGE[i]-t0) )) ) ,sigma_y);
  }
}

