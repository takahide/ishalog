$ ->
  $(".submit").on "click", ->
    doctor = $(".doctor").val()
    location = $(".location").val()
    rating = $(".rating").val()
    department = $(".department").val()
    comment = $(".comment").val()

    myApp.showPreloader '通信中...'
    $.ajax {
      url: "/recommend/#{doctor}/#{location}/#{rating}/#{department}/#{comment}"
      cache: false
      success: (html) ->
        myApp.hidePreloader()
        alert "ok"
    }
