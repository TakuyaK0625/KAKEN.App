#########################################################
# パッケージ
#########################################################

library(shiny)
library(shinyTree)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(DT)
library(plotly)
library(fmsb)
library(wordcloud2)
library(data.table)
library(igraph)
library(threejs)

#########################################################
# データのインポート
#########################################################

#------------
# 科研データ
instD <- fread("99_cleaned_data/cleaned_df.csv", stringsAsFactors = F, select = c("所属機関", "年度", "区分名", "研究種目", "総配分額"))
detailD <- fread("99_cleaned_data/cleaned_df.csv", stringsAsFactors = F, select = c("所属機関", "年度", "区分名", "研究種目", "職名", "直接経費", "年数", "研究分担者", "キーワード"))



#------------
# 審査区分
kubun <- read.csv("99_cleaned_data/kubun.csv", stringsAsFactors = F)

#------------
# 大学リスト
univ <- read.csv("99_cleaned_data/university.csv", stringsAsFactors = F)

    
#########################################################
# 変数作成
#########################################################

#---------------
# 研究種目リスト
type <- instD$研究種目 %>% unique %>% sort

#----------------------------
# 審査区分チェックリストTree
review_list <- list()
for (i in unique(kubun$大区分)) {
    sub_list <- list()
    for(j in (kubun[kubun$大区分 == i, "中区分"])){
        sub <- as.list(rep("", length(kubun[kubun$中区分 == j, 1])))
        names(sub) <- kubun[kubun$中区分 == j, "小区分"]
        sub_list[[j]] <- sub
        }
    review_list[[i]] <- sub_list
    }

review_list <- c(review_list, "")
names(review_list) [12] <- "その他"



#-----------------
# 大学グループ

Group <- list(旧帝大 = univ[univ$旧帝大 == 1,]$Name,
                 旧六医大 = univ[univ$旧六医大 == 1,]$Name,
                 新八医大 = univ[univ$新八医大 == 1,]$Name,
                 NISTEP_G1 = univ[univ$NISTEP == "G1",]$Name,
                 NISTEP_G2 = univ[univ$NISTEP == "G2",]$Name,
                 NISTEP_G3 = univ[univ$NISTEP == "G3",]$Name,
                 国立財務_A = univ[univ$国立財務 == "A",]$Name,
                 国立財務_B = univ[univ$国立財務 == "B",]$Name,
                 国立財務_C = univ[univ$国立財務 == "C",]$Name,
                 国立財務_D = univ[univ$国立財務 == "D",]$Name,
                 国立財務_E = univ[univ$国立財務 == "E",]$Name,
                 国立財務_F= univ[univ$国立財務 == "F",]$Name,
                 国立財務_G = univ[univ$国立財務 == "G",]$Name,
                 国立財務_H = univ[univ$国立財務 == "H",]$Name
)



#-----------------
# レーダーチャート用関数

clean.radar <- function(x, y){
    
    x %>% group_by(所属機関) %>%
        summarize(N = n(), Total = sum(as.numeric(直接経費))) %>%
        mutate(LogAmount = log10(Total)-max(log10(Total)-4)) %>%
        mutate(LogCount = log10(N)-max(log10(N)-4)) %>%
        mutate(area = y)
}

