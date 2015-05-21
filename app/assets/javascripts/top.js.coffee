$(document).on "click", ".fb-button", ->
  myApp.showPreloader 'Facebookに接続中...'

$(document).on "click", ".navbar .right", ->
  myApp.actions([{
    text: "自分の入力情報を編集"
    onClick: ->
      myApp.openPanel('left')
  },{
    text: "キャンセル"
    color: "red"
  }])
