# UI
tabItem_radar <- tabItem(tabName = "radar",
                               sidebarLayout(
    
                                   # サイドバー
                                   sidebarPanel(
                                       sliderInput("year_radar", "期間", min = 2018, max = 2020, value = c(2018, 2019)),
                                       textInput("institution1", "機関名１", value = "信州"),
                                       textInput("institution2", "機関名２", value = ""),
                                       textInput("institution3", "機関名３", value = ""),
                                       br(),
                                       selectInput("type_radar", "対象", choices = c("件数", "総額"))
                                       ),
                              
                              # メインパネル
                              mainPanel(
                                  tabsetPanel(type = "tabs",
                                              tabPanel("中区分", plotlyOutput("radar_m")),
                                              tabPanel("大区分", plotlyOutput("radar_l")),
                                              tabPanel("備考", 
                                                       br(),
                                                       p("このページでは、審査区分ごとの採択件数や直接経費の総額をレーダーチャート形式で可視化することができます。
                                                       最大で表示できる機関数は３機関までです。複数の機関を表示させた後に特定の機関の凡例をクリックをすることで、表示の有無を切り替えることもできます。"),
                                                       br(),
                                                       p("【備考】"),
                                                       p("・最上位の機関の値は４となるように調整（外周 = 最大値が４）。１の変化は実際の値の１０倍、１/１０に相当し, ０.５の差は実際の値の約３.３倍, １/３.３に相当する。
                                                         以下の文献を参考。"),
                                                       p("調麻佐志（2018）「科学研究費補助事業採択データによる大学の強みや多様性の可視化」『特別研究促進費「研究力分析指標プロジェクト」報告書（2016-2017年度）』
                                                         https://www.ruconsortium.jp/uploaded/life/248_387_misc.pdf"),
                                                       p("・所属機関の定義については「機関別採択額・件数等」の備考をご参照ください。")
                                                       )
                                  )
                              )
                            )
)
