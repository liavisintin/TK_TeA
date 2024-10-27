wd <- getwd()
setwd("iTTC")
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

n_unc <- nrow(TTC)

moe.prob <- data.frame()

for (i in 1:n_unc) {
  iTTC_ran <- TTC$bmd[i]/(TTC$AF_interTD[i]*TTC$Intra_GSD.TD[i]^zrand) #unit: nmol/L
  iTTC_u_ran <- (TTC$bmd[i]*TTC$Cltot.GM[i]*TTC$kufrac.GM[i]*24)/(TTC$AF_interTD[i]*TTC$IntraTKTD_GSD[i]^zrand) #unit: nmol/kg-day
  # Plasma Groningen
  moe_gron <- (iTTC_ran*197.23/1000)/sample(plasma_groningen$CTeA.blood..ng.mL.,npop,replace=TRUE)
  prob_gron <- (sum(moe_gron < 1)/length(moe_gron))*100
  # Plasma Toddlers
  moe_todd <- (iTTC_ran*197.23/1000)/sample(plasma_toddlers$CTeA.blood..ng.mL.,npop,replace=TRUE)
  prob_todd <- (sum(moe_todd < 1)/length(moe_todd))*100
  # Plasma Epic Controls
  moe_epcon <- (iTTC_ran*197.23/1000)/sample(plasma_epic.control$CTeA.blood..ng.mL.,npop,replace=TRUE)
  prob_epcon <- (sum(moe_epcon < 1)/length(moe_epcon))*100
  # Urine Asam
  moe_u.asam <- (iTTC_u_ran*197.23*0.001)/sample(urine_asam$X24h.excretion.µg.Kg.bw.d,npop,replace=TRUE)
  prob_u.asam <- (sum(moe_u.asam < 1)/length(moe_u.asam))*100
  # Urine De Ruyck
  moe_u.dr <- (iTTC_u_ran*197.23*0.001)/sample(urine_dr$X24h.excretion.µg.Kg.bw.d,npop,replace=TRUE)
  prob_u.dr <- (sum(moe_u.dr < 1)/length(moe_u.dr))*100
  moe.prob <- rbind(moe.prob,
                    data.frame(prob_gron,
                               prob_todd,
                               prob_epcon,
                               prob_u.asam,
                               prob_u.dr))
}

write.csv(moe.prob,file="ProbiIMOETTC.csv",row.names = FALSE)
setwd(wd)
