
data {
  int<lower=0> N ;  // number of observations
  real TL[N] ;      // Total lengths of individual fish
  int AGE[N] ;      // Age of individual fish
  real muLinf;      // informative prior for mean Linf on log scale
  real muk;         // informative prior for mean k on log scale
  real mut0;        // informative prior for mean t0 on log scale
  real sdLinf;      // informative prior for standard deviation of Linf on log scale
  real sdk;         // informative prior for standard deviation of Linf on log scale
  real sdt0;        // informative prior for standard deviation of Linf on log scale
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
  
  //The next three lines of code specity informative prior probability distributions. These values are based on FishBase data on Walleye and must be specified in data block.
  logLinf ~ normal(muLinf, sdLinf);
  logk ~ normal(muk, sdk);
  t0 ~ normal(mut0, sdt0);
  
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

