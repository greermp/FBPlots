library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)


regard_anova <- read.csv('fb_anova.csv', header = TRUE)
summary(regard_anova)

one.way <- aov(regard ~ Ethnicity, data = regard_anova)
summary(one.way)

sum <- regard_anova %>% 
  group_by(School) %>% 
  mutate(count = n())

sum <- sum %>% 
  group_by(School, count) %>% 
  summarise(sumReg=sum(regard))

sum <- sum %>% 
  group_by(School) %>% 
  summarise(mean=sumReg/count)

ggplot(sum, aes(x=School, y=mean)) + geom_point()


#regard_anova[grep("1", regard_anova$regard)] <- "asf"