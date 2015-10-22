
function handleSubmitShipment(){
  $("#shipment_save").on('click', function(){
      showLoading();

      $("#shipment_message").hide();
      var shipment_date = $("#shipment_shipment_date").val()
      var consignment_number = $("#shipment_consignment_number").val();
      var cost = $("#shipment_cost").val();

      var data = $("#new_shipment").serialize();

      $.ajax({
        type: 'POST',
        dataType: 'json',
        url : window.appConfig.url.createShipment,
        data: data,

        success: function(response){
           hideLoading();
           if(response["status"] == "failed"){
              $("#shipment_message").removeClass('alert-success').addClass('alert-error').html(response.message).show();
            }

           else{
              $("#shipment_message").removeClass('alert-error').addClass('alert-success').html(response.message).show();
              setTimeout(function(){
                  window.location.href = window.appConfig.url.shipmentList ;
              }, 500);
 
            }

        }


      });
      return false;

  });
}

$(function(){
 handleSubmitShipment();
})
