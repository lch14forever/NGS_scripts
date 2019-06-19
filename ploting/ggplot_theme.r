library(ggplot2)
library(grid)
library(gridExtra)
library(reshape2)
library(ggsci)

figtheme <- theme_bw() + 
  theme(text = element_text(size=23,face='bold'),panel.border  = element_rect(colour = "black",size=2),
        axis.title.y=element_text(margin=margin(0,15,0,0)),axis.title.x=element_text(margin=margin(15,0,0,0)),
        plot.margin = unit(c(1,1,1,1), "cm"),
        plot.title = element_text(margin=margin(0,0,15,0), hjust=0.5))

figtheme <- theme_classic() +
  theme(text = element_text(size=23,face='bold'),panel.border  = element_rect(colour = "black",size=2),
        axis.title.y=element_text(margin=margin(0,15,0,0)),axis.title.x=element_text(margin=margin(15,0,0,0)),
        plot.margin = unit(c(1,1,1,1), "cm"),
        plot.title = element_text(margin=margin(0,0,15,0), hjust=0.5))

use_theme_bw <- function(){
	theme_set(figtheme)
	}
use_theme_classic <- function(){
	theme_set(figtheme_classic)
	}

gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

sel_col <- c(pal_npg('nrc')(10), pal_rickandmorty()(12), pal_tron()(7)[4])[-c(8,9,13,18,21,22)]
