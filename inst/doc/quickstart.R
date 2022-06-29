## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)

## ----single-------------------------------------------------------------------
library(rivr)
myprofile = compute_profile(So = 0.001, n = 0.045, Q = 250, y0 = 2.5, 
  Cm = 1.486, g = 32.2, B = 100, SS = 0, stepdist = 50, totaldist = 3000)
head(myprofile)

## -----------------------------------------------------------------------------
library(reval)
library(dplyr)
library(future)
library(furrr)

# generate the argument table
arg_tbl = args_set(n = seq(0.03, 0.06, by = 0.005))

# define the plan (from 'future' package)
# could also use e.g. 'callr', 'multicore', etc.
plan(sequential) 

# get output as list-column of argument table
# using furrr:future_pmap
results = mutate(arg_tbl, 
  output = future_pmap(arg_tbl, compute_profile,
  So = 0.001, Q = 250, y0 = 2.5, Cm = 1.486, g = 32.2,
  B = 100, SS = 0, stepdist = 50, totaldist = 3000)
)

## ----plot-single, echo = FALSE------------------------------------------------
library(tidyr)
library(ggplot2)

ggplot(unnest(results, output)) +
  aes(x = x, y = y, color = factor(n)) +
  geom_line() +
  scale_color_viridis_d("Manning's n")

## -----------------------------------------------------------------------------
arg_tbl = args_permute(n = seq(0.03, 0.06, by = 0.005),
  So = seq(0.001, 0.0015, by = 0.00025),
  SS = seq(0, 6, by = 2)
)
results = mutate(arg_tbl, 
  output = future_pmap(arg_tbl, compute_profile,
    Q = 250, y0 = 2.5, Cm = 1.486, g = 32.2,
    B = 100, stepdist = 50, totaldist = 3000))

## ----plot-curves--------------------------------------------------------------
ggplot(unnest(results, output)) + 
  aes(x = x, y = y, color = factor(n)) + geom_line() + 
  facet_grid(SS ~ So) +
  scale_color_viridis_d("Manning's n")

