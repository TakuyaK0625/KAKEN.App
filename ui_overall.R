source("global.R")

# UI
tabItem_overall <- tabItem(tabName = "Overall",
                           sidebarLayout(
                             
                             # サイドバー
                             sidebarPanel(
                                 fluidRow(
                                     column(6, sliderInput("year", "対象年度", min = 2018, max = 2020, value = c(2018, 2019), step = 1)),
                                     column(6, selectInput("group", "絞り込み", choices = c("全機関", names(Group))))
                                 ),
                                 
                                 # 審査区分チェックボックス
                                 p(strong("審査区分")),
                                 shinyTree("tree", checkbox = TRUE),
                                 br(),
                                 
                                 # 研究種目チェックボックス
                                 checkboxGroupInput("type", "研究種目", type)
                               ),
                             
                             # メインパネル
                             mainPanel(
                                 
                               # 棒グラフ  
                               h1(strong("Bar plot")),
                               fluidRow(
                                   column(3, selectInput("bar_yaxis", "Y軸の値", choices = list("件数", "総額", "平均", "総額シェア"))),
                                   column(3, sliderInput("amount", "表示件数", min = 0, max = 50, value = 10, step = 1))
                               ),
                               plotlyOutput("overall_bar"),
                               br(),
                               
                               # 折れ線グラフ  
                               h1(strong("Line plot")),
                               fluidRow(
                                   column(3, selectInput("line_yaxis", "Y軸の値", choices = list("件数", "総額", "平均", "総額シェア"))),
                                   column(3, sliderInput("amount", "表示件数", min = 0, max = 50, value = 10, step = 1))
                               ),
                               plotlyOutput("overall_line"),
                               br(),
                               
                               
                               # 散布図
                               h1(strong("Scatter plot")),
                               fluidRow(
                                   column(2, selectInput("scatter_xaxis", "X軸の値", choices = list("件数", "総額", "平均", "総額シェア"), selected = "件数")),
                                   column(2, selectInput("scatter_yaxis", "Y軸の値", choices = list("件数", "総額", "平均", "総額シェア"), selected = "総額"))
                               ),
                               plotlyOutput("overall_scatter"),
                               br(),
                               
                               # 元データ
                               h1(strong("Summary Data")),
                               dataTableOutput("overall_table"),
                               downloadButton("downloadData", "Download")
                              )
                             )
                           )

