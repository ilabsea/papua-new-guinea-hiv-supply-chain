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
			//"oSearch": false
	} );	
	new FixedColumns( oTable );

});