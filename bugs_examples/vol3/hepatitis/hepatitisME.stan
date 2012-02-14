
# Hepatitis: a normal hierarchical model with measurement 
# error
#  http://openbugs.info/Examples/Hepatitis.html

# model the measurement eror heres (compared with hepatitis.stan) 


## note that we have missing data in the orignal data Y[N, T]; 
## here, we turn Y[N, T] into Yvec with the missing
## data removed.  


data {
  int(0,) N1;              ## N1 is the length of the vector, Yvec1, that is 
  int(0,) N;               ## created from concatenate columns of matrix Y[N, T] 
  double Yvec1[N1];        ## with NA's removed. 
  double tvec1[N1];        ## N is the nrow of original matrix Y[N, T] 
  int(0,) idxn1[N1];       ## idxn1 maps Yvec to its orignal n index 
  double y0[N]; 
} 

transformed data {
  double y0_mean; 
  y0_mean <- mean(y0); 
} 

parameters {
  double(0,) sigmasq_y; 
  double(0,) sigmasq_y0; 
  double(0,) sigmasq_alpha; 
  double(0,) sigmasq_beta; 
  double(0,) sigmasq_mu0; 
  double gamma; 
  double alpha0; 
  double beta0; 
  double theta; 
  double mu0[N]; 
  double alpha[N]; 
  double beta[N]; 
} 

  
transformed parameters {
  double(0,) sigma_y; 
  double(0,) sigma_alpha; 
  double(0,) sigma_beta; 
  sigma_y <- sqrt(sigmasq_y); 
  sigma_alpha <- sqrt(sigmasq_alpha); 
  sigma_beta <- sqrt(sigmasq_beta); 
}
 
model {
  int oldn; 
  for (n in 1:N1) {
    oldn <- idxn1[n]; 
    Yvec1[n] ~ normal(alpha[oldn] + beta[oldn] * (tvec1[n] - 6.5) + gamma * (mu0[oldn] - y0_mean), sigma_y); 
  }

  mu0 ~ normal(theta, sqrt(sigmasq_mu0)); 
  for (n in 1:N) y0[n] ~ normal(mu0[n], sigma_y); 

  alpha ~ normal(alpha0, sigma_alpha); 
  beta ~ normal(beta0, sigma_beta); 

  sigmasq_y ~ inv_gamma(.001, .001); 
  sigmasq_alpha ~ inv_gamma(.001, .001); 
  sigmasq_beta ~ inv_gamma(.001, .001); 
  sigmasq_mu0 ~ inv_gamma(.001, .001); 
  alpha0 ~ normal(0, 1000); 
  beta0 ~ normal(0, 1000); 
  gamma ~ normal(0, 1000); 
  theta ~ normal(0, 1000); 
 
}