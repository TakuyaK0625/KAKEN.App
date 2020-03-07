source("global.R")

# UI
tabItem_radar <- tabItem(tabName = "radar",
                               sidebarLayout(
    
                                   # サイドバー
                                   sidebarPanel(
                                       sliderInput("interval", "期間", min = 2018, max = 2020, value = c(2018, 2019)),
                                       textInput("institution1", "機関名１", value = "信州"),
                                       textInput("institution2", "機関名２", value = ""),
                                       textInput("institution3", "機関名３", value = ""),
                                       br(),
                                       selectInput("type1", "対象", choices = c("件数", "総額")),
                                       selectInput("type2", "表示方法", choices = c("対数", "百分率"))
                                       ),
                              
                              # メインパネル
                              mainPanel(
                                  tabsetPanel(type = "tabs",
                                              tabPanel("中区分", plotlyOutput("radar_m")),
                                              tabPanel("大区分", plotlyOutput("radar_l")),
                                              tabPanel("（注）図の見方", 
                                                       br(),
                                                       p("このレーダーチャートは、各機関の審査区分ごとの採択件数や直接経費の総額を一覧するための
                                                         グラフです。スケールは常用対数または百分率を用いていますが、それぞれの詳細は以下の通りです。"),
                                                       br(),
                                                       p("【対数】"),
                                                       p("最上位の機関の値は4であり、最小値は0。1の変化は実際の値の10倍、1/10に相当し, 0.5の差は実際の値の約3.3倍, 1/3.3に相当する。"),
                                                       p("（参考）https://www.ruconsortium.jp/uploaded/life/248_387_misc.pdf"),
                                                       br(),
                                                       p("【百分率】"),
                                                       p("下から数えて全体の何%の位置にあるのかを表す。0〜100の値をとるが、グラフでは50〜100の範囲のみ表示。")
                                                       
                                                       
                                                       )
                                  )
                              )
                            )
)
