$(function(){
  showPopover();
  handleCreateShipment();
  // toggleCheckbox();
  checkUpdate();
});

function handleCreateShipment(){
  $("#create_shippement").on('click', function(){
    if(validShipmentLines()){
      $('#shippement_dialog').modal();
    }
  })
}

// Display all errors message
function validShipmentLines(){
  var $items = $(".cb_items:checked")

  if($items.length == 0){
    alert("Please select at least an item to check");
    return false;
  }

  var valid  = true
  for(var i  = 0; i< $items.length; i++){
    item     = $items.get(i); 
    $elm     = $(item);
    var id   = $elm.attr('data-id');
    var data = getData(id);
    if(!isDataValid(data)) {
      valid  = false;
      showError(data.order_line_id);
      highLightRowFailure(data.order_line_id);
    }

  }
  if(!valid){
    alert("Please fix the error before continueing")
  }
  return valid ;
}

function isDataValid(data){
  return $.isNumeric(data.quantity) && parseInt(data.quantity) > 0
}

function checkUpdateCb(){
  $(".cb_items").on('click', function($e){
    var $elm = $(this);
    var id   = $elm.attr("data-id");
    var data = getData(id);
    if(this.checked){
      if(isDataValid(data))
        addItem(data);
    }
    else
      removeItem(data);

    $e.stopPropagation();
  })
}

function checkUpdateContent(){
  $(".content").on('blur', function(){
    $elm = $(this);
    var id = $elm.attr("data-id");
    var data = getData(id);
    checked = $("#toggle_"+id).get(0).checked ;

    if(checked){
      addItem(data);
    }
  })
}

function checkUpdate(){
  checkUpdateCb();
  checkUpdateContent();
}

function getData(id){
  var quantity = $( "#quantity_" + id ).val() ;
  var remark   = $( "#ams_remark_" + id ).val() ;
  return { 'order_line_id' : id, 'quantity' : quantity, 'remark' : remark } ;
}

function highLightRowSuccess(id){
  $("#tr_" + id + " td " ).addClass("row-success").removeClass('row-error');
  $('#quantity_' + id).css({'color' : '#333' })
  $("#error_" + id).hide();

}

function highLightRowDelete(id){
  $("#tr_" + id + " td " ).removeClass("row-success").removeClass('row-error');
  $('#quantity_' + id).css({'color' : '#333' })

}

function highLightRowFailure(id){
  $("#tr_" + id + " td " ).addClass("row-error").removeClass('row-success');
  $('#quantity_' + id).css('color' , 'red' )
  $("#error_" + id).show();

}

function hideError(id){
  $("#error_" + id).hide();
}

function showError(id, msg){
  if(msg) 
    $("#error_" + id ).attr('data-content' , msg);
  $("#error_" + id ).show();
}

function removeItem(data){  
  var url = '/admin/shipments/remove_session';
  showLoading();
  hideError(data.order_line_id);

  $.ajax({
      url: url,
      type: 'DELETE',
      data: data,
      dataType: 'json',
      success: function(response){
        hideLoading();
        if(response.status == "success"){
          highLightRowDelete(data.order_line_id)
        }
        else{
          showError(data.order_line_id, response.error);
          highLightRowFailure(data.order_line_id)
        }
      }
  })
  return false;
}

function addItem(data){  
  var url = '/admin/shipments/add_session';
  showLoading();
  hideError(data.order_line_id);

  $.ajax({
      url: url,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function(response){
        hideLoading();
        if(response.status == "success"){
          highLightRowSuccess(data.order_line_id)
        }
        else{
          showError(data.order_line_id, response.error);
          highLightRowFailure(data.order_line_id)
        }
      }
  })
  return false;
}

function toggleCheckbox(){
  $("#cb_toggle_all").on('click', function(){
      makeToggleCheck();
      if(this.checked)
        addItems();
      else
        removeItems();
  })
}

function makeToggleCheck(){
  checked = $("#cb_toggle_all").get(0).checked;
  $cb_items =  $(".cb_items")

  for(var i=0; i< $cb_items.length; i++) {
    $cb_items.get(i).checked = checked;
  }
}


function showPopover(){
  $("[rel='popover']").popover(
    {trigger:'hover',animation:'false', placement:'top'}
  );

  $("[rel='popover']").mouseover(function () {
    $("[rel='popover']").not(this).popover('hide');
  });
}