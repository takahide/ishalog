$(document).on "keyup", "input.station", ->
  str = $(@).val()
  if str.length >= 1
    $.ajax {
      type: "GET"
      url: "/stations/suggest?s=#{str}"
      success: (json) ->
        html = ""
        for s in json
          html += "<p class='suggest-option'>#{s.name}</p>"
        $(".suggest").html(html)
    }

$(document).on "blur", "input.station", ->
  setTimeout ->
    $(".suggest").html("")
  , 200


$(document).on "focus", "input.department", ->
  $(".suggest").html("")


$(document).on "click", ".suggest-option", ->
  $("input.station").val($(@).text())
  $(".suggest").html("")



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
