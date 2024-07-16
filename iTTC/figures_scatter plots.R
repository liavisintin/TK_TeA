plasma_groningen <- read.csv("HQ iMOE plasma_groningen.csv")
plasma_toddlers <- read.csv("HQ iMOE plasma_toddlers.csv")
plasma_epic.control <- read.csv("HQ iMOE plasma_epic.control.csv")
urine_dr <- read.csv("HQ iMOE urine_dr.csv")
urine_asam <- read.csv("HQ iMOE urine_asam.csv")

plasma_groningen$name <- "plasma_groningen"
plasma_toddlers$name <- "plasma_toddlers"
plasma_epic.control$name <- "plasma_epic.control"
urine_dr$name <- "urine_dr"
urine_asam$name <- "urine_asam"

colnames(plasma_toddlers)[1] <- "Subject"
colnames(urine_dr)[1] <- "Subject"

blood <- rbind(plasma_groningen[,c(1,7:10)], plasma_toddlers[,c(1,7:10)], plasma_epic.control[,c(1,8:11)])
urine <- rbind(urine_dr[,c(1,9:12)], urine_asam[,c(1,7:10)])

library(ggplot2)
library(ggpubr)

#HQ_TTC and HQ_iTTC
hq.b <- ggplot()+
  geom_point(data=blood, aes(x=Fraction.TTC, y=HQ, shape=name, fill=name), size=3)+
  geom_abline(intercept = 0, slope = 1)+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  scale_y_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[TTC]))+ylab(bquote(HQ[iTTC]))+
  scale_shape_manual(name="legend",
                     breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                     labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                     values=c(21, 1, 16))+
  scale_fill_manual(name="legend",
                    breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                    labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                    values=c("coral2", NA, NA))+
  guides(shape = guide_legend(nrow = 2))+
  annotation_logticks(sides="lb")
print(hq.b)

hq.u <- ggplot()+
  geom_point(data=urine, aes(x=Fraction.TTC, y=HQ, shape=name), size=3)+
  geom_abline(intercept = 0, slope = 1)+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  scale_y_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[TTC]))+ylab(bquote(HQ[iTTC]))+
  scale_shape_manual(breaks=c("urine_asam","urine_dr"),
                     labels=c("IV – Asam et al. (2013)","V – EFCOVAL"),
                     values=c(17, 2))+
  annotation_logticks(sides="lb")
print(hq.u)

hq.ittc <- ggarrange(hq.b, hq.u, ncol = 2, nrow = 1, align="hv")
ggsave(hq.ittc, file="HQ TTC and iTTC.pdf", width = 10, height = 5)

#HQ_TTC anc HQ_prob iMOE<1
hqprob.b <- ggplot()+
  geom_point(data=blood, aes(x=Fraction.TTC, y=prob/100, shape=name, fill=name), size=3)+
  geom_vline(xintercept=1, color="black", linetype="dashed")+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  ylim(0,1)+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[TTC]))+ylab("Prob iMOE < 1")+
  scale_shape_manual(name="legend",
                     breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                     labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                     values=c(21, 1, 16))+
  scale_fill_manual(name="legend",
                    breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                    labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                    values=c("coral2", NA, NA))+
  guides(shape = guide_legend(nrow = 2))+
  annotation_logticks(sides="b")
print(hqprob.b)

hqprob.u <- ggplot()+
  geom_point(data=urine, aes(x=Fraction.TTC, y=prob/100, shape=name), size=3)+
  geom_vline(xintercept=1, color="black", linetype="dashed")+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  ylim(0,1)+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[TTC]))+ylab("Prob iMOE < 1")+
  scale_shape_manual(breaks=c("urine_asam","urine_dr"),
                     labels=c("IV – Asam et al. (2013)","V – EFCOVAL"),
                     values=c(17, 2))+
  annotation_logticks(sides="b")
print(hqprob.u)

hq.prob <- ggarrange(hqprob.b, hqprob.u, ncol = 2, nrow = 1, align="hv")
ggsave(hq.prob, file="HQ TTC and prob MOE.pdf", width = 10, height = 5)

#HQ_iTTC anc HQ_prob iMOE<1
ihqprob.b <- ggplot()+
  geom_point(data=blood, aes(x=HQ, y=prob/100, shape=name, fill=name), size=3)+
  geom_vline(xintercept=1, color="black", linetype="dashed")+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  ylim(0,1)+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[iTTC]))+ylab("Prob iMOE < 1")+
  scale_shape_manual(name="legend",
                     breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                     labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                     values=c(21, 1, 16))+
  scale_fill_manual(name="legend",
                    breaks=c("plasma_toddlers","plasma_epic.control","plasma_groningen"),
                    labels=c("I – MISAME-III", "III - EPIC","II – Groningen"),
                    values=c("coral2", NA, NA))+
  guides(shape = guide_legend(nrow = 2))+
  annotation_logticks(sides="b")
print(ihqprob.b)

ihqprob.u <- ggplot()+
  geom_point(data=urine, aes(x=HQ, y=prob/100, shape=name), size=3)+
  geom_vline(xintercept=1, color="black", linetype="dashed")+
  scale_x_log10(limits=c(5e-03, 3.1e+02),
                breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x)))+
  ylim(0,1)+
  theme_bw()+
  theme(legend.title = element_blank(), legend.position = "top", 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  xlab(bquote(HQ[iTTC]))+ylab("Prob iMOE < 1")+
  scale_shape_manual(breaks=c("urine_asam","urine_dr"),
                     labels=c("IV – Asam et al. (2013)","V – EFCOVAL"),
                     values=c(17, 2))+
  annotation_logticks(sides="b")
print(ihqprob.u)

ihq.prob <- ggarrange(ihqprob.b, ihqprob.u, ncol = 2, nrow = 1, align="hv")
ggsave(ihq.prob, file="HQ iTTC and prob MOE.pdf", width = 10, height = 5)

##combine all plots
all.plot <- ggarrange(hq.ittc, hq.prob, ihq.prob, nrow = 3, ncol = 1, align="hv")
ggsave(all.plot, file="Scatter plots for HQTTC HQiTTC probMOE.pdf", width = 10, height = 16, scale=0.8)
