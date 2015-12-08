$(function() {
  $('.parameter_link').click(function() {
    var $this = $(this);
    var $input = $('#' + $this.attr('data-id'));
    $input.replaceSelection($this.text());
    return false;
  });
});