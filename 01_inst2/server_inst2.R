# 審査区分チェックボックス
observe({
    output$area_inst2 <- renderTree({ 
        review_list
        })
})



# 研究種目全選択ボタン
observe({
    if(input$selectall_inst2 == 0) return(NULL) 
    else if (input$selectall_inst2%%2 == 0)
    {
        updateCheckboxGroupInput(session, "type_inst2", "研究種目", choices = type)
    }
    else
    {
        updateCheckboxGroupInput(session, "type_inst2", "研究種目", choices = type, selected = type)
    }
})


observe({
  # データのフィルタリング
  D0 <- eventReactive(input$filter_inst2, {
      
      # 研究機関グループでフィルター
      instD <- instD[所属機関 %in% c(Group[[input$group_inst2]], input$inst_inst2)]

      # 審査区分でフィルター
      area <- get_selected(input$area_inst2, format = "classid") %>% unlist
      instD <- instD[区分名 %in% area]
      
      # 研究種目でフィルター
      instD <- instD[研究種目 %in% input$type_inst2]
      
      # 集計期間でフィルター      
      instD <- instD[年度 %in% input$year_inst2[1]:input$year_inst2[2]]
  })
  
  
# ---------------------  
# 時系列タブ
# ---------------------  
  
  # 折れ線グラフのためのDF
  D_line <- reactive({
      D1 <- D0()[, .(件数 = .N, 総額 = sum(as.numeric(総配分額))), by = .(所属機関, 年度)]
      D1[, 平均額 :=  round(総額/件数, 1)]
      D1[, 総額シェア := round(100 * 総額/sum(総額), 3)]
      D1[, 年度 := as.factor(年度)]
  })
  
 
  # 折れ線グラフ
  output$line_inst2 <- renderPlotly({
    D_line() %>%
      plot_ly(x = ~年度, y = ~eval(as.name(input$line_yaxis2)), color = ~所属機関) %>% 
          add_lines() %>%
          layout(xaxis = list(range = input$year_inst2), yaxis = list(title = input$line_yaxis2))
  })
  
  
  # 集計表
  output$table_line_inst2 <- renderDataTable({
      D1 <- D_line()[, .(所属機関, 年度, eval(as.name(input$line_yaxis2)))]
      D1 <- dcast(D1, formula = 所属機関 ~ 年度)
      D1 %>% datatable(rownames = FALSE)
  })
  
  
  # 集計表のダウンロード
  output$downloadData_line2 <- downloadHandler(
      filename = "kaken_summary.csv",
      content = function(file) {
          write.csv(D_line(), row.names = FALSE, fileEncoding = "CP932")
      }
  )

})
