source("global.R")
networkD <- fread("04_network/network.csv")
researcher <- fread("04_network/researcher.csv")

observe({
  
  # 審査区分チェックボックス
  output$area_net <- renderTree({ 
    review_list
    })
  
  # データのフィルタリング
  D <- reactive({
      
      # 審査区分でフィルター
      area <- get_selected(input$area_net, format = "classid") %>% unlist
      networkD %>% filter(区分名 %in% area) %>%
      
      # 研究種目でフィルター
      filter(研究種目 %in% input$type_net) %>%
      
      # 集計期間でフィルター      
      filter(年度 %in% input$year_net[1]:input$year_net[2])
  })
  
  
  
  
# ---------------------  
# グラフ描画
# ---------------------  
  
  output$network <- renderScatterplotThree({
    
      g <- D() %>% graph_from_data_frame(directed = FALSE)
      inst <- researcher %>% filter(所属 == input$inst_net) %>% 
          filter(年度 %in% input$year_net[1]:input$year_net[2]) %>%
          .$ID
      colors <- ifelse(V(g)$name %in% inst, "blue", "orange")
      
      set.seed(0)
      graphjs(g, vertex.color = colors, vertex.size = 0.3, vertex.label = V(g)$name)
  
  })

})
