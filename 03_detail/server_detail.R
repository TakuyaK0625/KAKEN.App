# 審査区分チェックボックス
observe({
    output$area_detail <- renderTree({ 
        review_list
        })
})


# 研究種目全選択ボタン
observe({
    if(input$selectall_detail == 0) return(NULL) 
    else if (input$selectall_detail%%2 == 0)
    {
        updateCheckboxGroupInput(session, "type_detail", "研究種目", choices = type)
    }
    else
    {
        updateCheckboxGroupInput(session, "type_detail", "研究種目", choices = type, selected = type)
    }
})


observe({
    
    D0 <- eventReactive(input$filter_detail, {
        
        # 研究機関グループでフィルター
        if (input$group_detail != "全機関"){
            detailD <- detailD[所属機関 %in% Group[[input$group_detail]]]
        }
        
        # 審査区分でフィルター
        area <- get_selected(input$area_detail, format = "classid") %>% unlist
        detailD <- detailD[区分名 %in% area] 

        # 研究種目、年度でフィルター
        detailD[研究種目 %in% input$type_detail & 年度 %in% input$year_detail[1]:input$year_detail[2]]
    })
    

# -----------------------------------
# 職名
    
    # 棒グラフ（件数）
    output$job_count <- renderPlotly({
        
        D1 <- D0()[, .(件数 = .N), by = .(区分名, 職名)]
        D1[, 職名 := factor(職名, levels = c("教授", "准教授", "講師", "助教", "その他"))] %>%
            plot_ly() %>%
            add_bars(y = ~区分名, x = ~件数, color = ~職名, orientation = "h") %>%
            layout(barmode = "stack", yaxis = list(title = ""))
    })

    
    # 棒グラフ（割合）
    output$job_ratio <- renderPlotly({
        
        D1 <- D0()[, .(件数 = .N), by = .(区分名, 職名)]
        D1[, 職名 := factor(職名, levels = c("教授", "准教授", "講師", "助教", "その他"))]
        D1 <- D1[, .(職名, 割合 = 100 * 件数/sum(件数)), by = 区分名]
        D1 %>% plot_ly() %>%
            add_bars(y = ~区分名, x = ~割合, color = ~職名, orientation = "h") %>%
            layout(barmode = "stack", yaxis = list(title = ""))
    })

    
# -----------------------------------
# 直接経費総額・年数
    
    # 直接経費総額
    output$directcost <- renderPlotly({
        D0()[年数 %in% input$duration_detail[1]:input$duration_detail[2]] %>%
            plot_ly(y = ~区分名, x = ~直接経費, type = "box", orientation = "h") %>%
            layout(yaxis = list(title = ""))
    })
    
    # 年数
    output$years <- renderPlotly({
        D0() %>% 
            plot_ly(y = ~区分名, x = ~年数, type = "box", orientation = "h") %>%
            layout(yaxis = list(title = ""))
    })
    
# -----------------------------------
# 研究分担者数
    
    # 箱ひげ図
    output$review_buntan_gragh <- renderPlotly({
        D0()[研究分担者 != ""
                  ][, 分担者数 := str_count(研究分担者, "\n") + 1] %>%
            plot_ly(y = ~区分名, x = ~分担者数, type = "box", orientation = "h") %>%
            layout(yaxis = list(title = ""))
    })
    

# -----------------------------------
# キーワード
    
    # データの整形
    keyword_df <- reactive({
        D0()$キーワード %>% 
            str_split(" / ") %>% 
            unlist() %>% 
            table(dnn = list("語彙")) %>% 
            as.data.frame(responseName = "頻度") %>%
            arrange(-頻度)
    })
    
    # キーワード：ワードクラウド
    output$keyword_cloud <- renderWordcloud2({
        keyword_df() %>% 
            filter(頻度 > 1) %>%
            wordcloud2(size = 0.5)
    })
    
    # キーワード：頻度表
    output$keyword_table <- renderDataTable({
        keyword_df() %>% datatable(rownames = F) 
    })
    
})    
