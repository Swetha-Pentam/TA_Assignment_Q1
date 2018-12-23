#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
options(shiny.maxRequestSize=50*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  Dataset1 <- reactive({
    if (is.null(input$file1)) 
      { return(NULL) }
    else{
      ip1 = readLines(input$file1$datapath)
      return(ip1)
    }
    })
  
  Dataset2 <- reactive({
    if (is.null(input$file2)) 
    { return(NULL) }
    else{
      ip2 = udpipe_load_model(input$file2$datapath)
      return(ip2)
    }
    })
    
      
  output$plot1 = renderPlot({
    str_clean <- str_replace_all(Dataset1(), "<.*?>", "")
    model <- udpipe_annotate(Dataset2(), x = str_clean)
    x <- as.data.frame(model)
    
    language <-  detect_language(str_clean)
    
    if (language[1] == "hi") {
      windowsFonts(devanew=windowsFont("Devanagari new normal"))    }
    
      cooc <- cooccurrence(
        
      x = subset(x, upos %in% c(input$checkGroup)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id")) 
      
      wordnetwork <- head(cooc, input$clusters)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) 
      
      ggraph(wordnetwork, layout = "fr") +  
        
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "red") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
        
      labs(title = "Cooccurrences within words distance")
        
    })
  
  
  
  output$plot2 = renderPlot({
    
    str_clean <- str_replace_all(Dataset1(), "<.*?>", "")
    
    language <-  detect_language(str_clean)
    if (language[1] == "hi") {
    windowsFonts(devanew=windowsFont("Devanagari new normal"))    }
    
    model <- udpipe_annotate(Dataset2(), x = str_clean)
    x <- as.data.frame(model)
    
    z = subset(x, upos %in% c(input$checkGroup))
    top_words = txt_freq(z$lemma)
    
    wordcloud=wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = input$clusters,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
      })
  
  
})