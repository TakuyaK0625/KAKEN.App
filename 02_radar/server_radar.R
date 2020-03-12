radarD <- fread("02_radar/radar_df.csv")


observe({
    
# -----------------------
# 中区分
    
    output$radar_m <- renderPlotly({
        
    # 中区分ごとにネスト
        clean_M <- radarD %>% 
            filter(年度 %in% input$year_radar[1]:input$year_radar[2]) %>%
            select(-大区分) %>% 
            unique %>%
            filter(!is.na(中区分コード)) %>%
            nest(-中区分コード) %>%
            mutate(clean = map2(data, 中区分コード, clean.radar)) %>% .$clean %>%
            bind_rows %>% select(所属機関, LogAmount, LogCount, area) %>%
            gather(key = "key", value = "value", -所属機関, -area) %>%
            spread(key = area, value = value, fill = 0) %>%
            gather(key = "area", value = "value", -所属機関, -key) %>%
            mutate(対象 = ifelse(str_detect(key, "Amount"), "件数", "総額")) %>%

            # filter
            filter(所属機関 %in% c(input$institution1, input$institution2, input$institution3)) %>%
            filter(対象 == input$type_radar) %>%
            mutate(area = as.numeric(area)) %>%
            arrange(area) %>%
            mutate(area = as.character(area))
        
        # 各機関の第一行目を追加
        clean_M <- rbind(clean_M, clean_M[1:length(unique(clean_M$所属機関)),,])
        
        # プロット  
        plot_ly(clean_M, type = 'scatterpolar', r = ~value, theta = ~area, color = ~所属機関, fill = "toself", alpha = 0.1, mode = "line", height = 600) %>% 
            layout(polar = list(
                radialaxis = list(visible = T, range = c(0, 4), angle = 90, tickfont = list(size = 12, color = "red")),
                angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
                ),
                showlegend = T
                )
        })


    
# -----------------------
# 大区分
    
    output$radar_l <- renderPlotly({
        
        # 大区分ごとにネスト
        clean_L <- radarD %>% 
            filter(!is.na(大区分)) %>%
            filter(年度 %in% input$year_radar[1]:input$year_radar[2]) %>%
            nest(-大区分) %>%
            mutate(clean = map2(data, 大区分, clean.radar)) %>% .$clean %>%
            bind_rows %>% select(所属機関, LogAmount, LogCount, area) %>%
            gather(key = "key", value = "value", -所属機関, -area) %>%
            spread(key = area, value = value, fill = 0) %>%
            gather(key = "area", value = "value", -所属機関, -key) %>%
            mutate(対象 = ifelse(str_detect(key, "Amount"), "件数", "総額")) %>%

            # filter
            filter(所属機関 %in% c(input$institution1, input$institution2, input$institution3)) %>%
            filter(対象 == input$type_radar) %>%
            arrange(area)
        
        # 各機関の第一行目を追加
        clean_L <- rbind(clean_L, clean_L[1:length(unique(clean_L$所属機関)),])
        
        # プロット
        plot_ly(clean_L, type = 'scatterpolar', r = ~value, theta = ~area, color = ~所属機関, alpha = 0.1, fill = "toself", mode = "line", height = 600) %>% 
            layout(polar = list(
                radialaxis = list(visible = T, range = c(0, 4), angle = 90, tickfont = list(size = 12, color = "red")),
                angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
            ),
            showlegend = T
            )
        })
    
    
    
})    
