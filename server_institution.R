source("global.R")

# 元データフレームの作成
radarD <- D %>% 
    # 中区分列作成
    left_join(kubun %>% select(小区分, 中区分コード) %>% unique, by = c("区分名" = "小区分")) %>%
    mutate(中区分コード = ifelse(区分 == "中区分", 区分コード, 中区分コード)) %>%
    # 大区分列作成
    left_join(kubun %>% select(中区分コード, 大区分) %>% unique, by = c("中区分コード" = "中区分コード")) %>%
    mutate(大区分 = ifelse(区分 == "大区分", 審査区分, 大区分)) %>%
    # 必要な列選択
    select(年度, 研究課題番号, 所属機関, 研究種目, 直接経費, 審査区分, 中区分コード, 大区分)

    ##########################################################
    # 注：複数の審査区分にまたがる研究課題はコピーされている #
    ##########################################################

# 対数変換関数
clean.data <- function(x, y){
    
    x %>% group_by(所属機関) %>%
        summarize(N = n(), Total = sum(as.numeric(直接経費))) %>%
        mutate(LogAmount = log10(Total)-max(log10(Total)-4)) %>%
        mutate(LogCount = log10(N)-max(log10(N)-4)) %>%
        mutate(PercAmount = percentile(Total)) %>%
        mutate(PercCount = percentile(N)) %>%
        mutate(area = y)
}

# 軸範囲
interval <- list(対数 = c(0, 4), 百分率 = c(50, 100))   



observe({
    
    # 中区分
    output$radar_m <- renderPlotly({
        
    # 中区分ごとにネスト
        clean_M <- radarD %>% 
            select(-大区分) %>% 
            unique %>%
            filter(!is.na(中区分コード)) %>%
            nest(-中区分コード) %>%
            mutate(clean = map2(data, 中区分コード, clean.data)) %>% .$clean %>%
            bind_rows %>% select(所属機関, LogAmount, LogCount, PercAmount, PercCount, area) %>%
            gather(key = "key", value = "value", -所属機関, -area) %>%
            spread(key = area, value = value, fill = 0) %>%
            gather(key = "area", value = "value", -所属機関, -key) %>%
            mutate(対象 = ifelse(str_detect(key, "Amount"), "件数", "総額")) %>%
            mutate(表示方法 = ifelse(str_detect(key, "Log"), "対数", "百分率")) %>%
            
            # filter
            filter(所属機関 == input$institution) %>%
            filter(対象 == input$type1) %>%
            filter(表示方法 == input$type2) %>%
            mutate(area = as.numeric(area)) %>%
            arrange(area) %>%
            mutate(area = as.character(area))
        
        clean_M <- rbind(clean_M, clean_M[1,])
        
    plot_ly(type = 'scatterpolar', r = clean_M$value, theta = clean_M$area, fill = 'toself', mode = "markers", height = 600) %>% 
        layout(polar = list(
            radialaxis = list(visible = T, range = interval[[input$type2]], angle = 90, tickfont = list(size = 12, color = "red")),
            angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
        ),
        showlegend = F
        )
    })

    
    # 大区分
    output$radar_l <- renderPlotly({
        
        # 大区分ごとにネスト
        clean_L <- radarD %>% 
            filter(!is.na(大区分)) %>%
            nest(-大区分) %>%
            mutate(clean = map2(data, 大区分, clean.data)) %>% .$clean %>%
            bind_rows %>% select(所属機関, LogAmount, LogCount, PercAmount, PercCount, area) %>%
            gather(key = "key", value = "value", -所属機関, -area) %>%
            spread(key = area, value = value, fill = 0) %>%
            gather(key = "area", value = "value", -所属機関, -key) %>%
            mutate(対象 = ifelse(str_detect(key, "Amount"), "件数", "総額")) %>%
            mutate(表示方法 = ifelse(str_detect(key, "Log"), "対数", "百分率")) %>%
            
            # filter
            filter(所属機関 == input$institution) %>%
            filter(対象 == input$type1) %>%
            filter(表示方法 == input$type2) 
        
        clean_L <- rbind(clean_L, clean_L[1,])
        
        plot_ly(type = 'scatterpolar', r = clean_L$value, theta = clean_L$area, fill = 'toself', mode = "markers", height = 600) %>% 
            layout(polar = list(
                radialaxis = list(visible = T, range = interval[[input$type2]], angle = 90, tickfont = list(size = 12, color = "red")),
                angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
            ),
            showlegend = F
            )
    })
    
    
    
})    
