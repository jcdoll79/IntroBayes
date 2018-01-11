# Appendix B. Stan and R code, Markov Chain Monte Carlo (MCMC) settings, and file accompanying “Introduction to Bayesian Inference for Fisheries Scientists”

<b>Software used</b>

Model parameters for both examples were estimated using Bayesian inference in R 3.4.0 (R Core Team 2017) using Stan (Carpenter et al. 2017) and RStan 2.15.1 (Stan Development Team 2017).

<b>MCMC settings</b>

<i>Application: Yellow Perch (Perca flavescens) relative weight long term (1992 vs 2002) comparisons</i>

Three concurrent MCMC chains and consisted of 1000 iterations, thinning every 3 steps, and discarding the first 500 steps for a total of 167 saves steps per chain. Convergence of the MCMC chains was checked using the potential scale-reduction factor (Ȓ). The chains have converged when Ȓ is close to one. Values near 1.0 suggests the MCMC chains have converged.

<i>Application: Monroe Reservoir Walleye (Sander vitreus) age and growth</i>

The von Bertalanffy model was estimated using three concurrent MCMC chains and consisted of 1000 iterations, thinning every 3 steps, and discarding the first 500 steps for a total of 167 saves steps per chain. The thinning steps were necessary to avoid auto-correlation in concurrent draws from the posterior distribution. Convergence of the MCMC chains was checked using the potential scale-reduction factor (Ȓ). The chains have converged when Ȓ is close to one. Values near 1.0 suggests the MCMC chains have converged.	

<b>Table of files and descriptions</b>

wr.csv: A table consisting of 1,701 observations of Yellow Perch sampled from Southern Lake Michigan. First column is Year of collection and second column is relative weights (Wr). Data supplied by the Indiana Department of Natural Resources and Ball State University.<br>
Monroe_11.csv: A table consisting of 33 observations of Walleye sampled from Monroe Reservoir in 2011. First column is total length (TL, cm) and second column is Age (Age, years). Data supplied by the Indiana Department of Natural Resources.<br>
priors.csv: A table consisting of 26 observations of Walleye von Bertalanffy growth model coefficients obtained from fishbase.org (Froese and Pauly 2017). Columns in order are; L-infinity, K, t0, and locality.<br>
BayesTtest_Stan.stan:	Stan code for Bayesian t-test<br>
Bayes_LVB_Informative_Stan.stan:	Stan code for fitting the von Bertalanffy growth model with informative prior probability distributions on L-infinity, K, and t0.<br>
Bayes_LVB_Reference_Stan.stan:	Stan code for fitting the von Bertalanffy growth model with reference prior probability distributions on L-infinity, K, and t0.<br>
BayesTtest_Stan.r:	R code for executing the Bayesian t-test with the BayesTtest.stan model file<br>
Bayes_LVB_Informative_Stan.r:	R code for executing the von Bertalanffy growth model with informative prior probability distributions on L-infinity, K, and t0 with the Bayes_LVB_Informative.stan model file<br>
Bayes_LVB_Reference_Stan.r:	R code for executing the von Bertalanffy growth model with reference prior probability distributions on L-infinity, K, and t0 with the Bayes_LVB_Reference.stan model file


<b>Literature Cited</b>

Carpenter, B., A. Gelman, M.D. Hoffman, D. Lee, B. Goodrich, M. Bentaourt, M. Brubaker, J. Guo, P. Li, and A. Riddell. 2017. Stan: A probabilistic programming language. Journal of Statistical Software 76(1). DOI 10.18637/jss.v076.i01

Froese, R. and D. Pauly. 2017. FishBase. World Wide Web electronic publication. www.fishbase.org. (accessed 07/01/2017).

R Core Team. 2017. R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.

Stan Development Team. 2017. RStan: The R interface to Stan. R package version 2.16.2. http://mc-stan.org/.
