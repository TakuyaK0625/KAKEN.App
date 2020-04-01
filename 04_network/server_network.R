# --------------------------------------------------
# データのインポート
# --------------------------------------------------

networkD <- fread("04_network/network.csv", colClasses = c("character", "character", "character", "character", "integer", "character"))
researcher <- fread("04_network/researcher.csv", colClasses = c("integer", "character", "character"))


# --------------------------------------------------
# インプット
# --------------------------------------------------

# 審査区分チェックボックス
observe({
    output$area_net <- renderTree({ 
        review_list
    })
})

# 研究種目全選択ボタン
observe({
    if(input$selectall_net == 0) return(NULL) 
    else if (input$selectall_net%%2 == 0)
    {
        updateCheckboxGroupInput(session, "type_net", "研究種目", choices = type)
    }
    else
    {
        updateCheckboxGroupInput(session, "type_net", "研究種目", choices = type, selected = type)
    }
})



observe({
  
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
  
  # グラフ作成
  g <- reactive({
      D() %>% graph_from_data_frame(directed = FALSE)
  })
  
  
  
# ---------------------  
# 描画
# ---------------------  
  
  #ネットワーク
  output$network <- renderScatterplotThree({
    
      inst <- researcher %>% filter(所属 == input$inst_net) %>% 
          filter(年度 %in% input$year_net[1]:input$year_net[2]) %>%
          .$ID
      colors <- ifelse(V(g())$name %in% inst, "blue", "orange")
      set.seed(0)
      graphjs(g(), vertex.color = colors, vertex.size = 0.2, vertex.label = V(g())$name)
 
  })
  
  # 中心性指標
  output$centrality <- renderDataTable({
      data.frame(研究者番号 = V(g())$name, 
                      次数中心性 = degree(g()), 
                      媒介中心性 = round(betweenness(g()), 2), 
                      固有ベクトル中心性 = round(eigen_centrality(g())$vector, 2)) %>% 
          datatable(rownames = F)
  })
  

})
