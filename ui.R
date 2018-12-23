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
                           choices = list("Adjective (JJ)" = 'ADJ', "Noun(NN)" = 'NOUN', "Proper Noun (NNP)" = 'NNP',"Adverb (RB)" = 'ADV',"Verb (VB)"='VERB'),
                           selected = c('ADJ','NOUN','NNP')),   # end of sidebar panel
        
        numericInput("clusters", 'Select the number of words', 50,min = 1, max = 150),
        fluidRow(column(3, verbatimTextOutput("value")))),
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only .txt files data file.",align="justify"),
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Choose text file")),
                               'and upload only text file. You can also upload the trained data. click on',
                               span(strong("Choose trained UDPipe model."))), 
                              p('There is also a provision to choose the number of words to be displayed on the co-occurrance graph and the WordCloud. ',
                                'To choose the number of words enter any number between 1 t0 100 in', 
                                span(strong("Select the number of words")))),
                    
                    tabPanel("Cooccurrance graph", 
                             plotOutput("plot1")),
                    
                    tabPanel("WordCloud",
                             plotOutput("plot2"))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI


