$ ->
  $(document).on "click", ".my-recommendation", ->

    $(".submit").text("編集を保存")
    $(".delete").css("display", "block")

    id = $(@).attr("id")
    department = $(@).attr("department")
    location = $(@).attr("location")
    comment = $(@).attr("comment")
    doctor = $(@).text()

    $(".rec-id").val(id)
    $(".location").val(location)
    $(".department").val(department)
    $(".comment").val(comment)
    $(".doctor").val(doctor)

  $(document).on "click", ".new-recommendation", ->

    $(".submit").text("送信")
    $(".delete").css("display", "none")

    $(".rec-id").val("new")
    $(".location").val("")
    $(".department").val("1")
    $(".comment").val("")
    $(".doctor").val("")

  $(document).on "click", ".submit", ->
    id = $(".rec-id").val()
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
        id: id
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
          $("ul.menu li#" + json.id).css("display", "none")
          $("ul.menu").prepend('<li id="' + json.id + '" class="open-popup border my-recommendation" department="' + json.department + '" location="' + json.location + '" comment="' + json.comment + '">' + json.doctor + '</li>')
        )
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        myApp.hidePreloader()
        myApp.alert('申し訳ありません。しばらく経ってから、再度お試しください。', 'エラー')
    }

  $(document).on "click", ".delete", ->
    id = $(".rec-id").val()
    department = 0
    doctor = $(".doctor").val()
    location = $(".location").val()
    comment = $(".comment").val()

    myApp.showPreloader '通信中...'
    $.ajax {
      type: "POST"
      url: "/recommend"
      data: {
        id: id
        doctor: doctor
        location: location
        department: department
        comment: comment
        rating: 3
      }
      cache: false
      success: (json) ->
        myApp.hidePreloader()
        myApp.alert('削除しました。', '削除完了', ->
          myApp.closeModal()
          $("ul.menu li#" + json.id).css("display", "none")
        )
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        myApp.hidePreloader()
        myApp.alert('申し訳ありません。しばらく経ってから、再度お試しください。', 'エラー')
    }
