$(function(){
	var oTable = $('#tableFixed').dataTable( {
			"bJQueryUI": true,
			"sScrollY": "450px",
			"sScrollX": "100%",
			"sScrollXInner": "150%",
			"bScrollCollapse": true,
			"bPaginate": false,
			"bFilter": false,
			"bInfo": false
	});

	try{
		new FixedColumns( oTable );
	}
	catch(ex){
		
	}

});