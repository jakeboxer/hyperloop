$(document).on "click", ".js-update-current-time", ->
  $(".js-current-time").html(new Date().toString())
  false
