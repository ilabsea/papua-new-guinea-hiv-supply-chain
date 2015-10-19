$(function(){
  handleButton()
})


 function handleButton(){
  $(".intercept").on('click', function(e){ 
    $elm = $(this);
    id = $elm.attr("data-ref");
    quantity_suggested = $("#quantity_suggested_" + id ).val();
    user_reviewer_note = $("#user_reviewer_note_" + id).val();
    data = { "order_line[quantity_suggested]" : quantity_suggested, "order_line[user_reviewer_note]" : user_reviewer_note  }
    url = $elm.attr("href")
    status_approved = '<i class="icon-ok" > </i>' ;
    status_rejected = '<i class="icon-minus-sign" > </i>' ;

    showLoading();

    $.ajax({
      url : url,
      type: 'PUT',
      data: data,
      dataType: 'json',
      success: function(response){
        if(response["code"] == "failed"){
          if(response["arv_type"] == "Drug"){
            $("#error-drug").html(response["error"]);
            $("#error-drug").show();
            $("#quantity_suggested_" + id ).css("color", "red");   
          }
          else{
            $("#error-kit").html(response["error"]);
            $("#error-kit").show();
            $("#quantity_suggested_" + id ).css("color", "red");
          }
        }

        else{
          if(response["type"] == "approved")
            $("#status_"+id).html(status_approved);
          else
            $("#status_"+id).html(status_rejected);

          if(response["arv_type"] == "Drug"){
            $("#error-drug").html();
            $("#error-drug").hide();
            $("#quantity_suggested_" + id ).css("color", "black");
          }
          else{
            $("#error-kit").html();
            $("#error-kit").hide();
            $("#quantity_suggested_" + id ).css("color", "black");
          }
        }
        hideLoading();
      }
    });
    return false;
  });
 }
