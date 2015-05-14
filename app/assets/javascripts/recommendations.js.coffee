$ ->
  $(".submit").on "click", ->
    department = $(".department").val()
    doctor = $(".doctor").val()
    location = $(".location").val()
    comment = $(".comment").val()

    if doctor is ""
      myApp.alert('病院名は必須です。', 'エラー')
      return
    if location is ""
      myApp.alert('最寄り駅は必須です。', 'エラー')
      return
    if comment is ""
      comment = "コメントなし"


    myApp.showPreloader '通信中...'
    $.ajax {
      type: "POST"
      url: "/recommend"
      data: {
        doctor: doctor
        location: location
        department: department
        comment: comment
        rating: 3
      }
      cache: false
      success: (html) ->
        myApp.hidePreloader()
        myApp.alert('ご協力ありがとうございました。', '送信完了', ->
          myApp.closeModal()
        )
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        myApp.hidePreloader()
        myApp.alert('申し訳ありません。しばらく経ってから、再度お試しください。', 'エラー')

    }
