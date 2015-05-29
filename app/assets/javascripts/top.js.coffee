$(document).on "click", ".fb-button", ->
  myApp.showPreloader 'Facebookに接続中...'

$(document).on "click", ".navbar .right", ->
  myApp.actions([{
    text: "自分の入力情報を編集"
    onClick: ->
      myApp.openPanel('left')
  },{
    text: "Facebookでシェア"
    onClick: ->
      window.open "https://www.facebook.com/sharer/sharer.php?u=http://ishalan.com"
  },{
    text: "Twitterでシェア"
    onClick: ->
      window.open "https://twitter.com/share?url=http://ishalan.com&text=友達の口コミで探せる、病院検索サービス【ISHALAN】"
  },{
    text: "キャンセル"
    color: "red"
  }])
