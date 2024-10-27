wd <- getwd()
setwd("iTTC")
plasma_groningen <- read.csv("HQ plasma_groningen.csv")
plasma_toddlers <- read.csv("HQ plasma_toddlers.csv")
plasma_epic.control <- read.csv("HQ plasma_epic.control.csv")
urine_dr <- read.csv("HQ urine_dr.csv")
urine_asam <- read.csv("HQ urine_asam.csv")
moe.prob <- read.csv("ProbiIMOETTC.csv")

plasma_groningen.df <- plasma_groningen[,c(4,6:8)]
plasma_groningen.med <- t(apply(plasma_groningen.df, 2, median))
plasma_groningen.05th <- t(apply(plasma_groningen.df, 2, quantile, probs=0.05))
plasma_groningen.95th <- t(apply(plasma_groningen.df, 2, quantile, probs=0.95))
plasma_groningen.25th <- t(apply(plasma_groningen.df, 2, quantile, probs=0.25))
plasma_groningen.75th <- t(apply(plasma_groningen.df, 2, quantile, probs=0.75))
plasma_groningen.min <- t(apply(plasma_groningen.df, 2, min))
plasma_groningen.max <- t(apply(plasma_groningen.df, 2, max))
plasma_groningen.stat <- as.data.frame(rbind(plasma_groningen.med, plasma_groningen.05th, plasma_groningen.95th, plasma_groningen.25th, plasma_groningen.75th, plasma_groningen.min, plasma_groningen.max))
rownames(plasma_groningen.stat) <- c("Median", "5th", "95th", "25th", "75th", "Min", "Max")
plasma_groningen.stat <- cbind(plasma_groningen.stat,
                               data.frame(ProbMOE.le.1=quantile(moe.prob$prob_gron,prob=
                                          c(.5,.05,.95,.25,.75,0,1))))
write.csv(plasma_groningen.stat, file="plasma_groningen.stat.csv")

plasma_toddlers.df <- plasma_toddlers[,c(4,6:8)]
plasma_toddlers.med <- t(apply(plasma_toddlers.df, 2, median))
plasma_toddlers.05th <- t(apply(plasma_toddlers.df, 2, quantile, probs=0.05))
plasma_toddlers.95th <- t(apply(plasma_toddlers.df, 2, quantile, probs=0.95))
plasma_toddlers.25th <- t(apply(plasma_toddlers.df, 2, quantile, probs=0.25))
plasma_toddlers.75th <- t(apply(plasma_toddlers.df, 2, quantile, probs=0.75))
plasma_toddlers.min <- t(apply(plasma_toddlers.df, 2, min))
plasma_toddlers.max <- t(apply(plasma_toddlers.df, 2, max))
plasma_toddlers.stat <- as.data.frame(rbind(plasma_toddlers.med, plasma_toddlers.05th, plasma_toddlers.95th, plasma_toddlers.25th, plasma_toddlers.75th, plasma_toddlers.min, plasma_toddlers.max))
rownames(plasma_toddlers.stat) <- c("Median", "5th", "95th", "25th", "75th", "Min", "Max")
plasma_toddlers.stat <- cbind(plasma_toddlers.stat,
                               data.frame(ProbMOE.le.1=quantile(moe.prob$prob_todd,prob=
                                                                  c(.5,.05,.95,.25,.75,0,1))))
write.csv(plasma_toddlers.stat, file="plasma_toddlers.stat.csv")

plasma_epic.control.df <- plasma_epic.control[,c(5,7:9)]
plasma_epic.control.med <- t(apply(plasma_epic.control.df, 2, median))
plasma_epic.control.05th <- t(apply(plasma_epic.control.df, 2, quantile, probs=0.05))
plasma_epic.control.95th <- t(apply(plasma_epic.control.df, 2, quantile, probs=0.95))
plasma_epic.control.25th <- t(apply(plasma_epic.control.df, 2, quantile, probs=0.25))
plasma_epic.control.75th <- t(apply(plasma_epic.control.df, 2, quantile, probs=0.75))
plasma_epic.control.min <- t(apply(plasma_epic.control.df, 2, min))
plasma_epic.control.max <- t(apply(plasma_epic.control.df, 2, max))
plasma_epic.control.stat <- as.data.frame(rbind(plasma_epic.control.med, plasma_epic.control.05th, plasma_epic.control.95th, plasma_epic.control.25th, plasma_epic.control.75th, plasma_epic.control.min, plasma_epic.control.max))
rownames(plasma_epic.control.stat) <- c("Median", "5th", "95th", "25th", "75th", "Min", "Max")
plasma_epic.control.stat <- cbind(plasma_epic.control.stat,
                               data.frame(ProbMOE.le.1=quantile(moe.prob$prob_epcon,prob=
                                                                  c(.5,.05,.95,.25,.75,0,1))))
write.csv(plasma_epic.control.stat, file="plasma_epic.control.stat.csv")

urine_dr.df <- urine_dr[,c(6,8:10)]
urine_dr.med <- t(apply(urine_dr.df, 2, median))
urine_dr.05th <- t(apply(urine_dr.df, 2, quantile, probs=0.05))
urine_dr.95th <- t(apply(urine_dr.df, 2, quantile, probs=0.95))
urine_dr.25th <- t(apply(urine_dr.df, 2, quantile, probs=0.25))
urine_dr.75th <- t(apply(urine_dr.df, 2, quantile, probs=0.75))
urine_dr.min <- t(apply(urine_dr.df, 2, min))
urine_dr.max <- t(apply(urine_dr.df, 2, max))
urine_dr.stat <- as.data.frame(rbind(urine_dr.med, urine_dr.05th, urine_dr.95th, urine_dr.25th, urine_dr.75th, urine_dr.min, urine_dr.max))
rownames(urine_dr.stat) <- c("Median", "5th", "95th", "25th", "75th", "Min", "Max")
urine_dr.stat <- cbind(urine_dr.stat,
                               data.frame(ProbMOE.le.1=quantile(moe.prob$prob_u.dr,prob=
                                                                  c(.5,.05,.95,.25,.75,0,1))))
write.csv(urine_dr.stat, file="urine_dr.stat.csv")

urine_asam.df <- urine_asam[,c(5:8)]
urine_asam.med <- t(apply(urine_asam.df, 2, median))
urine_asam.05th <- t(apply(urine_asam.df, 2, quantile, probs=0.05))
urine_asam.95th <- t(apply(urine_asam.df, 2, quantile, probs=0.95))
urine_asam.25th <- t(apply(urine_asam.df, 2, quantile, probs=0.25))
urine_asam.75th <- t(apply(urine_asam.df, 2, quantile, probs=0.75))
urine_asam.min <- t(apply(urine_asam.df, 2, min))
urine_asam.max <- t(apply(urine_asam.df, 2, max))
urine_asam.stat <- as.data.frame(rbind(urine_asam.med, urine_asam.05th, urine_asam.95th, urine_asam.25th, urine_asam.75th, urine_asam.min, urine_asam.max))
rownames(urine_asam.stat) <- c("Median", "5th", "95th", "25th", "75th", "Min", "Max")
urine_asam.stat <- cbind(urine_asam.stat,
                               data.frame(ProbMOE.le.1=quantile(moe.prob$prob_u.asam,prob=
                                                                  c(.5,.05,.95,.25,.75,0,1))))
write.csv(urine_asam.stat, file="urine_asam.stat.csv")

setwd(wd)
