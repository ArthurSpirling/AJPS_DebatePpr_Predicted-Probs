# AJPS Debate Paper, Predicted Probabilities

Eggers and Spirling (2013) use an MCMC glmm model for modeling debates in the UK parliament.  Although all the code for the 'main model' is on the AJPS DVN, users may also want to calculate auxillary quantities like the predicted probability of say, a minister speaking given a member of the opposition just spoke.  This is as described in Supporting Information E, "Mixed Modeling of Debates".


Unsurprisingly, this involves grabbing the relevant random effects and fixed effects and calculating a standard logit-based predicted probability.

This repository includes: 
- two data files, `dat.big` which is the underlying data and importantly includes the unique debate codes; and `results.rdata` which are the coefficients (etc) from running the main model
- a single R script, `predprobsOppn.R` which takes the debate code from `dat.big` and calculates the relevant predicted probability using the estimated effects from `results.rdata`.  Notice that the structure of the script is that it first provides a function for a *particular* debate (d65933) so that the logic of the calculation is spelled out,  before providing a more generic function `get.pred()` for doing all the debates.  That latter function takes some time since there are ~18000 debates in all.