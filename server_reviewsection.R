source("global.R")


observe({
    
    output$review_tree <- renderTree({ 
        review_list
    })
    
    DF <- reactive({
        
        # 研究機関グループでフィルター
        if (input$group != "全機関"){
            D <- D %>% filter(所属機関 %in% Group[[input$group]])
        }
        
        # 審査区分でフィルター
        area <- get_selected(input$review_tree, format = "classid") %>% unlist
        D <- D %>% filter(区分名 %in% area) 

        # 研究種目、年度でフィルター
        D %>% 
            filter(研究種目 %in% input$review_type) %>%
            filter(年度 %in% input$review_year)
    })
    
    
    # 審査区分別の職名
    output$review_job_gragh <- renderPlotly({
        DF() %>% group_by(区分名, 職名) %>%
            summarize(件数 = n()) %>%
            mutate(職名 = factor(職名, levels = c("教授", "准教授", "講師", "助教", "その他"))) %>%
            plot_ly() %>%
            add_bars(y = ~区分名, x = ~件数, color = ~職名, orientation = "h") %>%
            layout(barmode = "stack", yaxis = list(title = ""))
    })
    
    # 審査区分別の直接経費
    output$review_amount_gragh <- renderPlotly({
        DF() %>% 
            plot_ly(y = ~区分名, x = ~直接経費, type = "box", orientation = "h") %>%
            layout(yaxis = list(title = ""))
    })
    
    # キーワード語彙頻度
    output$review_key_word <- renderWordcloud2({
        DF() %>% .$キーワード %>% 
            str_split(" / ") %>% 
            unlist() %>% 
            table %>% 
            as.data.frame %>% 
            arrange(-Freq) %>%
            wordcloud2
    })
    
    
})    
