library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)
library(plyr)
library(dplyr)


shinyServer(
  function(input, output){
    
    output$img_utama <- renderImage({
      outfile <- tempfile(fileext='image_home.png')
      outfile
      
    })
    
    output$img_kedua <- renderImage({
      
    })
  
    
      output$summ_apriori <- renderPrint({
          association.rules <- apriori(tr, parameter = list(supp=0.001, conf=0.8,maxlen=10))
          summary(association.rules)
        
      })
      
      output$inspect_apriori <- renderDataTable({
          association.rules <- apriori(tr, parameter = list(supp=0.001, conf=0.8,maxlen=10)) 
          association.rules <- sort(association.rules, by="lift")
          association.rules <- as(association.rules, "data.frame")
          association.rules
        
      })
      
      output$summ_apriori_rekom<-renderDataTable({
        rekom <- apriori(tr, parameter = list(supp=0.001, conf=0.8),appearance = list(default="lhs",rhs=input$item))
        rekom <- as(rekom, "data.frame")
        head(rekom)
      })
      
      output$plot <-renderPlot({
        association.rules <- apriori(tr, parameter = list(supp=0.001, conf=0.8,maxlen=10)) 
        association.rules <- sort(association.rules, by="lift")
        top <- association.rules[1:10]
        plot(top, method ="graph")
      })
      
      
      output$plot_waktu <- renderPlot({
        retail$TransTime <- as.factor(retail$TransTime)
        a <- hms(as.character(retail$TransTime))
        retail$TransTime = hour(a)
        
        retail %>% 
          ggplot(aes(x=TransTime)) + 
          geom_histogram(stat="count",fill="indianred")
      })
      
      output$plot_pembelian_terbanyak <- renderPlot({
        
        if (!require("RColorBrewer")) {
          # install color package of R
          install.packages("RColorBrewer")
          #include library RColorBrewer
          library(RColorBrewer)
        }
        itemFrequencyPlot(tr,topN=20,type="absolute",col=brewer.pal(8,'Pastel2'), main="Absolute Item Frequency Plot")
      })
      
      
    
      
  }
)