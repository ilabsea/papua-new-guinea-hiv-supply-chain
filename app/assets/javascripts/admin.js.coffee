handleLink = ->
  $as = $("a")
  i = 0

  while i < $as.length
    $a = $($as.get(i))
    attr = $a.attr("data-skip-loading")
    method = $a.attr("data-method")
    if attrNotSet(attr) and attrNotSet(method)
      $a.on "click", ->
        systemLoading().show()

    i++
attrNotSet = (attr) ->
  attr is `undefined` or attr is false or attr is ""
systemLoading = ->
  $ "#system_loading"
$ ->
  handleLink()
