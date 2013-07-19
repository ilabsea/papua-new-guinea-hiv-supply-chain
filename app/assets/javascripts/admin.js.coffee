$ ->
  $("#system_loading").hide()
  $(window).unload ->
    $("#system_loading").show()
    false