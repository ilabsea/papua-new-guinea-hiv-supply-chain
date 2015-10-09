$(function() {
  tdToggle()
})

function tdToggle(){
  $(document.body).delegate('.td-expand','click', function(e){
    var $el = $(this)
    var title = $el.attr('title')
    var content = $el.html()

    $el.attr('title', content)
    $el.html(title)
    e.stopPropagation()
  })
}