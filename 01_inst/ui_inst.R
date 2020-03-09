source("global.R")

tabItem_inst <- tabItem(tabName = "institution", sidebarLayout(
                             
                             # サイドバー
                             sidebarPanel(
                                 fluidRow(
                                     column(6, sliderInput("year_inst", "対象年度", min = 2018, max = 2020, value = c(2018, 2019))),
                                     column(6, selectInput("group_inst", "絞り込み", choices = c("全機関", names(Group)))),
                                     column(6, textInput("inst_inst", "追加機関", value = "信州"))
                                 ),
                                 
                                 # 審査区分チェックボックス
                                 p(strong("審査区分")),
                                 shinyTree("area_inst", checkbox = TRUE),
                                 br(),
                                 
                                 # 研究種目チェックボックス
                                 checkboxGroupInput("type_inst", "研究種目", type)
                               ),
                             
                             # メインパネル
                             mainPanel(
                                 tabsetPanel(type = "tabs",
                                             tabPanel("総計",

                                                      # 棒グラフ  
                                                      h1(strong("Bar plot")),
                                                      fluidRow(
                                                          column(3, selectInput("bar_yaxis", "Y軸の値", choices = list("件数", "総額", "平均額", "総額シェア"))),
                                                          column(3, sliderInput("bar_n", "表示件数", min = 0, max = 50, value = 10, step = 1))
                                                      ),
                                                      plotlyOutput("bar_inst"),
                                                      br(),
                                                      

                                                      # ヒストグラム 
#                                                      h1(strong("Histogram")),
#                                                      fluidRow(
#                                                          column(2, selectInput("hist_var", "X軸の値", choices = list("件数", "総額", "平均", "総額シェア"), selected = "総額"))
#                                                      ),
#                                                      plotlyOutput("hist_inst"),
#                                                      br(),

                                                                                                            
                                                      # 散布図
                                                      h1(strong("Scatter plot")),
                                                      fluidRow(
                                                          column(2, selectInput("scatter_xaxis", "X軸の値", choices = list("件数", "総額", "平均額", "総額シェア"), selected = "件数")),
                                                          column(2, selectInput("scatter_yaxis", "Y軸の値", choices = list("件数", "総額", "平均額", "総額シェア"), selected = "総額"))
                                                      ),
                                                      plotlyOutput("scatter_inst"),
                                                      br(),
                                                      
                                                      # 元データ
                                                      h1(strong("Summary Data")),
                                                      dataTableOutput("table_all_inst"),
                                                      downloadButton("downloadData_all", "Download")
                                                      ),
                                             
                                             tabPanel("時系列", 
                                                      # 折れ線グラフ  
                                                      h1(strong("Line plot")),
                                                      fluidRow(
                                                          column(3, selectInput("line_yaxis", "Y軸の値", choices = list("件数", "総額", "平均額", "総額シェア")))
                                                      ),
                                                      plotlyOutput("line_inst"),
                                                      h1(strong("Summary Data")),
                                                      dataTableOutput("table_line_inst"),
                                                      downloadButton("downloadData_line", "Download")
                                                      )
                                     )
                                 )
                             )
                        )
                

