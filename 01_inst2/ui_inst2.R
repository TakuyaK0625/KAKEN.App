tabItem_inst2 <- tabItem(tabName = "institution2", sidebarLayout(
                             
                             # サイドバー
                             sidebarPanel(
                               
                               # フィルター適用ボタン
                               actionButton("filter_inst2", (strong("Apply Filter")), 
                                            style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                               br(),
                               br(),
                               
                               # 研究期間/比較機関
                               fluidRow(
                                 column(6, selectInput("group_inst2", "グループ", choices = c("---", names(Group)))),
                                 column(6, textInput("inst_inst2", "追加機関", value = "信州")),
                                 column(12, sliderInput("year_inst2", "対象年度", min = 2018, max = 2020, value = c(2018, 2019)))
                               ),
                               
                                 # 審査区分チェックボックス
                                 p(strong("審査区分")),
                                 shinyTree("area_inst2", checkbox = TRUE),
                                 br(),
                                 
                                 # 研究種目チェックボックス
                                 checkboxGroupInput("type_inst2", "研究種目", type),
                                 actionLink("selectall_inst2", "Select All")
                               ),
                             
                             # メインパネル
                             mainPanel(
                                 tabsetPanel(type = "tabs",
                                             tabPanel("時系列", 
                                                      # 折れ線グラフ  
                                                      h1(strong("Line plot")),
                                                      fluidRow(
                                                          column(3, selectInput("line_yaxis2", "Y軸の値", choices = list("件数", "総額", "平均額", "総額シェア")))
                                                      ),
                                                      plotlyOutput("line_inst2"),
                                                      h1(strong("Summary Data")),
                                                      dataTableOutput("table_line_inst2"),
                                                      downloadButton("downloadData_line2", "Download")
                                                      ),

                                             tabPanel("備考", 
                                                      br(),
                                                      p("このページでは研究代表者の所属機関単位で各種の集計/可視化が行えるようになっています。特定のグループ内で
                                                        複数機関を比較することを想定していますが、そこに任意の機関を加えることも可能です。なお、注意点は以下の通りです。"),
                                                      br(),
                                                      p(strong("【所属機関について】")),
                                                      p("・転職等により所属機関が複数にまたがる場合には、最も古い所属機関を用いて集計しています。"),
                                                      p("・所属機関はあらかじめ法人種別や「〜大学」を削除しています。任意の機関を分析に加える場合にも、法人種別や「〜大学」は
                                                        削除するようにしてください（例：「国立大学法人信州大学」⇨「信州」）。"),
                                                      br(),
                                                      p(strong("【研究機関グループについて】")),
                                                      p("研究機関グループは以下の文献、サイトを参考にしています。"),
                                                      br(),
                                                      p(strong("◯旧帝大")),
                                                      p("https://ja.wikipedia.org/wiki/旧帝大"),
                                                      p(strong("◯旧六医大")),
                                                      p("https://ja.wikipedia.org/wiki/旧六医大"),
                                                      p(strong("◯新八医大")),
                                                      p("https://ja.wikipedia.org/wiki/新八医大"),
                                                      p(strong("◯NISTEP_G1~G3")),
                                                      p("NISTEPによる2009年〜2013年の論文シェアに基づく大学グループ分類。以下の文献を参考。"),
                                                      p("村上 昭義、伊神 正貫 「科学研究のベンチマーキング 2019」，NISTEP RESEARCH MATERIAL， No.284，
                                                        文部科学省科学技術・学術政策研究所. DOI: http://doi.org/10.15108/rm284"),
                                                      p(strong("◯国立財務_A~H")),
                                                      p("https://www.mext.go.jp/b_menu/shingi/kokuritu/sonota/06030714.htm")
                                                      )

                                     )
                                 )
                             )
                        )
                

