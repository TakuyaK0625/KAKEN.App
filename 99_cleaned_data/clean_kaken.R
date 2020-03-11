###############################
# パッケージ
###############################

library(dplyr)
library(DT)
library(data.table)
library(stringr)
library(purrr)
library(tidyr)


###############################
# データのインポート
###############################

# ----------------------------------
# 実際のファイル名を以下に代入する
# ----------------------------------

file.name.2018 <- "2018_20200301.csv"
file.name.2019 <- "2019_20200301.csv"


# 2018年度データのインポート
d2018 <- fread(file.name.2018) %>% 
    select(`研究課題/領域番号`, 研究代表者, 研究分担者, 審査区分, 研究種目,
                研究機関, 総配分額, `総配分額 (直接経費)`, キーワード, `研究期間 (年度)`) %>% 
    rename(研究課題番号 = `研究課題/領域番号`, 直接経費 = `総配分額 (直接経費)`) %>%
    mutate(年度 = 2018)

# 2019年度データのインポート
d2019 <- fread(file.name.2019) %>% 
    select(`研究課題/領域番号`, 研究代表者, 研究分担者, 審査区分, 研究種目,
                研究機関, 総配分額, `総配分額 (直接経費)`, キーワード, `研究期間 (年度)`) %>% 
    rename(研究課題番号 = `研究課題/領域番号`, 直接経費 = `総配分額 (直接経費)`) %>%
    mutate(年度 = 2019)

# 審査区分表
kubun <- read.csv("kaken_kubun.csv")


###############################
# 科研費データの整形
###############################


DF <- bind_rows(d2018, d2019) %>% 
    
    # 所属機関の整理
    mutate(所属機関 = str_replace(研究機関, "(^.+/ )(.+?)", "\\2")) %>%
    mutate(所属機関 = str_replace(所属機関, "\\(.*\\)", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^国立研究開発法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^公益財団法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^大学共同利用機関法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^独立行政法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^地方独立行政法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "^一般財団法人", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "株式会社", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "産業技術総合研究所", "産総研")) %>%
    mutate(所属機関 = str_replace(所属機関, "理化学研究所", "理研")) %>%
    mutate(所属機関 = str_replace(所属機関, "^国立文化財機構", "")) %>%
    mutate(所属機関 = str_replace(所属機関, "大学$", "")) %>%
    mutate(所属機関 = ifelse(str_detect(所属機関, "国立国語研究所"), "国立国語研究所", 所属機関)) %>%
    
    #職名の整理
    mutate(職名 = str_replace(研究代表者, "(^.+, )(.+?)", "\\2")) %>%
    mutate(職名 = str_replace(職名, "\\(.+\\)", "")) %>%
    mutate(職名 = ifelse(str_detect(職名, "助教"), "助教", 職名)) %>%
    mutate(職名 = ifelse(str_detect(職名, "講師"), "講師", 職名)) %>%
    mutate(職名 = ifelse(str_detect(職名, "准教授"), "准教授", 職名)) %>%
    mutate(職名 = ifelse(str_detect(職名, "(?<!准)教授"), "教授", 職名)) %>%
    mutate(職名 = ifelse(!str_detect(職名,"助教|講師|准教授|教授"), "その他", 職名)) %>%
    
    # 審査区分グループ
    mutate(区分 = str_extract(審査区分, "大区分|中区分|小区分")) %>%
    
    # 審査区分コード
    mutate(区分コード = ifelse(str_detect(審査区分, "大区分|中区分|小区分"), str_extract(審査区分, "\\d+"), NA)) %>%

    # 審査区分名の整理
    mutate(区分名 = ifelse(str_detect(審査区分, "大区分|中区分|小区分"), str_replace(審査区分, "^.+?:", ""), "その他")) %>%
    mutate(区分名 = str_replace(区分名, "およびその関連分野$", "")) %>%
    mutate(区分名 = str_replace(区分名, "関連$", ""))%>%
    
    # 研究期間
    mutate(期間 = str_extract_all(`研究期間 (年度)`, "\\d{4}")) %>%
    mutate(年数 = map_dbl(期間, function(x){
     if(length(unlist(x)) == 1){
         1
     } else {
         max(as.numeric(unlist(x))) - min(as.numeric(unlist(x)))
     }  
    }
    )) %>%
    select(-`研究期間 (年度)`, -期間)
    


# ファイルの出力
write.csv(DF, "../01_cleaned_data/cleaned_df.csv", fileEncoding = "UTF-8")