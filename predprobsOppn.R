#9/24/18
# Produces predicted probabilities for Oppn asking qs of ministers.
# (the probabilities for gov backbenchers asking ministers are calculated in a 
# way that is identical, modulo pulling out different roles)

# The notation, using L2, L3 etc is as laid out in supporting info E in the 
# original paper.

rm(list=ls())

#################################################
# predicted probabilities for a specific debate #
#################################################

#load original data: 
# this is needed for debate/ministry combinations
load("dat.big.rdata")

#now grab the results of the esimtates from the main model
load("results.rdata") 
pes <- results  

# We want to calculate Pr(Cab|Opp)
# this is Pr(Y=3|X=1) since oppn is coded as one

#Consider a particular debate number d65933, occuring in 
#Gladstone II. 
    #debate=paste(".d","65933","$",sep="")
    #grep(debate, colnames(pes)) #these are the deb random fx

    #ministry=paste("Gladstone II","$",sep="")
    #grep(ministry, colnames(pes))#these are the min random fx

#for this prob, we need
#exp(l3)/1+exp(l2)+exp(l3)
# --> note that these are lower case letter Ls, as in SI E of the original paper

###L2###
#l2 fixed fx are "traitys.state2" (b_1^(2)) only bec indicator is never 1
b12 <- pes[,"traitys.state2"]


#l2 d rfx are "debate.ys.state2.debate.d65933" (u^(2)_d1) only bec indicator    
u2d1 <- pes[,"debate.ys.state2.debate.d65933"]

    
#l2 m rfx are "ministry.ys.state2.ministry.Gladstone II" (u^(2)_m1) only
u2m1 <- pes[,"ministry.ys.state2.ministry.Gladstone II"]

    
###L3###
#l3 fixed fx are "traitys.state3" (b_1^(3)) only bec X=1 (see indicator etc)
b13 <- pes[,"traitys.state3"]

# l3 rfx for debates are "debate.aitys.state3.debate.d65933" (u^(3)_d1) only
u3d1 <- pes[,"debate.aitys.state3.debate.d65933"]


#l3 m rfx are  "ministry.aitys.state3.ministry.Gladstone II"  (u^(3)_m1) only
u3m1 <- pes[,"ministry.aitys.state3.ministry.Gladstone II"]


#let's add them up and see if this works
l2 <- mean(b12 + u2d1 +u2m1) 
l3 <- mean(b13 + u3d1 +u3m1)

#now calculate the probability
p.prob <- exp(l3)/(1+(exp(l2)+exp(l3)))
# should be ~0.14

##########################################
# predicted probabilities for ANY debate #
##########################################


get.pred <- function(deb="d65933"){

mini <- as.character(unique(subset(dat.big, dat.big$debate==deb)[,4]))

###L2
#l2 fixed fx are "traitys.state2" (b_1^(2))
b12 <- pes[,"traitys.state2"]


#l2 d rfx are "debate.ys.state2.debate.d65933" (u^(2)_d1) 
u2d1 <- pes[,paste("debate.ys.state2.debate",deb,sep=".")]
u2dh <- pes[,paste("debate.ys.state2:xs2.debate",deb,sep=".")]
    
#l2 m rfx are "ministry.ys.state2.ministry.Gladstone II" (u^(2)_m1)
u2m1 <- pes[,paste("ministry.ys.state2.ministry",mini,sep=".")]
    
    
##L3
#l3 fixed fx are "traitys.state3" (b_1^(3)) 
b13 <- pes[,"traitys.state3"]

# l3 rfx for debates are "debate.aitys.state3.debate.d65933" (u^(3)_d1)
u3d1 <- pes[,paste("debate.aitys.state3.debate",deb,sep=".")]



#l3 m rfx are  "ministry.aitys.state3.ministry.Gladstone II"  (u^(3)_m1)
u3m1 <- pes[,paste("ministry.aitys.state3.ministry", mini, sep=".")]



#let's add them up and see if this works
l2 <- mean(b12 + u2d1 +u2m1) 
l3 <- mean(b13 + u3d1 +u3m1) 

p.prob <- exp(l3)/(1+(exp(l2)+exp(l3)))
}

gp <- c()

##################################################################
# Calculate the relevant pred prob for every debate in the data  #
##################################################################

for(i in 1:length(unique(dat.big$debate)))
{
gp <-c(gp, get.pred(unique(dat.big$debate)[i]))
cat(i,"of",length(unique(dat.big$debate)),"\n\n")
}

#match each pred with a debate number
mdeb <- match( unique(dat.big$debate), dat.big$debate)

pred.prob.debO <- data.frame(ministry = dat.big$ministry[mdeb] , 
                        deb.num = unique(dat.big$debate), pred.MgivenO = gp )

#pred.prob.debO is a data.frame containing the relevant pred probs for every
# debate in the data
