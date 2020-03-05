source("global.R")

observe({
  
  # 審査区分チェックボックス
  output$tree <- renderTree({ 
    review_list
    })
  
  # データの整形
  DF <- reactive({
      
      # 研究機関グループでフィルター
      if (input$group != "全機関"){
          D <- D %>% filter(所属機関 %in% Group[[input$group]])
      }
      
      # 審査区分でフィルター
      area <- get_selected(input$tree, format = "classid") %>% unlist
      D <- D %>% filter(区分名 %in% area) 
          
      # データフレームの集計
      D %>% 
        filter(研究種目 %in% input$type) %>%
        filter(年度 %in% input$year) %>%
        group_by(所属機関) %>%
        summarize(件数 = n(), 総額 = sum(as.numeric(総配分額)), 平均 = round(総額/件数, 1)) %>%
        ungroup %>%
        mutate(総額シェア = round(100 * 総額/sum(総額), 3)) %>%
        mutate(color = ifelse(所属機関 == "信州", "#ff7f0e", "#1f77b4")) %>%
        arrange(-総額)
  })
  
  # 折れ線グラフ用
  DF_line <- reactive({
      
      # 研究機関グループでフィルター
      if (input$group != "全機関"){
          D <- D %>% filter(所属機関 %in% Group[[input$group]])
      }
      
      # 審査区分でフィルター
      area <- get_selected(input$tree, format = "classid") %>% unlist
      D <- D %>% filter(区分名 %in% area) 
      
      # データフレームの集計
      D %>% 
          filter(研究種目 %in% input$type) %>%
          filter(年度 %in% input$year) %>%
          group_by(所属機関, 年度) %>%
          summarize(件数 = n(), 総額 = sum(as.numeric(総配分額)), 平均 = round(総額/件数, 1)) %>%
          ungroup %>%
          mutate(総額シェア = round(100 * 総額/sum(総額), 3)) %>%
          mutate(年度 = as.factor(年度)) %>%
          mutate(color = ifelse(所属機関 == "信州", "#ff7f0e", "#1f77b4")) %>%
          arrange(-総額)
  })
  
  # 棒グラフ
  output$overall_bar <- renderPlotly({
    DF() %>%
      arrange(desc(eval(as.name(input$bar_yaxis)))) %>%
      head(input$amount) %>%
      plot_ly() %>% 
          add_bars(x = ~reorder(所属機関, -eval(as.name(input$bar_yaxis))), y = ~eval(as.name(input$bar_yaxis)), 
           marker = list(color = ~color)) %>%
      layout(xaxis = list(title = ""), yaxis = list(title = input$bar_yaxis))
      })

  
  # 折れ線グラフ
  output$overall_line <- renderPlotly({
      DF_line() %>%
          arrange(desc(eval(as.name(input$bar_yaxis)))) %>%
          head(input$amount) %>%
          plot_ly(x = ~年度, y = ~eval(as.name(input$line_yaxis)), color = ~所属機関) %>% 
          add_lines() %>%
          layout(xaxis = list(range = input$year), yaxis = list(title = input$line_yaxis))
  })
  
  
   
  # 散布図  
  output$overall_scatter <- renderPlotly({
      DF() %>%
          plot_ly() %>%
          add_trace(x = ~eval(as.name(input$scatter_xaxis)), y = ~eval(as.name(input$scatter_yaxis)), type = "scatter",
                    mode = "markers", marker = list(color = ~color), text = ~所属機関) %>%
          layout(xaxis = list(title = ~input$scatter_xaxis), yaxis = list(title = ~input$scatter_yaxis))
      })
  
  # 集計表
  output$overall_table <- renderDataTable({
      DF() %>% 
          select(-color) %>%  
          datatable(rownames = FALSE)
      })
  
  # 集計表のダウンロード
  output$downloadData <- downloadHandler(
      filename = "kaken_summary.csv",
      content = function(file) {
          write.csv(DF() %>% select(-color), file, row.names = FALSE, fileEncoding = "CP932")
      }
  )

})
