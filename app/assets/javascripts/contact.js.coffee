$(document).on "click", ".contact-submit", ->
  name = $(".name").val()
  email = $(".email").val()
  message = $(".message").val()

  if name is ""
    myApp.alert('名前は必須です。', 'エラー')
    return
  if email is ""
    myApp.alert('メールアドレスは必須です。', 'エラー')
    return
  if message is ""
    myApp.alert('お問い合わせ内容は必須です。', 'エラー')
    return

  myApp.showPreloader '通信中...'
  $.ajax {
    type: "POST"
    url: "/contact"
    data: {
      name: name
      email: email
      message: message
    }
    cache: false
    success: (json) ->
      myApp.hidePreloader()
      myApp.alert 'ありがとうございました。', '送信完了', ->
        location.href = "http://ishalan.com"
    error: (XMLHttpRequest, textStatus, errorThrown) ->
      myApp.hidePreloader()
      myApp.alert('申し訳ありません。しばらく経ってから、再度お試しください。', 'エラー')
  }
