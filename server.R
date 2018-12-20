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
        ip  =  str_replace_all(ip1, "<.*?>", "")
      # get rid of html junk 
      
        model <- udpipe_load_model(input$file2$datapath)
        model_name = udpipe_load_model(model)  # file_model only needed
        
        x <- udpipe_annotate(model_name, x = ip) #%>% as.data.frame() %>% head()
        return(ip)              }
      
    }}
  
  )
  
  output$plot1 = renderPlot({
    
    
      table(x$xpos)  # std penn treebank based POStags
      table(x$upos)  # UD based postags
    
    # So what're the most common nouns? verbs?
      
      # Sentence Co-occurrences for nouns or adj only
      nokia_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
      x = subset(x, upos %in% c(input$checkGroup)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
      
      wordnetwork <- head(nokia_cooc, input$clusters)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance", subtitle = input$checkGroup)
      
      
      #all_verbs = x %>% subset(., upos %in% "VERB") 
      #top_verbs = txt_freq(all_verbs$lemma)
      
      #all_adjectives = x %>% subset(., upos %in% "ADJ") 
      #top_adjectives = txt_freq(all_adjectives$lemma)

      #all_propernoun = x %>% subset(., upos %in% "NNP") 
      #top_propernoun = txt_freq(all_propernoun$lemma)
      
      #all_adverb = x %>% subset(., upos %in% "ADV") 
      #top_adverb = txt_freq(all_adverb$lemma)
      
      
      
      
        #nokia_cooc <- cooccurrence(   	# try `?cooccurrence` for parm options
        #x = subset(x, upos %in% c(input$checkGroup)), 
        #term = "lemma", 
        #group = c("doc_id", "paragraph_id", "sentence_id"))
        
        
        #wordnetwork <- head(nokia_cooc, 50)
        #wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
        
        #ggraph(wordnetwork, layout = "fr") +  
          
        #geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        #geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
          
        #theme_graph(base_family = "Arial Narrow") +  
        #theme(legend.position = "none")
        
        
        #labs(title = "Cooccurrences within 3 words distance", subtitle = input$checkGroup)
    #hist(c(1:10))
    
    
  })
  
  
  
  output$clust_data = renderText({
    out = Dataset()
    out
  })
  
})