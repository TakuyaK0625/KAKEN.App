# ------------------------
# パッケージの読み込み
# ------------------------

library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(data.table)
library(igraph)
library(threejs)
library(data.table)

# データインポート
d <- fread("../99_cleaned_data/cleaned_df.csv", colClasses = list(character = "代表ID"))


# --------------------------
# 共同研究者列の展開と整理
# --------------------------

# 研究分担者を含む行のみを抽出
D1 <- d[研究分担者 != "", ]

# 研究分担者列の整理
D1[, 分担者 := str_split(研究分担者, "\n")] 

# 研究分担者列の展開
D1 <- as.data.table(unnest(D1, 分担者))

# 研究分担者を整理
D1[, 分担ID := str_extract(分担者, "\\d{8}")]
D1[, 分担所属 := str_extract(分担者, "^.+?(?=,)")]
D1[, 分担所属 := str_replace(分担所属, "(^.+ )(.+$)", "\\2")]
D1[, 分担所属 := str_replace(分担所属, "^国立研究開発法人", "")]
D1[, 分担所属 := str_replace(分担所属, "^公益財団法人", "")]
D1[, 分担所属 := str_replace(分担所属, "^大学共同利用機関法人", "")]
D1[, 分担所属 := str_replace(分担所属, "^独立行政法人", "")]
D1[, 分担所属 := str_replace(分担所属, "^地方独立行政法人", "")]
D1[, 分担所属 := str_replace(分担所属, "^一般財団法人", "")]
D1[, 分担所属 := str_replace(分担所属, "株式会社", "")]
D1[, 分担所属 := str_replace(分担所属, "大学$", "")]
D1[, 分担所属 := str_trim(分担所属, side = "both")]

D1 <- D1[ , .(研究課題番号, 研究種目, 総配分額, 年度, 区分, 区分名, 代表ID, 分担ID, 所属機関, 分担所属)]


# ------------------------------------
#  研究課題ごとに研究者を組み合わせる
# ------------------------------------

# 関数作成
com <- function(x){
    c(x$代表ID, x$分担ID) %>%
        unique() %>%
        combn(2) %>%
        t %>%
        as.data.table()
}


# 関数の適用
D2 <- D1[, .(data = list(com(.SD)))
  , by = .(年度, 研究課題番号, 研究種目, 区分名)
  ]

D2 <- as.data.table(unnest(D2, data))
D2 <- D2[, .(V1, V2, 研究課題番号, 研究種目, 年度, 区分名)]

# csvで書き出し（utf-8）
fwrite(D2, "../04_network/network.csv")


# --------------------------
#  研究者リスト 
# --------------------------

Res.list <- rbind(
    D1[, .(年度, ID = 代表ID, 所属 = 所属機関)],
    D1[, .(年度, ID = 分担ID, 所属 = 分担所属)]) %>% unique

Res.list %>% fwrite("../04_network/researcher.csv")

