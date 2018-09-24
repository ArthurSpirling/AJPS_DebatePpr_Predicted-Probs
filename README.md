# AJPS Debate Paper, Predicted Probabilities

Eggers and Spirling (2013) use an MCMC glmm model for modeling debates in the UK parliament.  Although all the code for the 'main model' is on the AJPS DVN, users may also want to calculate auxillary quantities like predicted probability of say, a minister speaking given a member of the opposition just spoke.  This is as described in Supporting Information E, "Mixed Modeling of Debates".


Unsurprisingly, this involves grabbing the relevant random effects and fixed effects and calculating a standard logit-based predicted probability.
