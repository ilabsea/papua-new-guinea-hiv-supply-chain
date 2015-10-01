$(function(){
  detectTableChange()
  resetDataTouched()

  openDialog()
  pasteItems()
})

function openDialog(){
 $(".copy-open-dialog").on('click', function(){
   var $elm = $(this);
   $("#copy-to-site").html($elm.attr('data-content'));
   $("#site_to_paste").val($elm.attr('data-id'));
   $("#copy_source").val("");
   $('#copy_dialog').modal();
 }); 
}

function pasteContent(content){
  var lines  = $.trim(content).split("\n");
  var siteId   = $("#site_to_paste").val()

  var siteLists = $("#site-list").val().split(",")

  var indexOfSite = siteLists.indexOf(siteId);
  var commodityOffset = $("#commodity_offset").val();

  for(var i=0;i< lines.length; i++ ){
    line = lines[i];
    quantities = line.split("\t");
    currentSiteId =  siteLists[ (i+indexOfSite) ] ;

    $quantityElms = $(".quantity_" + currentSiteId );

    for(var c=commodityOffset; c< $quantityElms.length; c++){
      indexCommodityOffset = c -commodityOffset;
      $($quantityElms.get(c)).val(quantities[indexCommodityOffset]);
    }
  }
}

function pasteItems(){
  $(".quantity_item").on('change', function(){
    $elm = $(this);
    content = $elm.val();
    $("#site_to_paste").val($elm.attr('data-id'));
    $("#commodity_offset").val($elm.attr('data-offset') );

    if(content.indexOf("\n") != -1 || content.indexOf("\t") != -1 ) {
      pasteContent(content);
    }
    
  }).on('paste', function(){
    $elm = $(this);
    $("#site_to_paste").val($elm.attr('data-id'));
    $("#commodity_offset").val($elm.attr('data-offset') );
  })

  $("#btn-copy-to-site").on('click', function(){
    content = $("#copy_source").val();
    pasteContent(content);
    
  });
}

function detectTableChange(){
  $('#tableFixed .quantity_item').on('change', function() {
    window.onbeforeunload = function() {
      window.skipServerLoading = true
      return 'Are you sure you want to navigate away from this page?'
    }
  })
}

function resetDataTouched(){
  $(".btn").on('click', function(){
    window.onbeforeunload = null
  })
}

