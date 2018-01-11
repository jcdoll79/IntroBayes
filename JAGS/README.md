# Appendix A. JAGS and R code, Markov Chain Monte Carlo (MCMC) settings, and files accompanying “Introduction to Bayesian Inference for Fisheries Scientists”

<b>Software used</b>

Model parameters for both examples were estimated using Bayesian inference in R 3.4.0 (R Core Team 2017) using JAGS (Plummer 2003) and rjags 4.6 (Plummer 2016). All code will execute correctly after JAGS, R, and rjags is successfully installed. Note, all files need to be in the same folder and the working directory in R needs to be set to this folder.

<b>MCMC settings</b>

<i>Application: Yellow Perch (Perca flavescens) relative weight long term (1992 vs 2002) comparisons</i>

Three concurrent MCMC chains and consisted of 4,500 total iterations (split between the three chains), thinning every 3 steps, and discarding the first 500 steps for a total of 1000 saves steps. Convergence of the MCMC chains was checked using the potential scale-reduction factor (Ȓ). The chains have converged when Ȓ is close to one. Values near 1.0 suggests the MCMC chains have converged.

<i>Application: Monroe Reservoir Walleye (Sander vitreus) age and growth</i>

The von Bertalanffy model was estimated using three concurrent MCMC chains and consisted of 7,550,000 total iterations (split between the three chains), thinning every 15 steps, and discarding the first 50,000 steps for a total of 500,000 saves steps. The thinning steps were necessary to avoid auto-correlation in concurrent draws from the posterior distribution. Convergence of the MCMC chains was checked using the potential scale-reduction factor (Ȓ). The chains have converged when Ȓ is close to one. Values near 1.0 suggests the MCMC chains have converged.	

<b>Table of files and descriptions</b>

wr.csv: A table consisting of 1,701 observations of Yellow Perch sampled from Southern Lake Michigan. First column is Year of collection and second column is relative weights (Wr). Data supplied by the Indiana Department of Natural Resources and Ball State University.<br>
Monroe_11.csv: A table consisting of 33 observations of Walleye sampled from Monroe Reservoir in 2011. First column is total length (TL, cm) and second column is Age (Age, years). Data supplied by the Indiana Department of Natural Resources.<br>
priors.csv: A table consisting of 26 observations of Walleye von Bertalanffy growth model coefficients obtained from fishbase.org (Froese and Pauly 2017). Columns in order are; L-infinity, K, t0, and locality.<br>
BayesTtest_JAGS.r: JAGS and R code for Bayesian t-test<br>
Bayes_LVB_Informative.r:	JAGS and R code for fitting the von Bertalanffy growth model with informative prior probability distributions on L-infinity, K, and t0.<br>
Bayes_LVB_Reference.r:	JAGS and R code for fitting the von Bertalanffy growth model with reference prior probability distributions on L-infinity, K, and t0.<br>

<b>Literature Cited</b>

Froese, R. and D. Pauly. 2017. FishBase. World Wide Web electronic publication. www.fishbase.org. (accessed 07/01/2017).

Plummer, M. 2003. JAGS: a program for analysis of Bayesian graphical models using Gibbs sampling. In Proceedings of the 3rd International Workshop on Distributed Statistical Computing (DSC 2003), 20-23 March, Vienna, Austria. ISSN 1609-395X

Plummer, M. 2016. Rjags: Bayesian graphical models using MCMC. R package version 4-6. https://CRAN.R-project.org/package=rjags

R Core Team. 2017. R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.
