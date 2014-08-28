# Load data and get tot_time
data(Cetacea)
tot_time<-max(node.age(Cetacea)$ages)
data(InfTemp)
dof<-smooth.spline(InfTemp[,1], InfTemp[,2])$df
options(digits=16)

# Parameters for validation
precision_lh <- 3e-3
precision_aicc <- 2e-1
precision_param <- 5e-2


context("B exponential, function of temperature")
f.lamb <-function(t,x,y){y[1] * exp(y[2] * x)}
f.mu<-function(t,x,y){0}
lamb_par<-c(0.10, 0.01)
mu_par<-c()
res <- fit_env_bd(Cetacea,InfTemp,tot_time,f.lamb,f.mu,lamb_par,mu_par,f=87/89, fix.mu=TRUE, df=dof, cond="stem")

reference_lh <- -278.839
reference_aicc <- 561.820
reference_lamb <- c(0.09, 0.03)


test_that("B exponential, function of temperature",{
  expect_that( abs(res$LH - reference_lh)  , is_less_than(precision_lh) )
  expect_that( abs(res$aicc - reference_aicc)  , is_less_than(precision_aicc) )
  expect_that( abs(res$lamb_par[1] - reference_lamb[1])  , is_less_than(precision_param) ) 
  expect_that( abs(res$lamb_par[2] - reference_lamb[2])  , is_less_than(precision_param) ) 
})


context("B exponential, function of temperature & time")
f.lamb <-function(t,x,y){y[1] * exp(y[2] * t + y[3] * x)}
f.mu<-function(t,x,y){0}
lamb_par<-c(0.10, -0.01, 0.03)
mu_par<-c()
res <- fit_env_bd(Cetacea,InfTemp,tot_time,f.lamb,f.mu,lamb_par,mu_par,f=87/89, fix.mu=TRUE, df=dof, cond="stem")

reference_lh <- -278.739
reference_aicc <- 563.766
reference_lamb <- c(0.0859, -0.011, 0.06)

test_that("B exponential, function of temperature & time",{
  expect_that( abs(res$LH - reference_lh)  , is_less_than(precision_lh) )
  expect_that( abs(res$aicc - reference_aicc)  , is_less_than(precision_aicc) )
  expect_that( abs(res$lamb_par[1] - reference_lamb[1])  , is_less_than(precision_param) ) 
  expect_that( abs(res$lamb_par[2] - reference_lamb[2])  , is_less_than(precision_param) ) 
})
