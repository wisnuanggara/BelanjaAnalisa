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



shinyUI(#pembuka shiny
  fluidPage(#pembuka fp
    dashboardPage(#pembuka dp
      dashboardHeader(title = "Belanja Analisa"),
      dashboardSidebar(#pembuka ds
        sidebarMenu(#pembuka sm
          menuItem("Beranda", icon = icon("home"),tabName = "home"),
          menuItem("Eksplorasi Data Analisis", icon = icon("chart-pie"), tabName = "eda"),
          menuItem("Rekomendasi", icon = icon("clipboard-check"), tabName = "rs"),
          menuItem("Tentang",icon = icon("address-card"), tabName = "about")
        )#penutup sm
      ), #penutup ds
      dashboardBody(#pembuka db
        tabItems( #pembuka tis
          tabItem(tabName = "home", align="center", width="500",
                  includeMarkdown("Home.md")
                  
                  ),
          tabItem(tabName = "eda",
                  fluidRow(
                    infoBox(h5("Total Transaksi"), 18536, icon = icon("donate")),
                    infoBox(h5("Total Barang"), 3906, icon = icon("warehouse")),
                    infoBox(h5("Total Konsumen"), 4335, icon = icon("users"))
                  ),
                  fluidPage(
                    tabsetPanel(
                      tabPanel("Distribusi Waktu Belanja", plotOutput("plot_waktu")),
                      tabPanel("Pola Beli Konsumen",dataTableOutput("inspect_apriori")),
                      tabPanel("Visualisasi Pola Beli Konsumen",plotOutput("plot"))
                    ))
                  
                  ),#akhirtab4
          tabItem(tabName = "rs",
                  fluidPage(
                    tabsetPanel(
                      tabPanel("Rekomendasi Barang", align="center",
                               selectInput("item","Pilih Barang",choices = items, selected = "Pilih"),
                               submitButton("Submit"),
                               br(),
                               br(),
                               dataTableOutput("summ_apriori_rekom") 
                               
                      ),
                      tabPanel("Barang Terlaris", plotOutput("plot_pembelian_terbanyak"))
                      
                    )
                    
                  )
                  
                  
          ),
          
          tabItem(tabName = "about",
                  fluidPage(
                    wellPanel(
                      includeMarkdown("README.md")
                    )
                  )
            
          )
        )
      )
    )
  )
)
      