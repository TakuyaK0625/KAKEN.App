source("global.R")

tabItem_network <- tabItem(tabName = "network", sidebarLayout(
                             
                             # サイドバー
                             sidebarPanel(
                                 fluidRow(
                                     column(6, sliderInput("year_net", "対象年度", min = 2018, max = 2020, value = c(2018, 2019))),
                                     column(6, textInput("inst_net", "ハイライト機関", value = "信州"))
                                 ),
                                 
                                 # 審査区分チェックボックス
                                 p(strong("審査区分")),
                                 shinyTree("area_net", checkbox = TRUE),
                                 br(),
                                 
                                 # 研究種目チェックボックス
                                 checkboxGroupInput("type_net", "研究種目", type)
                               ),
                             
                             # メインパネル
                             mainPanel(
                                 scatterplotThreeOutput("network")
                                 )
                             )
                        )
                

