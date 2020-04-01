# 審査区分チェックボックス
observe({
    output$area_inst1 <- renderTree({ 
        review_list
        })
})



# 研究種目全選択ボタン
observe({
    if(input$selectall_inst1 == 0) return(NULL) 
    else if (input$selectall_inst1%%2 == 0)
    {
        updateCheckboxGroupInput(session, "type_inst1", "研究種目", choices = type)
    }
    else
    {
        updateCheckboxGroupInput(session, "type_inst1", "研究種目", choices = type, selected = type)
    }
})


observe({
  # データのフィルタリング
  D0 <- reactive({
      
      # 研究機関グループでフィルター
      if (input$group_inst1 != "全機関"){
          instD <- instD %>% filter(所属機関 %in% c(Group[[input$group_inst1]], input$inst_inst1))
      }
      
      # 審査区分でフィルター
      area <- get_selected(input$area_inst1, format = "classid") %>% unlist
      instD <- instD %>% filter(区分名 %in% area) %>%
      
      # 研究種目でフィルター
      filter(研究種目 %in% input$type_inst1) %>%
      
      # 集計期間でフィルター      
      filter(年度 %in% input$year_inst1[1]:input$year_inst1[2])
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
          mutate(color = ifelse(所属機関 == input$inst_inst1, "#ff7f0e", "#1f77b4")) %>%
          arrange(-総額)
  })

  
  # 棒グラフ
  output$bar_inst1 <- renderPlotly({
      D_all() %>%
          arrange(desc(eval(as.name(input$bar_yaxis1)))) %>%
          head(input$bar_n1) %>%
          plot_ly() %>% 
          add_bars(x = ~reorder(所属機関, -eval(as.name(input$bar_yaxis1))), y = ~eval(as.name(input$bar_yaxis1)), 
                   marker = list(color = ~color)) %>%
          layout(xaxis = list(title = ""), yaxis = list(title = input$bar_yaxis1))
  })

  
  # 散布図  
  output$scatter_inst1 <- renderPlotly({
      D_all() %>%
          plot_ly() %>%
          add_trace(x = ~eval(as.name(input$scatter_xaxis1)), y = ~eval(as.name(input$scatter_yaxis1)), type = "scatter",
                    mode = "markers", marker = list(color = ~color), text = ~所属機関) %>%
          layout(xaxis = list(title = ~input$scatter_xaxis1), yaxis = list(title = ~input$scatter_yaxis1))
  })

  
  # 集計表
  output$table_all_inst1 <- renderDataTable({
      D_all() %>% 
          select(-color) %>%  
          datatable(rownames = FALSE)
  })
  
  
  # 集計表のダウンロード
  output$downloadData_all1 <- downloadHandler(
      filename = "kaken_summary.csv",
      content = function(file) {
          write.csv(D_all() %>% select(-color), row.names = FALSE, fileEncoding = "CP932")
      }
  )
  
})