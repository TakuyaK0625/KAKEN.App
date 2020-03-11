# KAKEN.App

以下では科研分析用アプリをローカルで実行する方法をざっくり説明します。
オンライン版はかなり遅いのですが、ローカルだと結構サクサク動いてくれます。

## いるもの
R（https://cran.r-project.org）<br>
Rstudio（https://rstudio.com）（あると便利）

## 使い方
細かいことはさておき、以下の通りにしたらローカルで実行できます（はず）。

0. 「global.R」の最初に列挙したパッケージを全てインストールする。

1. ダウンロードしてきた科研費データ（csv形式）を「raw_data」フォルダに入れる。

2. 同じフォルダ内の「kaken_clean.R」を開き、科研費データのファイル名を書き換える。

3. 同じフォルダ内のすべてのRファイルを実行（データの下処理）。

4. 「app.R」を開き、全選択して実行。Rstudioであれば「Run App」ボタンを押しても実行できます。

# URL
https://takuyak0625.shinyapps.io/KAKEN-App/
※使用時間の制限あり（active horus 25h/month）
