@showLoading = (text) ->
  text = (if text then text else "Waiting for server response")
  $("#loading_text").html text
  $(".loading").show()
@hideLoading = ->
  $(".loading").hide()