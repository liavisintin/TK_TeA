###BMD
#Arnot et al. (2022)
#Blood iTTC
#default: 22 nmol/L
#alternative: 8.5 nmol/L
#alternative: 8.3 nmol/L

ttc_gm <- (22*8.5*8.3)^(1/3)
ttc_mu <- (log(22)+log(8.5)+log(8.3))/3
ttc_var <- ((log(22)-ttc_mu)^2+(log(8.5)-ttc_mu)^2+(log(8.3)-ttc_mu)^2)/3
ttc_gsd <- exp(sqrt(ttc_var))

AF_noael_cont <- rlnorm(10000, meanlog = log(1/3), sdlog=log(4.7^(1/1.645)))
bmd <- rlnorm(10000, meanlog = log(ttc_gm), sdlog = log(ttc_gsd))/AF_noael_cont
cat("bmd", quantile(bmd, prob=c(0.5,0.05,0.95)), "\n")

#AF_noael_deter <- rlnorm(10000, meanlog = log(2/9), sdlog=log(5^(1/1.645)))
#bmd <- rlnorm(10000, meanlog = log(ttc_gm), sdlog = log(ttc_gsd))/AF_noael_deter
#cat("bmd", quantile(bmd, prob=c(0.5,0.05,0.95)), "\n")

### Interspecies TD
# Default TK/TD has GM=1, GSD=1.95
# Assume TK and TD are equal and independent
Inter_sigmaTD <- log(1.95)/sqrt(2)
AF_interTD <- rlnorm(10000,meanlog = 0, sdlog=Inter_sigmaTD)
cat("AF_interTD", quantile(AF_interTD, prob=c(0.5,0.05,0.95)), "\n")

### Intraspecies TD
# Log10(GSD_TD): P50=0.221, P95/P50=2.85
# Assume TK and TD are independent
# GSD_TD=10^0.221
Intra_GSD.TD <- rlnorm(10000, meanlog = log(10^0.221), sdlog = log(2.85^(1/1.645)))
#log.intraGSD.TD <- log(Intra_GSD.TD)
AF_intraTD <- Intra_GSD.TD^qnorm(0.99)
cat("Intra_GSD.TD", quantile(Intra_GSD.TD, prob=c(0.5,0.05,0.95)), "\n")
cat("AF_intraTD", quantile(AF_intraTD, prob=c(0.5,0.05,0.95)), "\n")

### iTTC01
iTTC01 <- bmd/(AF_interTD*AF_intraTD) #unit: nmol/L
cat("iTTC01", quantile(iTTC01, prob=c(0.5,0.05,0.95)), "\n")

###---------------------------------------------------------------------
### convert to urinary excretion
urine_par.df <- read.csv("pk posterior parameters.csv")
urine_par <- urine_par.df[1:500, 1:29]

# Total clearance of TeA  (L/Kg-hr)
GM_Cltot <- exp(urine_par$M_lnCltot.1.)
Cltot.GM <- rep(GM_Cltot, 20)[sample.int(10000)]
cat("Cltot.GM", quantile(Cltot.GM, prob=c(0.5,0.05,0.95)), "\n")

GSD_Cltot <- exp(urine_par$SD_lnCltot.1.)
GSD_Cltot.TK <- rep(GSD_Cltot, 20)[sample.int(10000)]
cat("GSD_Cltot.TK", quantile(GSD_Cltot.TK, prob=c(0.5,0.05,0.95)), "\n")

# Free TeA elimination rate in urine
GM_kufrac <- exp(urine_par$M_lnkufrac.1.)
kufrac.GM <- rep(GM_kufrac, 20)[sample.int(10000)]
cat("kufrac.GM", quantile(kufrac.GM, prob=c(0.5,0.05,0.95)), "\n")

GSD_kufrac <- exp(urine_par$SD_lnkufrac.1.)
GSD_kufrac.TK <- rep(GSD_kufrac, 20)[sample.int(10000)]
cat("GSD_kufrac.TK", quantile(GSD_kufrac.TK, prob=c(0.5,0.05,0.95)), "\n")

### TKTDVF01
# GSD total
IntraTKTD_GSD <- exp((log(Intra_GSD.TD)^2+log(GSD_Cltot.TK)^2+log(GSD_kufrac.TK)^2)^(1/2))
cat("IntraTKTD_GSD", quantile(IntraTKTD_GSD, prob=c(0.5,0.05,0.95)), "\n")
AF_intraTKTD <- IntraTKTD_GSD^qnorm(0.99)
cat("AF_intraTKTD", quantile(AF_intraTKTD, prob=c(0.5,0.05,0.95)), "\n")

### iTTC01 in urinary excretion
iTTC01_urine <- (bmd*Cltot.GM*kufrac.GM*24)/(AF_interTD*AF_intraTKTD) #unit: nmol/kg-day
bmd_urine <- bmd*Cltot.GM*kufrac.GM*24
cat("iTTC01_urine", quantile(iTTC01_urine, prob=c(0.5,0.05,0.95)), "\n")
cat("bmd_urine", quantile(bmd_urine, prob=c(0.5,0.05,0.95)), "\n")

TTC <- data.frame(bmd, AF_interTD, Intra_GSD.TD, AF_intraTD, iTTC01, bmd_urine, Cltot.GM, GSD_Cltot.TK, kufrac.GM, GSD_kufrac.TK, IntraTKTD_GSD, AF_intraTKTD, iTTC01_urine)
write.csv(TTC, file="iTTC01.csv")

TTC.quan <- sapply(TTC, quantile, probs=c(0.5, 0.05, 0.95))
write.csv(TTC.quan, file="iTTC01 quantiles.csv")
