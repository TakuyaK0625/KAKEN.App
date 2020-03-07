library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(data.table)
library(igraph)
library(threejs)

# インポート
d <- read.csv("../01_cleaned_data/clean_df.csv", fileEncoding = "CP932", stringsAsFactors = F)

# データの整形・共同研究者の展開と整理
D0 <- d %>% filter(研究分担者 != "") %>%
    mutate(代表ID = str_extract(研究代表者, "\\d{8}")) %>%
    mutate(分担者 = str_split(研究分担者, "\n")) %>% 
    unnest(cols = 分担者) %>%
    mutate(分担ID = str_extract(分担者, "\\d{8}")) %>%
    mutate(分担所属 = str_extract(分担者, "^.+?(?=,)")) %>%
    mutate(分担所属 = str_replace(分担所属, "(^.+ )(.+$)", "\\2")) %>%
    select(研究課題番号, 研究種目, 総配分額, 年度, 区分, 区分名, 代表ID, 分担ID, 所属機関, 分担所属) %>%
    mutate(分担所属 = str_replace(分担所属, "^国立研究開発法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "^公益財団法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "^大学共同利用機関法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "^独立行政法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "^地方独立行政法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "^一般財団法人", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "株式会社", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "産業技術総合研究所", "産総研")) %>%
    mutate(分担所属 = str_replace(分担所属, "理化学研究所", "理研")) %>%
    mutate(分担所属 = str_replace(分担所属, "^国立文化財機構", "")) %>%
    mutate(分担所属 = str_replace(分担所属, "大学$", "")) %>%
    mutate(分担所属 = ifelse(str_detect(分担所属, "国立国語研究所"), "国立国語研究所", 分担所属))

# 全ての研究者のIDと所属を取得
Res <- bind_rows(
    D0 %>% select(代表ID, 所属機関) %>% rename("ID" = "代表ID", "所属" = "所属機関"),
    D0 %>% select(分担ID, 分担所属) %>% rename("ID" = "分担ID", "所属" = "分担所属")
    ) %>%
    unique

Res %>% group_by(ID) %>%
    summarize(N =n()) %>%
    filter(N > 1)

D0 %>% filter(分担ID == "50250262")


# 研究者組み合わせ関数
com <- function(x){
  c(x$代表ID, x$分担ID) %>%
    unique() %>%
    combn(2) %>%
    t %>%
    as.data.frame()
}

df$clean <- map(df$data, com)


# 一旦エクスポート
df %>% select(-data) %>% filter(年度 == 2018) %>% unnest(cols = clean) %>% 
    fwrite("kaken_network_2018.csv")
df %>% select(-data) %>% filter(年度 == 2019) %>% unnest(cols = clean) %>% 
    fwrite("kaken_network_2019.csv")



DF <- fread("kaken_network_2018.csv", stringsAsFactors = F) %>%
    bind_rows(
        fread("kaken_network_2019.csv", stringsAsFactors = F)
    )

graph <- DF %>% filter(区分名 == "大区分K") %>% 
    select(V1, V2, 研究種目, 区分名, 総配分額, 年度) %>%
    graph_from_data_frame(directed = FALSE)

graphjs(graph, vertex.size = 1, edge.width = 3, edge.color = "black", showLabels = T)
