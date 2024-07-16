ttc.df <- read.csv("iTTC01 quantiles.csv")
#TeA molecular weight: 197.23 g/mol
#prob iTTC in blood: 0.4977291 nmol/L
#prob iTTC in urine: 2.525289 nmol/kg-day

ttc_blood <- ttc.df[2,6]*197.23/1000 #unit: ng/ml
ttc_urine <- ttc.df[2,14]*197.23*0.001 #unit: ug/kg-day

plasma_groningen <- read.csv("plasma_groningen.csv") #unit: ng/ml

plasma_toddlers <- read.csv("plasma_toddlers Burkina.csv") #unit: ng/ml

plasma_epic.control <- read.csv("plasma_epic control.csv") #unit: ng/ml

urine_asam <- read.csv("asam 24h-urine.csv") #unit: ug/kg-day

urine_dr <- read.csv("Urine collection_De Ruyck_LV.csv") #unit: ug/kg-day

plasma_groningen$HQ <- plasma_groningen$CTeA.blood..ng.mL./ttc_blood
plasma_toddlers$HQ <- plasma_toddlers$CTeA.blood..ng.mL./ttc_blood
plasma_epic.control$HQ <- plasma_epic.control$CTeA.blood..ng.mL./ttc_blood
urine_asam$HQ <- urine_asam$X24h.excretion.µg.Kg.bw.d/ttc_urine
urine_dr$HQ <- urine_dr$X24h.excretion.µg.Kg.bw.d/ttc_urine

TTC <- read.csv("iTTC01.csv")
set.seed(1234)

npop <- 10000
zrand <- rnorm(npop)
for (i in 1:npop){
  z_i <- zrand[i]
  iTTC_ran <- TTC$bmd/(TTC$AF_interTD*TTC$Intra_GSD.TD^z_i) #unit: nmol/L
  iTTC_u_ran <- (TTC$bmd*TTC$Cltot.GM*TTC$kufrac.GM*24)/(TTC$AF_interTD*TTC$IntraTKTD_GSD^z_i) #unit: nmol/kg-day
  
  for (j in 1:nrow(plasma_groningen)){
    ind <- plasma_groningen$CTeA.blood..ng.mL.[j]
    moe <- (iTTC_ran*197.23/1000)/ind
    prob <- (sum(moe < 1)/length(moe))*100
    plasma_groningen$prob[j] <- prob
  }
  
  for (k in 1:nrow(plasma_toddlers)){
    ind_todd <- plasma_toddlers$CTeA.blood..ng.mL.[k]
    moe_todd <- (iTTC_ran*197.23/1000)/ind_todd
    prob_todd <- (sum(moe_todd < 1)/length(moe_todd))*100
    plasma_toddlers$prob[k] <- prob_todd
  }
  
  for (l in 1:nrow(plasma_epic.control)){
    ind_epcon <- plasma_epic.control$CTeA.blood..ng.mL.[l]
    moe_epcon <- (iTTC_ran*197.23/1000)/ind_epcon
    prob_epcon <- (sum(moe_epcon < 1)/length(moe_epcon))*100
    plasma_epic.control$prob[l] <- prob_epcon
  }
  
  for (m in 1:nrow(urine_asam)){
    ind_u.asam <- urine_asam$X24h.excretion.µg.Kg.bw.d[m]
    moe_u.asam <- (iTTC_u_ran*197.23*0.001)/ind_u.asam
    prob_u.asam <- (sum(moe_u.asam < 1)/length(moe_u.asam))*100
    urine_asam$prob[m] <- prob_u.asam
  }
  
  for (n in 1:nrow(urine_dr)){
    ind_u.dr <- urine_dr$X24h.excretion.µg.Kg.bw.d[n]
    moe_u.dr <- (iTTC_u_ran*197.23*0.001)/ind_u.dr
    prob_u.dr <- (sum(moe_u.dr < 1)/length(moe_u.dr))*100
    urine_dr$prob[n] <- prob_u.dr
  }
  
}

write.csv(plasma_groningen, file="HQ iMOE plasma_groningen.csv", row.names = FALSE)
write.csv(plasma_toddlers, file="HQ iMOE plasma_toddlers.csv", row.names = FALSE)
write.csv(plasma_epic.control, file="HQ iMOE plasma_epic.control.csv", row.names = FALSE)
write.csv(urine_asam, file="HQ iMOE urine_asam.csv", row.names = FALSE)
write.csv(urine_dr, file="HQ iMOE urine_dr.csv", row.names = FALSE)
