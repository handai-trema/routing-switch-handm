#Report: 経路選択アルゴリズムの実装と可視化
Submission: &nbsp; Nov./16/2016<br>
Branch: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; develop<br>


##目次
* [提出者](#submitter)
* [課題内容](#assignment)
* [別の経路選択アルゴリズム: プリム法](#prim)
* [プリム法の実装](#program_prim)
* [プリム法の結果](#result_prim)
* [ブラウザでの可視化における変更点](#browser)
* [本課題の可視化](thisalg#)
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

・ルーティングスイッチのダイクストラ法を、別の経路選択アルゴリズムに置き換える
・選択した経路やアルゴリズムの動作をブラウザで見れるように可視化する
```





##<a name="prim">別の経路選択アルゴリズム: プリム法
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
ここで，`graph`はグラフ，`start`は送信ノード，`goal`は受信ノードを示す．<br>





##<a name="program_prim">プリム法の実装
プリム法は
[lib/prim.rb](lib/prim.rb)
において`Prim`クラスとして実装した．<br>
ここで，実際のコード（`Prim.run`メソッド）を下に示し，
コメントアウトとして若干の説明を付す．<br>
```
def run(start, goal)
  start_node = find(start, @all)              #スタートノードstartを取得する．
  @undecided_nodes.delete(start_node.name)    #最短経路を成さないノード集合undecided_nodesからstartを削除する．
  @decided_nodes.append(start_node.name)      #最短経路を成すノード集合decided_nodesへstartを追加する．
  #最小全域木を求める．
  while 0 < @undecided_nodes.length do              #最短経路を成さないノード集合undecided_nodesがなくなるまでループ．
    #decided_nodesに含む任意のノードと辺を成すdecided_nodesに含まれる任意の点を探す．
    neighbor = nil                                  #decided_nodesに含む任意のノードと辺を成すdecided_nodesに含まれる任意の点
    break_switch = false                            #for focused_node_name in @decided_nodes doから抜け出すスイッチ
    for focused_node_name in @decided_nodes do      #decided_nodesに含むノードに対してループ．
      focused_node = find(focused_node_name, @all)  #decided_nodesに含む任意のノードfocused_nodeを取得
      focused_node.neighbors.each do |each|         #focused_nodeと辺を成すノードに対してループ．
        neighbor = find(each, @all)                 #focused_nodeと辺を成すノードneighborを取得する．
        ＃decided_nodesに含む任意のノードと辺を成すdecided_nodesに含まれる任意の点かどうかを判別する．
        if neighbor != nil  and  @undecided_nodes.include?(neighbor.name) == true  then   #
          neighbor.set_prev(focused_node)           #neighborをdecided_nodesへ追加する際のfocused_nodeを記録する．
          break_switch = true
          break
        end
      end
     if break_switch == true then
       break
     end
    end
    @undecided_nodes.delete(neighbor.name)  #neighborをundecided_nodesから削除する．
    @decided_nodes.append(neighbor.name)    #neighborをdecided_nodesへ追加する．
  end
  #ここからはDijkstraクラスと同じ．
  #上で求めた最小全域木からstartからgoalへの最短経路を求める．
  result = path_to(goal)                #記録したneighborをdecided_nodesへ追加する際のfocused_nodeをgoalからstartまで辿り，反転させたものを結果resultとして得る．
  result.include?(start) ? result : []  #resultにstartが含まれていれば，resultは連結グラフ内の系列であるのでresultを返し，そうでなければ空の系列を返す．
end
```
そして，
[lib/dijkstra.rb](lib/dijkstra.rb)
の`Dijkstra`クラスは
[lib/graph.rb](lib/graph.rb)
の`Graph.dijkstra`メソッドでのみ呼び出されるため，
同メソッド内にて下記の通りに`Prim.run`メソッドを呼び出すことによって，
グラフ`@graph`に対する送信ノードから受信ノードまでの最短経路`route`を求めるように変更した．<br>
ここで，`source_mac`は送信ノードのMACアドレスを，`destination_mac`は送信ノードのMACアドレスである．<br>
```
#route = Dijkstra.new(@graph).run(source_mac, destination_mac)
route = Prim.new(@graph).run(source_mac, destination_mac)
```





##<a name="result_prim">プリム法の結果
[trema.conf](trema.conf)
に対して，`host1`から`host4`までの最短経路をプリム法によって求めた．<br>
まず，下記のコマンドによって，`host4`から任意のホストへパケットを上げることで，コントローラがhost4のMACアドレスを把握する．<br>
```
./bin/trema send_packets --host host4 --source host2
```
次に，下記のコマンドによって，`host1`から`host4`までの最短経路を得る．<br>
```
./bin/trema send_packets --host host1 --source host4
```
このとき得た最短経路は下記の通りである．<br>
```
Creating path: 11:11:11:11:11:11 -> 0x1:1 -> 0x1:4 -> 0x5:2 -> 0x5:5 -> 0x6:2 -> 0x6:1 -> 44:44:44:44:44:44
```






##<a name="browser">ブラウザでの可視化における変更点

### Javascriptファイル生成プログラムの変更点

### 生成プログラム呼び出し側プログラムの変更点

##<a name="thisarg">本課題の可視化

### 各アルゴリズムから導かれる経路

### ダイクストラ法の可視化

### プリム法を用いた経路選択方法の可視化

### ノードが変更されたときの応答







##<a name="links">関連リンク
* [課題 (経路選択アルゴリズムの実装と可視化)](https://github.com/handai-trema/deck/blob/develop/week7/assignment_routing_switch.md)
* [lib/prim.rb](lib/prim.rb)
* [lib/dijkstra.rb](lib/dijkstra.rb)
* [lib/graph.rb](lib/graph.rb)
* [trema.conf](trema.conf)
