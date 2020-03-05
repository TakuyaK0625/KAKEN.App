source("global.R")

# UI
tabItem_reviewsection <- tabItem(tabName = "ReviewSection",
                           sidebarLayout(
                               
                               # サイドバー
                               sidebarPanel(
                                   fluidRow(
                                       column(6, sliderInput("review_year", "対象年度", min = 2018, max = 2020, value = c(2018, 2019), step = 1)),
                                       column(6, selectInput("review_group", "絞り込み", choices = c("全機関", names(Group))))
                                   ),
                                   p(strong("審査区分")),
                                   shinyTree("review_tree", checkbox = TRUE),
                                   br(),
                                   checkboxGroupInput("review_type", "研究種目", type)
                               ),
                               
                               # メインパネル
                               mainPanel(
                                   h2(strong("職位名")),
                                   plotlyOutput("review_job_gragh"),
                                   h2(strong("直接経費総額")),
                                   plotlyOutput("review_amount_gragh"),
                                   h2(strong("キーワード")),
                                   wordcloud2Output("review_key_word")
                               )
                           )
)

