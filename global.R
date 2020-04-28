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
# データ
instD <- fread("99_cleaned_data/cleaned_df.csv", 
               colClasses = list(character = c(1:3,6,8:14), numeric = c(4,5)), 
               select = c("所属機関", "年度", "区分名", "研究種目", "総配分額"))

detailD <- fread("99_cleaned_data/cleaned_df.csv", 
                 colClasses = list(character = c(1:3,6,8:14), numeric = c(4,5)), 
                 select = c("所属機関", "年度", "区分名", "研究種目", "職名", "直接経費", "年数", "研究分担者", "キーワード"))

networkD <- fread("04_network/network.csv", colClasses = c("character", "character", "character", "character", "integer", "character"))

researcher <- fread("04_network/researcher.csv", colClasses = c("integer", "character", "character"))



#------------
# 審査区分
kubun <- read.csv("99_cleaned_data/kubun.csv", colClasses = rep("character", 5))

#------------
# 大学リスト
univ <- read.csv("99_cleaned_data/university.csv", colClasses = rep("character", 7))

    
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

