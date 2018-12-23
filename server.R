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
        #ip1 = readLines(input$file1$datapath)
        
        library(rvest)
        
        url = 'https://hi.wikipedia.org/wiki/%E0%A4%AD%E0%A4%BE%E0%A4%B0%E0%A4%A4'
        
        
        page = read_html(url)
        nodes  = html_nodes(page,'p')
        text = html_text(nodes)
        ip1 = text[text != '']
        
        
        language <-  detect_language(ip1)
        
        if (language[1] == "hi") {
          windowsFont(devanew=windowsFont("Devanagari new normal"))    }
        
        ip  =  str_replace_all(ip1, "<.*?>", "")
        
        #data(brussels_reviews)
        #model_name = udpipe_load_model(brussels_reviews)  # file_model only needed
        model <- udpipe_load_model(input$file2$datapath)
        model_name = udpipe_load_model(model)  # file_model only needed
        
        x <- udpipe_annotate(model_name, x = ip)
        y <- as.data.frame(x)
        
        return(y)              }
      
    }}
  
  )
  
  output$plot1 = renderPlot({
    
    
      #table(x$xpos)  # std penn treebank based POStags
      #table(x$upos)  # UD based postags
      #windowsFonts(devanew=windowsFont("Devanagari new normal"))
      #So what're the most common nouns? verbs?
      
    
    
      #Sentence Co-occurrences for nouns or adj only
      nokia_cooc <- cooccurrence(
        # try `?cooccurrence` for parm options
      x = subset(Dataset(), upos %in% c(input$checkGroup)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
      
      wordnetwork <- head(nokia_cooc, input$clusters)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
        
      labs(title = "Cooccurrences within words distance", subtitle = input$checkGroup)
        
      
    
  })
  
  
  
  output$plot2 = renderPlot({
    
    
    #table(x$xpos)  # std penn treebank based POStags
    #table(x$upos)  # UD based postags
    #windowsFonts(devanew=windowsFont("Devanagari new normal"))
    # So what're the most common nouns? verbs?
    
    y = subset(Dataset(), upos %in% c(input$checkGroup))
    # Sentence Co-occurrences for nouns or adj only
    library(wordcloud)
    top_words = txt_freq(y$lemma)
    
    wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = input$clusters,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"),size=10)
    
    
  })
  
  
})