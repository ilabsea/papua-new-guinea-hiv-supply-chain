$(function(){
  handleLoadOrderLinesTab();
});


function handleLoadOrderLinesTab(){
  $("#order_site_id").on('change', function(){
     loadOrderLinesTab();
  });

  $("#order_order_date").on('change', function(){
     loadOrderLinesTab();
  });

  $("#order_date_submittion").on('change', function(){
    loadOrderLinesTab();
  })
}


function loadOrderLinesTab(){
  var site_id = $("#order_site_id").val();
  var date   = $("#order_order_date").val();
  var order_id = $("#table-order-order-id").val();
  var url = $('#table-order-tab-order-id').val();

  if(!site_id || !date)
    return ;
  showLoading();
  $.ajax({
      url    : url,
      data   : {'site_id' : site_id, 'order_date': date, 'id' : order_id, pp: 'disable'},
      method : 'GET',
      success: function(response){
        $('#order_lines_tab').html(response);
      },
      complete: function(){
        hideLoading();
      }
  });
}
