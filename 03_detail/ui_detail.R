source("global.R")

# UI
tabItem_detail <- tabItem(tabName = "detail",
                           sidebarLayout(
                               
                               # サイドバー
                               sidebarPanel(
                                   fluidRow(
                                       column(6, sliderInput("year_detail", "対象年度", min = 2018, max = 2020, value = c(2018, 2019), step = 1)),
                                       column(6, selectInput("group_detail", "絞り込み", choices = c("全機関", names(Group))))
                                   ),
                                   p(strong("審査区分")),
                                   shinyTree("tree_detail", checkbox = TRUE),
                                   br(),
                                   checkboxGroupInput("type_detail", "研究種目", type)
                               ),
                               
                               # メインパネル
                               mainPanel(
                                   tabsetPanel(type = "tabs",
                                               tabPanel("職位",
                                                   h2("件数"),
                                                   plotlyOutput("job_count"),
                                                   h2("割合"),
                                                   plotlyOutput("job_ratio")
                                               ),
                                               tabPanel("直接経費",
                                                   plotlyOutput("review_amount_gragh")
                                               ),
                                               tabPanel("研究分担者数",
                                                   plotlyOutput("review_buntan_gragh")
                                               ),
                                               tabPanel("キーワード",
                                                        h2("ワードクラウド"),
                                                        wordcloud2Output("keyword_cloud"),
#                                                        h2("集計表"),
                                                        dataTableOutput("keyword_table")
                                                        )
                                               )
                               )
                           )
)

