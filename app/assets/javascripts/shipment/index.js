$(function(){
  handleToggleStatus();
  handleStatusChange();
});

function handleToggleStatus(){
  $("#status_toggle").on('click', function(){
     var chbox = this
     var $chboxes =  $("input[name='status_shipment_id[]']");
     for(var i=0; i< $chboxes.length; i++){
        $chboxes.get(i).checked = chbox.checked;
     }
  })
}

function handleStatusChange(){
  $("#mark_status_id").on('change', function(){
    var checkbox = this
    var $elm = $(checkbox);
    var status = $elm.val();
    if(status){
      $chboxes =  $("input[name='status_shipment_id[]']");
      for(var i=0; i< $chboxes.length; i++){
        if($chboxes.get(i).checked) {
          checkbox.form.submit();
          return true;
        }
      }
    }
  });
}



