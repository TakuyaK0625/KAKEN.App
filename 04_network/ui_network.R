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
                                 tabsetPanel(
                                     tabPanel("注意", type = "tabs",
                                              br(), 
                                              p("このページでは研究代表者と研究分担者情報を用いた共同研究関係のネットワークを可視化することができます。
                                                また、グラフはドラッグして回転させたり、ページスクロールの要領で拡大・縮小することができます。
                                                非常に重要な注意点としては、研究種目や審査区分の不要なチェックを外してから閲覧するようにしてください。
                                                計算が大変なため、対象を広げすぎると表示されるまでにかなりの時間がかかります。"),
                                              br(),
                                              p("【備考】"),
                                              p("・研究分担者を有する研究課題のみを表示しています。"),
                                              p("・研究者（研究代表者と研究分担者）を頂点（node/vertex）、１つの課題における全ての研究者のペアを辺（link/edge）としてネットワークを描画しています（無向グラフ）。"),
                                              p("・特定の機関の研究者をハイライトできるようにしていますが、入力の際には法人種別と「〜大学」を削除してください。"),
                                              p("・頂点にカーソルを合わせると研究者番号が表示されます。本来は８桁ですが、０から始まる研究者番号は０が落ちています。")
                                     ),
                                     tabPanel("ネットワーク", type = "tabs",
                                              scatterplotThreeOutput("network")
                                     )
                                 )
                                 )
                             )
                           )


