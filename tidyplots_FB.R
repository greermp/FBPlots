library(ggpmisc)
library(tidyr)
library(plyr)
library(dplyr)
library(ggmap)
library(ggpubr)
library(ggExtra)
# raw_df <- read.csv('fb_anova.csv')
raw_df <- read.csv('new.csv')
tidy_df <- read.csv('new_tidy.csv')
most_tidy <- read.csv('most_tidy.csv')
tidy_df1 <- filter(tidy_df, gender != 1, gender != 2, gender != 'No Answer', gender != '')
raw_df$gender


##
ggplotRegression <- function (fit, lineCol) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point(shape=21, color="#273443", fill="#1EBEA5", position = 'jitter') +
    stat_smooth(method = "lm", col = lineCol,) +
    labs(caption =  paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$coef[[2]], 5),
                       " P =",signif(summary(fit)$coef[2,4], 5))) + theme_classic2()
}

ggplotRobustRegression <- function (fit, lineCol) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point(shape=21, color="#273443", fill="#1EBEA5", position = 'jitter') +
    stat_smooth(method = "rlm", col = lineCol,) +
    labs(caption =  paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                          "Intercept =",signif(fit$coef[[1]],5 ),
                          " Slope =",signif(fit$coef[[2]], 5),
                          " P =",signif(summary(fit)$coef[2,4], 5))) + theme_classic2()
}
##
# ggplotRegression <- function (fit, lineCol) {
#   
#   require(ggplot2)
#   
#   ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
#     geom_point(shape=21, color="#273443", fill="#1EBEA5", position = 'jitter') +
#     stat_smooth(method = "lm", col = lineCol) +
#     labs(subtitle = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
#                           "Intercept =",signif(fit$coef[[1]],5 ),
#                           " Slope =",signif(fit$coef[[2]], 5),
#                           " P =",signif(summary(fit)$coef[2,4], 5))) + theme_classic2()
# }


ggscatter(raw_df, x="WA_Regard_Rating", y="WA_Regard_Rating", color="lightgray")  + geom_density_2d() +stat_density_2d(aes(fill=..level..), geom="polygon")+  gradient_fill("YlOrRd")
ggscatter(raw_df, x="FB_Regard_Rating", y="FB_Regard_Rating", color="lightgray")  + geom_density_2d() +stat_density_2d(aes(fill=..level..), geom="polygon")+  gradient_fill("YlOrRd")
ggscatter(raw_df, x="Insta_Regard_Rating", y="Insta_Regard_Rating", color="lightgray")  + geom_density_2d() +stat_density_2d(aes(fill=..level..), geom="polygon")+  gradient_fill("YlOrRd")


# ggscatter(filter(most_tidy,Company=='Facebook'), x = "Privacy", y = "Regard",
#           color = "Company", position = 'jitter')+ geom_density_2d() +stat_density_2d(aes(fill=..level..), geom="polygon")+  gradient_fill("YlOrRd")


 p= ggscatter(filter(most_tidy,Company=='Facebook'), x = "Privacy", y = "Regard",
          color = "Company", shape = "Company", position = 'jitter', title="Facebook Regard v Privacy",
          palette = c("#00AFBB", "#E7B800", "#FC4E07"), mean.point = TRUE) + geom_density2d() + theme_classic()
 ggsave('plots/PrivRegardCountour',  plot = p)
 

x=ggscatter(most_tidy, x = "Privacy", y = "Regard",
          color = "Company", shape = "Company", position = 'jitter', add="reg.line",
          palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          mean.point = TRUE)
p= ggpar(p=x, title="Privacy v Regard", legend.title = "Regression Lines:")
ggsave('plots/RegressionAll.png',  plot = p)

# my.formula <- most_tidy$Regard ~ most_tidy$Privacy
x = ggplot(most_tidy, aes(x=Privacy, y=Regard, color=factor(Company))) +
  geom_point() +    # Use hollow circles
  geom_smooth(method=lm)+ geom_jitter() + theme_classic()+scale_x_continuous(breaks = seq(0, 10, 1))
p= ggpar(p=x, title="Privacy v Regard", legend.title = "Regression Lines:")
ggsave('plots/AllLinear.jpg',  plot = p)


