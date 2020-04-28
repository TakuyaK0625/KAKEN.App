radarD <- fread("02_radar/radar_df.csv", colClasses = list(numeric = c(1, 5), character = c(2:4, 6:8)))

clean.radar <- function(x, y){
    d <- x[, .(N = .N, Total = sum(as.numeric(直接経費))), by = "所属機関"]
    d[, LogAmount := log10(Total)-max(log10(Total)-4)]
    d[, LogCount := log10(N)-max(log10(N)-4)]
    d[, area := y]
    as.data.table(d)
}



observe({
    
# -----------------------
# 中区分
    
    clean_M <- reactive({
        D1 <- radarD[年度 %in% input$year_radar[1]:input$year_radar[2], -"大区分"]
        D1 <- unique(D1)
        D1 <- D1[!is.na(中区分コード)]
        D1 <- D1[, .(data = list(.SD)), by = 中区分コード]
        D1[, clean := list(map2(data, 中区分コード, clean.radar))]
        
        D2 <- bind_rows(D1[中区分コード != "", clean]) 
        D2 <- D2[, .(所属機関, LogAmount, LogCount, area)]
        D2 <- melt(D2, measure.vars = c("LogAmount", "LogCount"), variable.name = "key", value.name = "value")
        D2 <- dcast(D2, formula = 所属機関+key ~ area, fill = 0)
        D2 <- melt(D2, id.vars = c("所属機関", "key"), variable.name = "area", value.name = "value")
        D2[, 対象 := ifelse(str_detect(key, "Amount"), "件数", "総額")]
        
        # filter
        D3 <- D2[所属機関 %in% c(input$institution1, input$institution2, input$institution3)]
        D3 <- D3[対象 == input$type_radar]
        D3[, area := as.numeric(as.character(area))]
        D3 <- D3[order(area)]
        rbind(D3, D3[1:length(unique(D3$所属機関)),])
    })

    
    # プロット  
    output$radar_m <- renderPlotly({

        plot_ly(clean_M(), type = 'scatterpolar', r = ~value, theta = ~area, color = ~所属機関, fill = "toself", alpha = 0.1, mode = "line", height = 600) %>% 
            layout(polar = list(
                radialaxis = list(visible = T, range = c(0, 4), angle = 90, tickfont = list(size = 12, color = "red")),
                angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
                ),
                showlegend = T
                )
    })


    
# -----------------------
# 大区分
    
    # 大区分ごとにネスト
    clean_L <- reactive({
        D1 <- radarD[年度 %in% input$year_radar[1]:input$year_radar[2]]
        D1 <- D1[, .(data = list(.SD)), by = 大区分]
        D1[, clean := list(map2(data, 大区分, clean.radar))]
        
        D2 <- bind_rows(D1[, clean]) 
        D2 <- D2[, .(所属機関, LogAmount, LogCount, area)]
        D2 <- melt(D2, measure.vars = c("LogAmount", "LogCount"), variable.name = "key", value.name = "value")
        D2 <- dcast(D2, formula = 所属機関 + key ~ area, fill = 0)
        D2 <- melt(D2, id.vars = c("所属機関", "key"), variable.name = "area", value.name = "value")
        D2[, 対象 := ifelse(str_detect(key, "Amount"), "件数", "総額")]
        
        # filter
        D3 <- D2[所属機関 %in% c(input$institution1, input$institution2, input$institution3)]
        D3 <- D3[対象 == input$type_radar]
        rbind(D3, D3[1:length(unique(D3$所属機関)),])
    })
    
    
    # プロット
    output$radar_l <- renderPlotly({
        
        plot_ly(clean_L(), type = 'scatterpolar', r = ~value, theta = ~area, color = ~所属機関, alpha = 0.1, fill = "toself", mode = "line", height = 600) %>% 
            layout(polar = list(
                radialaxis = list(visible = T, range = c(0, 4), angle = 90, tickfont = list(size = 12, color = "red")),
                angularaxis = list(rotation = 90, direction = "clockwise", type = "category")
            ),
            showlegend = T
            )
        })
    
    
    
})    
