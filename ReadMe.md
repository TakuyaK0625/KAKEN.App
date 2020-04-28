# KAKEN.App

以下では科研分析用アプリをローカルで実行する方法をざっくり説明します。  
オンライン版はかなり遅いのですが、ローカルだと結構サクサク動いてくれます。

## いるもの
R（https://cran.r-project.org)  
Rstudio（https://rstudio.com）  
（※Rstudioはなくてもいいけどあると便利）

## 使い方
細かいことはさておき、以下の通りにしたらローカルで実行できます。

0. 「global.R」の最初に列挙したパッケージを全てインストールする。

1. ダウンロードしてきた科研費データ（csv形式）を「raw_data」フォルダに入れる。

2. 同じフォルダ内の「kaken_clean.R」を開き、科研費データのファイル名を書き換える。

3. 同じフォルダ内のすべてのRファイルを実行（データの下処理）。

4. 「app.R」を開き、全選択して実行。Rstudioであれば「Run App」ボタンを押しても実行できます。

※データのアップデートが必要なければ０、４だけでも動きます。


## Web版URL
https://takuyak0625.shinyapps.io/KAKEN-App/  
※サーバーの使用時間に制限があるため、長居は厳禁

## 私の動作環境
\## ─ Session info ─
\##  setting  value                       
\##  version  R version 3.6.2 (2019-12-12)
\##  os       macOS Catalina 10.15.3      
\##  system   x86_64, darwin15.6.0        
\##  ui       X11                         
\##  language (EN)                        
\##  collate  ja_JP.UTF-8                 
\##  ctype    ja_JP.UTF-8                 
\##  tz       Asia/Tokyo                  
\##  date     2020-04-28                  
\## 
\## ─ Packages ─
\##  package        * version date       lib source        
\##  assertthat       0.2.1   2019-03-21 [1] CRAN (R 3.6.0)  
\##  base64enc        0.1-3   2015-07-28 [1] CRAN (R 3.6.0)  
\##  cli              2.0.1   2020-01-08 [1] CRAN (R 3.6.0)  
\##  colorspace       1.4-1   2019-03-18 [1] CRAN (R 3.6.0)  
\##  crayon           1.3.4   2017-09-16 [1] CRAN (R 3.6.0)  
\##  crosstalk        1.0.0   2016-12-21 [1] CRAN (R 3.6.0)  
\##  data.table     * 1.12.8  2019-12-09 [1] CRAN (R 3.6.0)  
\##  digest           0.6.23  2019-11-23 [1] CRAN (R 3.6.0)  
\##  dplyr          * 0.8.4   2020-01-31 [1] CRAN (R 3.6.0)  
\##  DT             * 0.12    2020-02-05 [1] CRAN (R 3.6.0)
\##  evaluate         0.14    2019-05-28 [1] CRAN (R 3.6.0)
\##  fansi            0.4.1   2020-01-08 [1] CRAN (R 3.6.0)
\##  fastmap          1.0.1   2019-10-08 [1] CRAN (R 3.6.0)
\##  fmsb           * 0.7.0   2019-12-15 [1] CRAN (R 3.6.0)
\##  ggplot2        * 3.2.1   2019-08-10 [1] CRAN (R 3.6.0)
\##  glue             1.3.1   2019-03-12 [1] CRAN (R 3.6.0)
\##  gtable           0.3.0   2019-03-25 [1] CRAN (R 3.6.0)
\##  htmltools        0.4.0   2019-10-04 [1] CRAN (R 3.6.0)
\##  htmlwidgets      1.5.1   2019-10-08 [1] CRAN (R 3.6.0)
\##  httpuv           1.5.2   2019-09-11 [1] CRAN (R 3.6.0)
\##  httr             1.4.1   2019-08-05 [1] CRAN (R 3.6.0)
\##  igraph         * 1.2.4.2 2019-11-27 [1] CRAN (R 3.6.0)
\##  jsonlite         1.6.1   2020-02-02 [1] CRAN (R 3.6.0)
\##  knitr            1.28    2020-02-06 [1] CRAN (R 3.6.0)
\##  later            1.0.0   2019-10-04 [1] CRAN (R 3.6.0)
\##  lazyeval         0.2.2   2019-03-15 [1] CRAN (R 3.6.0)
\##  lifecycle        0.1.0   2019-08-01 [1] CRAN (R 3.6.0)
\##  magrittr         1.5     2014-11-22 [1] CRAN (R 3.6.0)
\##  mime             0.9     2020-02-04 [1] CRAN (R 3.6.0)
\##  munsell          0.5.0   2018-06-12 [1] CRAN (R 3.6.0)
\##  pillar           1.4.3   2019-12-20 [1] CRAN (R 3.6.0)
\##  pkgconfig        2.0.3   2019-09-22 [1] CRAN (R 3.6.0)
\##  plotly         * 4.9.2   2020-02-12 [1] CRAN (R 3.6.0)
\##  promises         1.1.0   2019-10-04 [1] CRAN (R 3.6.0)
\##  purrr          * 0.3.3   2019-10-18 [1] CRAN (R 3.6.0)
\##  R6               2.4.1   2019-11-12 [1] CRAN (R 3.6.0)
\##  Rcpp             1.0.3   2019-11-08 [1] CRAN (R 3.6.0)
\##  rlang            0.4.4   2020-01-28 [1] CRAN (R 3.6.0)
\##  rmarkdown        2.1     2020-01-20 [1] CRAN (R 3.6.0)
\##  scales           1.1.0   2019-11-18 [1] CRAN (R 3.6.0)
\##  sessioninfo    * 1.1.1   2018-11-05 [1] CRAN (R 3.6.0)
\##  shiny          * 1.4.0   2019-10-10 [1] CRAN (R 3.6.0)
\##  shinydashboard * 0.7.1   2018-10-17 [1] CRAN (R 3.6.0
\##  shinyTree      * 0.2.7   2019-05-27 [1] CRAN (R 3.6.0)
\##  stringi          1.4.5   2020-01-11 [1] CRAN (R 3.6.0)
\##  stringr        * 1.4.0   2019-02-10 [1] CRAN (R 3.6.0)
\##  threejs        * 0.3.3   2020-01-21 [1] CRAN (R 3.6.0)
\##  tibble           2.1.3   2019-06-06 [1] CRAN (R 3.6.0)
\##  tidyr          * 1.0.2   2020-01-24 [1] CRAN (R 3.6.0)
\##  tidyselect       1.0.0   2020-01-27 [1] CRAN (R 3.6.0)
\##  vctrs            0.2.2   2020-01-24 [1] CRAN (R 3.6.0)
\##  viridisLite      0.3.0   2018-02-01 [1] CRAN (R 3.6.0)
\##  withr            2.1.2   2018-03-15 [1] CRAN (R 3.6.0)
\##  wordcloud2     * 0.2.1   2018-01-03 [1] CRAN (R 3.6.0)
\##  xfun             0.12    2020-01-13 [1] CRAN (R 3.6.0)
\##  xtable           1.8-4   2019-04-21 [1] CRAN (R 3.6.0)
\##  yaml             2.2.1   2020-02-01 [1] CRAN (R 3.6.0)
\## 
\## [1] /Library/Frameworks/R.framework/Versions/3.6/Resources/library