# PRIV V Regard 
x=ggscatter(filter(most_tidy,Company=='Facebook'), x="Privacy", y="Regard", shape=21, color="#3B5998", fill="#ADB9D3", add="reg.line", position = 'jitter', add.params = list(color="#3B5998", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="Facebook Privacy v Regard")
ggsave('plots/FB_Reg_PriVRegard.jpg',  plot = p)

x=ggscatter(filter(most_tidy,Company=='Instagram'), x="Privacy", y="Regard", shape=21, color="#F58529", fill="#8134AF", add="reg.line", position = 'jitter', add.params = list(color="#DD2A7B", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="Instagram Privacy v Regard")
ggsave('plots/Insta_Reg_PriVRegard.jpg',  plot = p)

x=ggscatter(filter(most_tidy,Company=='WhatsApp'), x="Privacy", y="Regard", shape=21, color="#273443", fill="#1EBEA5", add="reg.line", position = 'jitter', add.params = list(color="#273443", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="WhatsApp Privacy v Regard")
ggsave('plots/WA_Reg_PriVRegard.jpg',  plot = p)


# PRIV V RECOMMEND 
x=ggscatter(filter(most_tidy,Company=='Facebook'), x="Privacy", y="Recommend", shape=21, color="#3B5998", fill="#ADB9D3", add="reg.line", position = 'jitter', add.params = list(color="#3B5998", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="Facebook Privacy v Recommend")
ggsave('plots/FB_Reg_PriVRecc.jpg',  plot = p)


x=ggscatter(filter(most_tidy,Company=='Instagram'), x="Privacy", y="Recommend", shape=21, color="#F58529", fill="#8134AF", add="reg.line", position = 'jitter', add.params = list(color="#DD2A7B", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="Instagram Privacy v Recommend")
ggsave('plots/Insta_Reg_PriVRecc.jpg',  plot = p)

x=ggscatter(filter(most_tidy,Company=='WhatsApp'), x="Privacy", y="Recommend", shape=21, color="#273443", fill="#1EBEA5", add="reg.line", position = 'jitter', add.params = list(color="#273443", fill="lightgray"), conf.int = TRUE, cor.coeff.args = list(method = "pearson", label.x = 3, label.sep = "\n"))  + stat_cor(method = "pearson")
p= ggpar(p=x, title="WhatsApp Privacy v Recommend")
ggsave('plots/WA_Reg_PriVRecc.jpg',  plot = p)



x=ggplot(filter(most_tidy,Company=='Facebook'), aes(x=Privacy, y=Regard, color=age)) +
  geom_point() +    # Use hollow circles
  geom_smooth(method=lm)+ geom_jitter()  
y= ggpar(p=x,  title="Facebook Privacy v Regard")
p= ggMarginal(y, type="boxplot")
ggsave('plots/FB_Priv_Regard_wBox.jpg',  plot = p)


fit1 <- lm(Recommend ~ Privacy, data= filter(most_tidy,Company=='Facebook'))
x=ggplotRegression(fit1, "#ADB9D3") 
p= ggpar(p=x, title="Facebook Privacy v Recommend Regression")
ggsave('plots/FB_Priv_Recommend_Regres.jpg',  plot = p)

fit1 <- lm(Regard ~ Privacy, data= filter(most_tidy,Company=='Facebook'))
x= ggplotRegression(fit1, "#ADB9D3")
p=ggpar(p=x, title="Facebook Privacy v Regard Regression")
ggsave('plots/FB_Priv_Regard_Regres.jpg',  plot = p)


p=ggplot(data = tidy_df1) + 
  geom_density(mapping = aes(x = Score, fill = company), alpha=.5) + facet_grid(company ~ Metric) + 
  scale_x_continuous(breaks = seq(0, 10, 2)) + theme_gray()
ggsave('plots/DensityAll1.jpg',  plot = p)

p=ggplot(data = tidy_df1) + 
  geom_histogram(mapping = aes(x = Score, fill = company)) + facet_grid(company ~ Metric)
ggsave('plots/okishhist.jpg',  plot = p)

 
p=ggplot(data=tidy_df1)+
  geom_histogram(mapping=aes(x=Score, fill=Metric), binwidth = 1, position="dodge") + facet_wrap(~company, ncol=1)+ scale_x_continuous(breaks = seq(0, 10, 1)) + theme_gray()
ggsave('plots/AllByCompany.jpg',  plot = p)





p=ggplot(data=tidy_df1)+
  geom_histogram(mapping=aes(x=Score, fill=gender), binwidth = 1) + facet_grid(Metric~company)+ scale_x_continuous(breaks = seq(0, 10, 1)) + theme_classic()
ggsave('plots/SummaryByGender.jpg',  plot = p)

#here



p=ggplot(data=tidy_df1)+
  geom_histogram(mapping=aes(x=Score, fill=company), binwidth = 1, position="dodge") + facet_grid(Metric ~ gender)+
  scale_x_continuous(breaks = seq(0, 10, 1))
ggsave('plots/HistByGender.jpg',  plot = p)



avgs <- ddply(tidy_df1, c("company", "Metric"), summarise, grp.mean=mean(Score))
avgs_age <- ddply(tidy_df1, c("company", "age"), summarise, grp.mean=mean(Score))


p=ggplot(tidy_df1, aes(x=Score, color=company, fill=company)) +
  # geom_histogram(aes(y=..density..), alpha=0.5, position='dodge')+
  geom_density(alpha=0.4) + facet_grid(Metric~company) +
  geom_vline(data=avgs, aes(xintercept=grp.mean, color=company),
             linetype="dashed")+
  labs(title="",x="Rating", y = "Density") + theme_classic()
  ggsave('plots/AllDensity.jpg',  plot = p)

  p=ggplot(tidy_df1) +
    geom_histogram(mapping = aes(x=Score, color=company, fill=company))+#    (aes(y=..density..), alpha=0.5, position='dodge')+
    facet_grid(Metric~company) +
    geom_vline(data=avgs, aes(xintercept=grp.mean, color=company),
               linetype="dashed") +
    scale_x_continuous(breaks = seq(0, 10, 1)) +
    labs(title="",x="Rating", y = "Count") + theme_classic()
  ggsave('plots/HistAll.jpg',  plot = p)


  tidy_privacy <- filter(tidy_df, Metric == "Privacy")
  all_filter_age =  filter(tidy_df1, age != '<20')  
  tidy_privacy_filter <- filter(tidy_privacy, age != '<20')  
  avgs_age <- ddply(tidy_privacy_filter, c("company", "age"), summarise, grp.mean=mean(Score))
  
  p=ggplot(tidy_privacy_filter, aes(x=Score, color=company, fill=company)) +
    # geom_histogram(aes(y=..density..), alpha=0.5, position='dodge')+
    geom_density(alpha=0.4) + facet_grid(age~company) +
    geom_vline(data=avgs_age, aes(xintercept=grp.mean, color=company),
               linetype="dashed") +
    scale_x_continuous(breaks = seq(0, 10, 2)) +
    labs(title="Privacy Rating by Age",x="Rating", y = "Density") + theme_classic()
  ggsave('plots/PrivacyRatingAllDensity.jpg',  plot = p)


  
  p= ggplot(tidy_privacy_filter)+
    geom_boxplot(mapping = aes(x=Score, color=company, fill=company))+#    (aes(y=..density..), alpha=0.5, position='dodge')+
    facet_grid(company~age)  +
    scale_x_continuous(breaks = seq(0, 10, 2)) +
    geom_vline(data=avgs_age, aes(xintercept=grp.mean),
               linetype="dashed") +
    labs(title="Privacy Rating by Age",x="Rating") + theme_classic() +ylab("")
  ggsave('plots/PrivacyRatingAllBox.jpg',  plot = p)

  p=ggplot(data=all_filter_age)+
   geom_density(alpha=.6, mapping=aes(x=Score, fill=company, color=company)) + facet_grid(age~Metric) +
    scale_x_continuous(breaks = seq(0, 10, 2)) + theme_classic() + labs(title="Metric by Age",x="Rating")
  ggsave('plots/AllMetricsDensityNolt20.png',  plot = p)
  p=ggplot(data=all_filter_age)+
    geom_histogram(mapping=aes(x=Score, fill=Metric), binwidth = 1, position="dodge") + facet_grid(age~company)+ scale_x_continuous(breaks = seq(0, 10, 1)) + theme_classic()
  