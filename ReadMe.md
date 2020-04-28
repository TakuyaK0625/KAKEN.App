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