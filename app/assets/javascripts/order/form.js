$(function(){
  handleLoadOrderLinesTab()
  handleToggleEmptyOrderLineRow()
})


function handleToggleEmptyOrderLineRow(){
  $(document.body).delegate('.toggle-empty_order-line','click', function(){
    toggleEmptyOrderLineRow()
  })
}

function toggleEmptyOrderLineRow() {
  var $rows = $(".table-order-line-form tbody tr")
  var count = 0

  $rows.each(function(index, row){
    var $row = $(row)
    var $stockOnHand = $row.find('.stock_on_hand')
    var $monthlyUse  = $row.find('.monthly_use')

    var stockOnHand = ''
    var monthlyUse = ''

    if($stockOnHand.get(0).tagName.toLowerCase() == 'td') {
      stockOnHand = $.trim($stockOnHand.text())
      monthlyUse  = $.trim($monthlyUse.text())
    }
    else {
      stockOnHand = $.trim($stockOnHand.val())
      monthlyUse  = $.trim($monthlyUse.val())
    }

    if(stockOnHand == "" && monthlyUse == ""){
      $row.css('background', "#F4F4F4")
      $row.toggle(1000)
    }
  })
}

function handleLoadOrderLinesTab(){
  $("#order_site_id").on('change', function(){
     loadOrderLinesTab();
  });

  $("#order_order_date").on('change', function(){
     loadOrderLinesTab();
  });

  // $("#order_date_submittion").on('change', function(){
  //   loadOrderLinesTab();
  // })
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
