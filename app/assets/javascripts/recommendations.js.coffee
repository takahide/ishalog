$ ->
  $(document).on "click", ".my-recommendation", ->
    id = $(@).attr("id")
    department = $(@).attr("department")
    location = $(@).attr("location")
    comment = $(@).attr("comment")
    doctor = $(@).text()

    $(".location").val(location)
    $(".department").val(department)
    $(".comment").val(comment)
    $(".doctor").val(doctor)

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
      success: (json) ->
        myApp.hidePreloader()
        myApp.alert('ご協力ありがとうございました。', '送信完了', ->
          myApp.closeModal()
          $("ul.menu").append('<li id="' + json.id + '" class="open-popup border my-recommendation" department="' + json.department + '" location="' + json.location + '" comment="' + json.comment + '">' + json.doctor + '</li>')
        )
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        myApp.hidePreloader()
        myApp.alert('申し訳ありません。しばらく経ってから、再度お試しください。', 'エラー')

    }
