library(dplyr)
library(data.table)

D <- fread("../99_cleaned_data/clean_df.csv")
kubun <- fread("../99_cleaned_data/kubun.csv")

# 元データフレームの作成
radarD <- D %>% 
  # 中区分列作成
  left_join(kubun %>% select(小区分, 中区分コード) %>% unique, by = c("区分名" = "小区分")) %>%
  mutate(中区分コード = ifelse(区分 == "中区分", 区分コード, 中区分コード)) %>%
  # 大区分列作成
  left_join(kubun %>% select(中区分コード, 大区分) %>% unique, by = c("中区分コード" = "中区分コード")) %>%
  mutate(大区分 = ifelse(区分 == "大区分", 審査区分, 大区分)) %>%
  # 必要な列選択
  select(年度, 研究課題番号, 所属機関, 研究種目, 直接経費, 審査区分, 中区分コード, 大区分)

write.csv(radarD, "../99_cleaned_data/radar_df.csv")
