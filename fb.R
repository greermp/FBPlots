library(tidyr)
library(dplyr)
library(ggmap)
library(leaflet)
# raw_df <- read.csv('fb_anova.csv')
raw_df <- read.csv('new.csv')

# m <- leaflet() %>% addTiles()  FB_Privacy_Rating
colors <- c("red","yellow","green")
raw_df <- raw_df %>% mutate(popup_info=as.character(FB_Privacy_Rating))
raw_df <- raw_df %>% mutate(popup_infoF = paste("<b>FB Privacy Rating:</b><br/>",as.character(FB_Privacy_Rating)))
raw_df <- raw_df %>% mutate(popup_infoI = paste("<b>Insta Privacy Rating:</b><br/>",as.character(Insta_Privacy_Rating)))
palF <- colorFactor(colors,raw_df$FB_Privacy_Rating)
palI <- colorFactor(colors,raw_df$Instagram.in.high.regard)
pal <- colorNumeric(colors, raw_df$Instagram.in.high.regard)

change = c('Strongly Disagree', 'Disagree', 'Somewhat Disagree', 'Neither Agree or Disagree', 'Somewhae Agree', 'Agree', 'Strongly Agree' )

for (x in raw_df){
  print(~Age)
}

raw_df$latj <-  jitter(raw_df$lat,.5,1)
raw_df$longj <-  jitter(raw_df$long-.2,.5,1)

leaflet() %>%addProviderTiles(providers$Esri.NatGeoWorldMap) %>% 
  addCircleMarkers(data=raw_df, lat=~latj, lng=~longj,radius=~3,color= ~palI(raw_df$Insta_Privacy_Rating),  popup = ~popup_infoI) %>% 
 addCircleMarkers(data=raw_df, lat=~lat, lng=~long,radius=~3,color=~palF(raw_df$FB_Privacy_Rating), popup = ~popup_infoF)

