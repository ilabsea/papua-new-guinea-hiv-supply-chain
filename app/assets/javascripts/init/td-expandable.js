$(function() {
  tdToggle()
})

function tdToggle(){
  $('.td-expand').on('click', function(e){
    console.log("click")
    var $el = $(this);
    var title = $el.attr('title');
    var content = $el.html();

    $el.attr('title', content);
    $el.html(title);
    e.stopPropagation()

  })
}