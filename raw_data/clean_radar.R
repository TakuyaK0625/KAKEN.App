library(dplyr)
library(data.table)

# データのインポート
D <- fread("../99_cleaned_data/cleaned_df.csv")
kubun <- fread("../99_cleaned_data/kubun.csv", colClasses = rep("character", 5))

# 中区分列を作成
D1 <- merge(D, kubun[, .(小区分, 中区分コード)] %>% unique, by.x = "区分名", by.y = "小区分", all.x = TRUE, allow.cartesian = T)
D1[, 中区分コード := ifelse(区分 == "中区分", 区分コード, 中区分コード)]

# 大区分列作成
D2 <- merge(D1, kubun[, .(中区分コード, 大区分)] %>% unique, by = "中区分コード", all.x = TRUE, allow.cartesian = T)
D2[, 大区分 := ifelse(区分 == "大区分", 区分名, 大区分)]


D3 <- D2[区分 != "", .(年度, 研究課題番号, 所属機関, 研究種目, 直接経費, 区分, 中区分コード, 大区分)]

# csvで書き出し
fwrite(D3, "../02_radar/radar_df.csv")
