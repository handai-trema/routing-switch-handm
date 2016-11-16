#Report: 経路選択アルゴリズムの実装と可視化
Submission: &nbsp; Nov./16/2016<br>
Branch: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; develop<br>


##目次
* [提出者](#submitter)
* [課題内容](#assignment)
* [別の経路選択アルゴリズムの適用: プリム法](#prim)
* [関連リンク](#links)



##<a name="submitter">提出者: H&Mグループ
###メンバー
<table>
  <tr>
    <td><B>氏名</B></td>
    <td><B>学籍番号</B></td>
    <td><B>所属研究室</B></td>
  </tr>
  <tr>
    <td>阿部修也</td>
    <td>33E16002</td>
    <td>松岡研究室</td>
  </tr>
  <tr>
    <td>信家悠司</td>
    <td>33E16017</td>
    <td>松岡研究室</td>
  </tr>
  <tr>
    <td>満越貴志</td>
    <td>33E16019</td>
    <td>長谷川研究室</td>
  </tr>
  <tr>
    <td>辻　健太</td>
    <td>33E16012</td>
    <td>長谷川研究室</td>
  </tr>
</table>




##<a name="assignment">課題内容
```
課題 (経路選択アルゴリズムの実装と可視化)

* ルーティングスイッチのダイクストラ法を、別の経路選択アルゴリズムに置き換える
* 選択した経路やアルゴリズムの動作をブラウザで見れるように可視化する
```





##<a name="prim">別の経路選択アルゴリズムの適用: プリム法
我々のグループではダイキストラ法の代わりにプリム法を採用した．<br>
なぜならば，プリム法は下記の通り，ダイクストラ法とは比べものにならないほど簡単に最短経路問題を解くことができるためである．<br>
```
Prim(graph, start, goal):
  1. ノード集合Vを空集合として初期化する．
  2. 連想配列pを初期化する．
  3. Vにstartを加える．
  4. Vがグラフのすべての頂点を含むまで、以下を繰り返す．
    4-1. ∀u∈Vと∀v∉Vを結ぶ辺(u,v)のコストが最小のvを選ぶ．
    4-2. vをVに加える．
    4-3. p[v] = u
  5. p[goal]からp[start]まで辿ったノード系列resultを得る．
  6. resultを反転させた系列がstartからgoalまでの最小経路なので，それを返す．
```
ここで，graphはグラフ，startは送信ノード，goalは受信ノードを示す．<br>





##<a name="program_prim">プリム法の実装
プリム法は
[lib/prim.rb](lib/prim.rb)
に実装した．<br>







##<a name="links">関連リンク
* [課題 (経路選択アルゴリズムの実装と可視化)](https://github.com/handai-trema/deck/blob/develop/week7/assignment_routing_switch.md)
* [lib/prim.rb](lib/prim.rb)
