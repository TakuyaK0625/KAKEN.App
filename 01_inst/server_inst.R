observe({
  
  # 審査区分チェックボックス
  output$area_inst <- renderTree({ 
    review_list
    })
  
  # データのフィルタリング
  D0 <- reactive({
      
      # 研究機関グループでフィルター
      if (input$group_inst != "全機関"){
          D <- D %>% filter(所属機関 %in% c(Group[[input$group_inst]], input$inst_inst))
      }
      
      # 審査区分でフィルター
      area <- get_selected(input$area_inst, format = "classid") %>% unlist
      D <- D %>% filter(区分名 %in% area) %>%
      
      # 研究種目でフィルター
      filter(研究種目 %in% input$type_inst) %>%
      
      # 集計期間でフィルター      
      filter(年度 %in% input$year_inst[1]:input$year_inst[2])
  })
  
  
# ---------------------  
# 総計タブ
# ---------------------  
  
  # 総計のためのDF
  D_all <-reactive({ 
      D0() %>% 
          group_by(所属機関) %>%
          summarize(件数 = n(), 総額 = sum(as.numeric(総配分額)), 平均額 = round(総額/件数, 1)) %>%
          ungroup %>%
          mutate(総額シェア = round(100 * 総額/sum(総額), 3)) %>%
          mutate(color = ifelse(所属機関 == input$inst_inst, "#ff7f0e", "#1f77b4")) %>%
          arrange(-総額)
  })

  
  # 棒グラフ
  output$bar_inst <- renderPlotly({
      D_all() %>%
          arrange(desc(eval(as.name(input$bar_yaxis)))) %>%
          head(input$bar_n) %>%
          plot_ly() %>% 
          add_bars(x = ~reorder(所属機関, -eval(as.name(input$bar_yaxis))), y = ~eval(as.name(input$bar_yaxis)), 
                   marker = list(color = ~color)) %>%
          layout(xaxis = list(title = ""), yaxis = list(title = input$bar_yaxis))
  })

  
  # ヒストグラム 
#  output$hist_inst <- renderPlotly({
#      D_all() %>%
#          plot_ly(x = ~eval(as.name(input$hist_var)), type = "histogram")
#  })
  
  
  # 散布図  
  output$scatter_inst <- renderPlotly({
      D_all() %>%
          plot_ly() %>%
          add_trace(x = ~eval(as.name(input$scatter_xaxis)), y = ~eval(as.name(input$scatter_yaxis)), type = "scatter",
                    mode = "markers", marker = list(color = ~color), text = ~所属機関) %>%
          layout(xaxis = list(title = ~input$scatter_xaxis), yaxis = list(title = ~input$scatter_yaxis))
  })

  
  # 集計表
  output$table_all_inst <- renderDataTable({
      D_all() %>% 
          select(-color) %>%  
          datatable(rownames = FALSE)
  })
  
  
  # 集計表のダウンロード
  output$downloadData_all <- downloadHandler(
      filename = "kaken_summary.csv",
      content = function(file) {
          write.csv(D_all() %>% select(-color), row.names = FALSE, fileEncoding = "CP932")
      }
  )
  

# ---------------------  
# 時系列タブ
# ---------------------  
  
  # 折れ線グラフのためのDF
  D_line <- reactive({
      D0() %>%
          group_by(所属機関, 年度) %>%
          summarize(件数 = n(), 総額 = sum(as.numeric(総配分額)), 平均額 = round(総額/件数, 1)) %>%
          ungroup %>%
          mutate(総額シェア = round(100 * 総額/sum(総額), 3)) %>%
          mutate(年度 = as.factor(年度)) 
  })
  
 
  # 折れ線グラフ
  output$line_inst <- renderPlotly({
    D_line() %>%
      plot_ly(x = ~年度, y = ~eval(as.name(input$line_yaxis)), color = ~所属機関) %>% 
          add_lines() %>%
          layout(xaxis = list(range = input$year_inst), yaxis = list(title = input$line_yaxis))
  })
  
  
  # 集計表
  output$table_line_inst <- renderDataTable({
      D_line() %>% select(所属機関, 年度, input$line_yaxis) %>% 
          spread(key = 年度, value = input$line_yaxis) %>%
          datatable(rownames = FALSE)
  })
  
  
  # 集計表のダウンロード
  output$downloadData_line <- downloadHandler(
      filename = "kaken_summary.csv",
      content = function(file) {
          write.csv(D_line(), row.names = FALSE, fileEncoding = "CP932")
      }
  )
      

})
