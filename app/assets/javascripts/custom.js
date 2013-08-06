
function linkSystemLoading () {
  var $as = $("a");
  for (var i=0; i < $as.length; i++) {
    $a = $($as.get(i));
    attachEventForLoading($a);
  }
};

function elementDataSystemLoading() {
    $items = $("button[data-system-loading='true']");
    for(var i=0; i<$items.length; i++){
        $elm = $($items.get(i));
        systemLoadingClick($elm);
    }
}

function attachSystemLoading(){
    linkSystemLoading();
    elementDataSystemLoading();
}

function attachEventForLoading($elm){
    if(isNotIgnoreLoading($elm)) {
       systemLoadingClick($elm);
    }
}

function systemLoadingClick($elm){
  $elm.on("click", function() {
    return systemLoading().show();
  });
}

function isNotIgnoreLoading($elm){
    attr = $elm.attr("data-skip-loading");
    method = $elm.attr("data-method");
    if(attrNotSet(attr) && attrNotSet(method)) 
      return true
    return false
}

function attrNotSet(attr) {
  return attr == undefined || attr == false || attr == "";
};

function systemLoading() {
  return $("#system_loading");
};

$(function() {
  systemLoading().hide();
  attachSystemLoading();
});