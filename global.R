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
# 科研費
D <- fread("99_cleaned_data/cleaned_df.csv", stringsAsFactors = F) 
radarD <- fread("99_cleaned_data/radar_df.csv")
networkD <- fread("99_cleaned_data/network.csv")
researcher <- fread("99_cleaned_data/researcher.csv")

#------------
# 審査区分表
kubun <- read.csv("99_cleaned_data/kubun.csv", stringsAsFactors = F)

    
#########################################################
# 変数作成
#########################################################

#---------------
# 研究種目リスト
type <- D$研究種目 %>% unique %>% sort


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

Group <- list(旧帝大 = c("東京", "京都", "大阪", "北海道", "東北", "名古屋", "九州"),
                 旧六大 = c("千葉", "金沢", "新潟", "岡山", "長崎", "熊本"),
                 新八大 = c("東京医科歯科", "弘前", "群馬", "信州", "鳥取", "徳島", "広島", "鹿児島"),
                 NISTEP_G1 = c("東京", "京都", "東北", "大阪"),
                 NISTEP_G2 = c("岡山", "金沢", "九州", "神戸", "千葉", "筑波", "東工", "名古屋", "広島", "北海道"),
                 NISTEP_G3 = c("愛媛", "鹿児島", "岐阜", "熊本", "群馬", "静岡", "信州", "東京医歯", "東京農工", "徳島",
                         "鳥取", "富山", "長崎", "名古屋工業", "新潟", "三重", "山形", "山口"),
                 国立財務_A = c("北海道", "東北", "筑波", "千葉", "東京", "新潟", "名古屋", "京都", "大阪", "神戸", "岡山", "広島", "九州"),
                 国立財務_B = c("室蘭工業", "帯広畜産", "北見工業", "東京農工", "東京工業", "東京海洋", "電気通信", "長岡技術科学", "名古屋工業",
                            "豊橋技術科学", "京都工芸繊維", "九州工業", "鹿屋体育"),
                 国立財務_C = c("小樽商科", "福島", "筑波技術", "東京外国語", "東京藝術", "一橋", "滋賀", "大阪外国語"),
                 国立財務_D = c("旭川医科", "東京医科歯科", "浜松医科", "滋賀医科"),
                 国立財務_E = c("北海道教育", "宮城教育", "東京学芸", "上越教育", "愛知教育", "京都教育", "大阪教育", "兵庫教育", "奈良教育", "鳴門教育", "福岡教育"),
                 国立財務_F = c("北陸先端科学技術大学院", "奈良先端科学技術大学院", "総合研究大学院", "政策研究大学院"),
                 国立財務_G = c("弘前", "秋田", "山形", "群馬", "富山", "金沢", "福井", "山梨", "信州", "岐阜", "三重", "鳥取", "島根", "山口", "徳島", "香川", "愛媛",
                            "高知", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "琉球"),
                 国立財務_H = c("岩手", "茨城", "宇都宮", "埼玉", "お茶の水女子", "横浜国立", "静岡", "奈良女子", "和歌山")
)



#-----------------
# レーダーチャート用関数

clean.radar <- function(x, y){
    
    x %>% group_by(所属機関) %>%
        summarize(N = n(), Total = sum(as.numeric(直接経費))) %>%
        mutate(LogAmount = log10(Total)-max(log10(Total)-4)) %>%
        mutate(LogCount = log10(N)-max(log10(N)-4)) %>%
        mutate(PercAmount = percentile(Total)) %>%
        mutate(PercCount = percentile(N)) %>%
        mutate(area = y)
}

