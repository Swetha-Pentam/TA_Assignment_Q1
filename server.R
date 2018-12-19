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
    if (is.null(input$file1)) { return(NULL) }
    else{
      ip1 = readLines('input$file1.txt')
      ip  =  str_replace_all(data, "<.*?>", "")
      # get rid of html junk 
      
      if (!is.null(input$file2)){
        model <- readLines('input$file2.txt')
        model_name = udpipe_load_model(model)  # file_model only needed
        
        x <- udpipe_annotate(model_name, x = ip) #%>% as.data.frame() %>% head()
        Data1 <- as.data.frame(x)
                      }
      
    }
    return(Data1)
  }
  )
  
  output$plot1 = renderPlot({
    if (input$checkGroup == 1){
      
      nokia_cooc_gen <- cooccurrence(x = x$lemma, 
                                     relevant = x$upos %in% c("NOUN", "ADJ"))
      wordnetwork <- head(nokia_cooc, 50)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
      
      
    }
    data.pca <- prcomp(Dataset(),center = TRUE,scale. = TRUE)
    plot(data.pca, type = "l"); abline(h=1)    
  })
  
  clusters <- reactive({
    kmeans(Dataset(), input$clusters)
  })
  
  output$clust_summary = renderTable({
    out = data.frame(Cluser = row.names(clusters()$centers),clusters()$centers)
    out
  })
  
  output$clust_data = renderDataTable({
    out = data.frame(row_name = row.names(Dataset()),Dataset(),Cluster = clusters()$cluster)
    out
  })
  
})