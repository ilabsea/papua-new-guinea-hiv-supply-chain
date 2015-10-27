$(function(){
handleSubmitShipment();
})

function handleSubmitShipment(){
  $("#shipment_save").on('click', function(){
      var id = $(this).attr('data-id') ;
      var url = $(this).attr('data-url')
      showLoading();
      $("#shipment_message").hide();

      cost = $("#shipment_cost").val();

      data = { id : id, cost : cost };

      $.ajax({
        type: 'POST',
        dataType: 'json',
        url : url,
        data: data,

        success: function(response){
           hideLoading();
           if(response["status"] == "failed"){
              $("#shipment_message").removeClass('alert-success').addClass('alert-error').html(response.message).show();
            }

           else{
              $("#shipment_message").removeClass('alert-error').addClass('alert-success').html(response.message).show();
              window.location.reload() 
            }
        }
      });
      return false;
  });
}

