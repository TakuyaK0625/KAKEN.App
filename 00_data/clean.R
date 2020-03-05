###############################
# パッケージ
###############################

library(dplyr)
library(DT)
library(data.table)
library(stringr)


###############################
# データのインポート
###############################

d2018 <- fread("2018_20200301.csv") %>% 
    select(研究課題名, `研究課題/領域番号`, 研究代表者, 研究分担者, 審査区分, 研究種目,
                研究機関, 応募区分, 総配分額, `総配分額 (直接経費)`, キーワード) %>% 
    rename(研究課題番号 = `研究課題/領域番号`, 直接経費 = `総配分額 (直接経費)`) %>%
    mutate(年度 = 2018)
    
d2019 <- fread("2019_20200301.csv") %>% 
    select(研究課題名, `研究課題/領域番号`, 研究代表者, 研究分担者, 審査区分, 研究種目,
                研究機関, 応募区分, 総配分額, `総配分額 (直接経費)`, キーワード) %>% 
    rename(研究課題番号 = `研究課題/領域番号`, 直接経費 = `総配分額 (直接経費)`) %>%
    mutate(年度 = 2019)

kubun <- read.csv("kaken_kubun.csv")


###############################
# データの整形
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
    mutate(区分名 = ifelse(str_detect(審査区分, "大区分|中区分|小区分"), str_replace(審査区分, "^.+?:", ""), "その他"))

# ファイルの出力
write.csv(DF, "clean_df.csv", fileEncoding = "CP932")
