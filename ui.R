#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    
    titlePanel("UDPipe NLP workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file1", "Choose text File",
                  multiple = FALSE,
                  accept = c("text",
                             "text",
                             ".txt")),
        
        
        checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                           choices = list("adjective (JJ)" = 1, "noun(NN)" = 2, "proper noun (NNP)" = 3,"adverb (RB)" = 4,"verb (VB)"=5),
                           selected = c(1,2,3)),
        
        
        fluidRow(column(3, verbatimTextOutput("value")))),
           # end of sidebar panel
      
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only text file and an option to upload the trained udpipe model for different languages.",align="justify"),
                             p("Please refer to the link below for sample csv file."),
                             a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload data (csv file with header)")),
                               'and uppload the csv data file. You can also change the number of clusters to fit in k-means clustering')),
                    tabPanel("Scree plot", 
                             plotOutput('plot1')),
                    
                    tabPanel("Cluster mean",
                             tableOutput('clust_summary')),
                    
                    tabPanel("Data",
                             dataTableOutput('clust_data'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI



