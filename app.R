#########################################################
# Environment
#########################################################

source("global.R", local = TRUE)


#########################################################
# User Interface
#########################################################

# ソース
source("00_about/ui_about.R", local = TRUE)
source("01_inst/ui_inst.R", local = TRUE)
source("02_radar/ui_radar.R", local = TRUE)
source("03_detail/ui_detail.R", local = TRUE)
source("04_network/ui_network.R", local = TRUE)

# レイアウト
ui <- dashboardPage(
    dashboardHeader(title = "KAKEN分析アプリ"),
    dashboardSidebar(sidebarMenu(
        menuItem("このアプリについて", icon = icon("info"), tabName = "about"),
        menuItem("機関別採択額・件数等", icon = icon("university"), tabName = "institution"),
        menuItem("機関別レーダーチャート", icon = icon("dot-circle"), tabName = "radar"),
        menuItem("審査区分・研究種目別特徴", icon = icon("th-large"), tabName = "detail"),
        menuItem("研究者ネットワーク", icon = icon("project-diagram"), tabName = "network")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem_about,
            tabItem_inst,
            tabItem_detail,
            tabItem_radar,
            tabItem_network
        )
        )
    )


#########################################################
# Server
#########################################################


server <- function(input, output, session) {
    
    source("01_inst/server_inst.R", local = TRUE)
    source("02_radar/server_radar.R", local = TRUE)
    source("03_detail/server_detail.R", local = TRUE)
    source("04_network/server_network.R", local = TRUE)
}


#########################################################
# Execution
#########################################################


shinyApp(ui = ui, server = server)