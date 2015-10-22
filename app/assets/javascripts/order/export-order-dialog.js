$(function(){
  handleSubmitExportOrder()
})

function handleSubmitExportOrder(){
  $("#export-order-send").on('click', function(){
    $("#export-order-message").hide()

    var $dialog = $("#export-order-dialog")
    var month = $dialog.find("#month").val()
    var year = $dialog.find("#year").val()
    if(!month){
      $("#export-order-message").html("Please Select Month").show()
      return
    }
    if(!year) {
      $("#export-order-message").html("Please Select Year").show()
      return
    }
  
    $("#export-order-form").submit()
    return false;
  });
}
