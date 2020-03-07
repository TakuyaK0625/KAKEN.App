#########################################################
# Environment
#########################################################

source("global.R", local = TRUE)


#########################################################
# User Interface
#########################################################

source("00_about/ui_about.R", local = TRUE)
source("01_inst/ui_inst.R", local = TRUE)
source("02_radar/ui_radar.R", local = TRUE)
source("03_detail/ui_detail.R", local = TRUE)

ui <- dashboardPage(
    dashboardHeader(title = "KAKEN分析アプリ（開発中）"),
    dashboardSidebar(sidebarMenu(
        menuItem("このアプリについて", icon = icon("info"), tabName = "about"),
        menuItem("機関別採択件数・額等", icon = icon("university"), tabName = "institution"),
        menuItem("機関別レーダーチャート", icon = icon("dot-circle"), tabName = "radar"),
        menuItem("審査区分・研究種目別特徴", icon = icon("th-large"), tabName = "detail")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem_about,
            tabItem_inst,
            tabItem_detail,
            tabItem_radar
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
}


#########################################################
# Execution
#########################################################


shinyApp(ui = ui, server = server)


