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
    
        
        #if (is.null(input$file2)) {   # locate 'file1' from ui.R
          
        #return(NULL) } else {
        
        #ip1 = readLines(input$file1$datapath)
        #language <-  detect_language(ip1)
        
        #if (language[1] == "hi") {
        #  windowsFont(devanew=windowsFont("Devanagari new normal"))    }
        
        #ip2 <- readLines(input$file2$datapath)
        #model <- udpipe_load_model(ip2)
        #model_name = udpipe_load_model(model)  # file_model only needed
        
        #x <- udpipe_annotate(model, x = ip)
        #y <- as.data.frame(x)
        
        #return(y)              }
      
  
  
  
  
  output$plot1 = renderPlot({
    str_clean <- str_replace_all(Dataset1(), "<.*?>", "")
    model <- udpipe_annotate(Dataset2(), x = str_clean)
    x <- as.data.frame(model)
    
    language <-  detect_language(str_clean)
    
    if (language[1] == "hi") {
      windowsFont(devanew=windowsFont("Devanagari new normal"))    }
    
      cooc <- cooccurrence(
        
      x = subset(x, xpos %in% c(input$checkGroup)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
      
      wordnetwork <- head(cooc, input$clusters)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "red",lineend = "butt") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 10) +
        
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
        
      labs(title = "Cooccurrences within words distance")
        
      
    
  })
  
  
  
  output$plot2 = renderPlot({
    
    #table(x$xpos)  # std penn treebank based POStags
    #table(x$upos)  # UD based postags
    #windowsFonts(devanew=windowsFont("Devanagari new normal"))
    # So what're the most common nouns? verbs?
    
    str_clean <- str_replace_all(Dataset1(), "<.*?>", "")
    
    language <-  detect_language(str_clean)
    
    if (language[1] == "hi") {
      windowsFont(devanew=windowsFont("Devanagari new normal"))    }
    
    model <- udpipe_annotate(Dataset2(), x = str_clean)
    x <- as.data.frame(model)
    
    z = subset(x, xpos %in% c(input$checkGroup))
    # Sentence Co-occurrences for nouns or adj only
    library(wordcloud)
    top_words = txt_freq(z$lemma)
    
    wordcloud=wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = input$clusters,
              random.order = FALSE, 
              colors = brewer.pal(16, "Dark2"))
      })
  
  
})