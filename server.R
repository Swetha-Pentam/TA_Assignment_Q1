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
  
  Dataset <- reactive({
    if (is.null(input$file1)) {   # locate 'file1' from ui.R
      
        return(NULL) } else{
        
        if (is.null(input$file2)) {   # locate 'file1' from ui.R
          
        return(NULL) } else {
        ip1 = readLines(input$file1$datapath)
        
        language <-  detect_language(ip1)
        
        if (language[1] == "hi") {
          windowsFont(devanew=windowsFont("Devanagari new normal"))    }
        
        ip  =  str_replace_all(ip1, "<.*?>", "")
        
        model <- udpipe_load_model(input$file2$datapath)
        model_name = udpipe_load_model(model)  # file_model only needed
        
        x <- udpipe_annotate(model_name, x = ip)
        y <- as.data.frame(x)
        
        return(y)              }
      
    }}
  
  )
  
  output$plot1 = renderPlot({
    
      cooc <- cooccurrence(
        
      x = subset(y, upos %in% c(input$checkGroup)), 
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
    
    y = subset(y, upos %in% c(input$checkGroup))
    # Sentence Co-occurrences for nouns or adj only
    library(wordcloud)
    top_words = txt_freq(y$lemma)
    
    wordcloud=wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = input$clusters,
              random.order = FALSE, 
              colors = brewer.pal(9, "Dark2"),size=11)
      })
  
  
})