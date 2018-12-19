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
        
        fileInput("file2", "Choose a trained data",
                  multiple = FALSE,
                  accept = c("text",
                             "text",
                             ".txt")),
        
        
        checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                           choices = list("Adjective (JJ)" = 1, "Noun(NN)" = 2, "Proper Noun (NNP)" = 3,"Adverb (RB)" = 4,"erb (VB)"=5),
                           selected = c(1,2,3)),   # end of sidebar panel
        
        fluidRow(column(3, verbatimTextOutput("value")))),
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only comma separated values (.csv) data file. CSV data file should have headers and the first column of the file should have row names.",align="justify"),
                             p("Please refer to the link below for sample csv file."),
                             a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Choose text file")),
                               'and upload only text file. You can also upload the trained data. click on',
                               span(strong("Choose tarined data")))),
                    tabPanel("Cooccurrance graph", 
                             plotOutput('plot1')),
                    
                    tabPanel("Table Output",
                             tableOutput('clust_summary')),
                    
                    tabPanel("Data",
                               dataTableOutput('clust_data'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI


