# パッケージ
library(dplyr)
library(data.table)
library(stringr)

# 審査区分表
kubun <- read.csv("kaken_kubun.csv")

kubun %>% 
    mutate(中区分 = str_replace(中区分, "およびその関連分野", "")) %>%
    mutate(小区分 = str_replace(小区分, "関連$", "")) %>%
    fwrite("../99_cleaned_data/kubun.csv")
