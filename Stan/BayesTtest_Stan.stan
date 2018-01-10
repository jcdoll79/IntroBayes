
data {
  int<lower=0> Ntotal;          // sample size
  real y[Ntotal];               // response
  int group[Ntotal];            // group ID
}

parameters {
  vector[2] mu;                   // estimated group means
  vector<lower=0>[2] sigma;       // estimated group standard deviation              
  }
  
model {
  // priors
  for (x in 1:2){
  mu[x] ~ normal(0, 31.6);        //Reference prior for group means  
  sigma[x] ~ uniform(0, 20);      //Reference prior for group standard deviation
  }
  
  // likelihood
  for (n in 1:Ntotal){
    y[n] ~ normal(mu[group[n]], sigma[group[n]]);

  }
}

generated quantities {
  real muDiff;                      //difference between means
  real sigmaDiff;                   //difference between stand deviation
  
  muDiff = mu[1] - mu[2];
  sigmaDiff = sigma[1] - sigma[2];
}

