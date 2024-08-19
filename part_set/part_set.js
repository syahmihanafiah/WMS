	var grid_init = false; 
  
	$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });  
		 
		$("#lookupMotherVendorBtn").click( function(){ openLookupMotherVendor(); } ); 
		$('#lookupMotherVendorWindow').on('close', function (event) { 
			document.getElementById('lookupMotherVendorContent').src="about:blank";
			$('#lookupMotherVendorProgress').show();    
		}); 
        function openLookupMotherVendor() {
		  
			var lookupStr = trim($("#mother_vendor_name").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/vendor.cfm?prefix=MotherVendor&parentForm=searchForm&field1=mother_vendor_id&field2=mother_vendor_name&lookupStr='+lookupStr;
			
			document.getElementById('lookupMotherVendorContent').src=lookupFile; 
            $('#lookupMotherVendorWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupMotherVendorWindow').jqxWindow('open');  
        }
		
		 
	 	$("#lookupMotherPartNumberBtn").click( function(){ 
		if($("#org_id").val() == ""){
				showTips("org_id", "Please select an organization", 3000);
			}
			else {  
				openLookupMotherPartNumber();  clear_tooltips(); 
			}
		} ); 
		$('#lookupMotherPartNumberWindow').on('close', function (event) { 
			document.getElementById('lookupMotherPartNumberContent').src="about:blank";
			$('#lookupMotherPartNumberProgress').show();    
		}); 
        function openLookupMotherPartNumber() {
		  
			var lookupStr = trim($("#mother_part_number").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/part_number.cfm?prefix=MotherPartNumber&parentForm=searchForm&field2=mother_part_number&lookupStr='+lookupStr+'&org_id='+$("#org_id").val();
			
			document.getElementById('lookupMotherPartNumberContent').src=lookupFile; 
            $('#lookupMotherPartNumberWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupMotherPartNumberWindow').jqxWindow('open');  
        }
		
		
		$("#lookupPartNumberBtn").click( function(){ 
			if($("#org_id").val() == ""){
				showTips("org_id", "Please select an organization", 3000);
			}
			else {  
				openLookupPartNumber(); 
			}
		} ); 
		$('#lookupPartNumberWindow').on('close', function (event) { 
			document.getElementById('lookupPartNumberContent').src="about:blank";
			$('#lookupPartNumberProgress').show();    
		}); 
        function openLookupPartNumber() {
		  
			var lookupStr = trim($("#part_number").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/part_number.cfm?prefix=PartNumber&parentForm=searchForm&field2=part_number&lookupStr='+lookupStr+'&org_id='+$("#org_id").val();
			
			document.getElementById('lookupPartNumberContent').src=lookupFile; 
            $('#lookupPartNumberWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupPartNumberWindow').jqxWindow('open');  
        }
		
		
		
		$("#lookupMotherBackNumberBtn").click( function(){ 
			if($("#org_id").val() == ""){
				showTips("org_id", "Please select an organization", 3000);
			}
			else {  
				openLookupMotherBackNumber(); 
			}
		} ); 
		$('#lookupMotherBackNumberWindow').on('close', function (event) { 
			document.getElementById('lookupMotherBackNumberContent').src="about:blank";
			$('#lookupMotherBackNumberProgress').show();    
		}); 
        function openLookupMotherBackNumber() {
		  
			var lookupStr = trim($("#mother_back_number").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/back_number.cfm?prefix=MotherBackNumber&parentForm=searchForm&field1=mother_back_number&lookupStr='+lookupStr+'&org_id='+$("#org_id").val();
			
			document.getElementById('lookupMotherBackNumberContent').src=lookupFile; 
            $('#lookupMotherBackNumberWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupMotherBackNumberWindow').jqxWindow('open');  
        }
		
		  
		
	});
	
	function clearNeccessaryHiddenFields(fieldID,hiddenID){
 
		if(trim($("#"+fieldID).val())==''){
			$("#"+hiddenID).val(''); 
		} 
	}
		
  
	function generateDataGrid(){
 		
        $(document).ready(function () {
 
            var source =
            { 
                datatype: "json", 
                datafields: [       
					 { name: 'org_id', type: 'number' },  
					 { name: 'vendor_id', type: 'number' }, 
					 { name: 'mother_part_number', type: 'string' },  
					 { name: 'child_part_number_list', type: 'string' },
					 { name: 'part_name', type: 'string' },  
					 { name: 'back_number', type: 'string' }, 
					 { name: 'vendor_name', type: 'string' }, 
					 { name: 'ownership_name', type: 'string' }, 
					 { name: 'org_description', type: 'string' },
					 { name: 'status', type: 'string' },
					 { name: 'creation_date', type: 'date'}, 
					 { name: 'creation_by', type: 'string'}, 
					 { name: 'last_updated_date', type: 'date'}, 
					 { name: 'last_updated_by', type: 'string'} 
                ],
				  
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					action_flag:'load_data_grid',
					org_id:$("#org_id").val(),  
					mother_part_number:trim($("#mother_part_number").val()), 
					mother_back_number:trim($("#mother_back_number").val()),
					mother_vendor_id:trim($("#mother_vendor_id").val()), 
					mother_vendor_code:trim($("#mother_vendor_code").val()), 
					part_number:trim($("#part_number").val()),   
					ownership_id: $("#ownership_id").val(),   
					status:trim($("#status").val())
				},
                root: 'Rows',  
                sortcolumn: 'mother_part_number',
                sortdirection: 'asc',
				beforeprocessing: function (data) {     
                    source.totalrecords = data[0].TotalRows; 
                }, 
                sort: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'sort');
                }, 
                filter: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'filter');
                }
				
            }; 
		    
            var dataadapter = new $.jqx.dataAdapter(source); 
 
  			var editimagerenderer = function (row, datafield, value) {
				var editicon = 			"<div align='center' style='padding:2px; vertical-align:middle;'>";
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil.png' >";
				editicon = editicon + 	"</div>";
				return editicon;
			};
			
            $("#datagrid").jqxGrid(
            {
                width: '100%',
                source: dataadapter,  
				autoheight: true,	 
				columnsresize: true,
                pageable: true,
				selectionmode: 'singlerows',
                virtualmode: true,
				sortable: true, 
				sorttogglestates: 1,
                filterable: true, 
				altrows: true, 
                enablebrowserselection: true,
				 
				showtoolbar: true, 
				rendertoolbar: function (toolbar) {  
					if ($('#toolbardiv').length == 0) {	 
						var container = $("<div id='toolbardiv' style='margin: 5px;'></div>");
						var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px; font-size:11px; font-weight:bold;'>Part List</span>");   
						toolbar.append(container);
						container.append(span);   
					}
				},
				  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [   
					{ text: 'Mother Part Number', datafield: 'mother_part_number', width:150, align: 'center', cellsalign: 'center'},
					{ text: 'Child Part Number', datafield: 'child_part_number_list', width:250, align: 'center', cellsalign: 'center'},
					{ text: 'Part Name', datafield: 'part_name', width:200}, 
					{ text: 'Vendor Code', datafield: 'vendor_id', width:90, align: 'center', cellsalign: 'center'},	   
					{ text: 'Vendor Name', datafield: 'vendor_name', width:200}, 
					{ text: 'Back Number', datafield: 'back_number', width:100, align: 'center', cellsalign: 'center'},  
					{ text: 'Ownership', datafield: 'ownership_name', width:200}, 					
					{ text: 'Organization', datafield: 'org_description', width:200}, 
					{ text: 'Status', datafield: 'status', width:80, align: 'center', cellsalign: 'center'}, 
					{ text: 'Created Date', datafield: 'creation_date', cellsformat: 'dd/MM/yyyy hh:mm:ss tt', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Created By', datafield: 'creation_by', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Last Update Date', datafield: 'last_updated_date', cellsformat: 'dd/MM/yyyy hh:mm:ss tt', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Last Update By', datafield: 'last_updated_by', width:150, align: 'center', cellsalign: 'center' },
					 
					{ text: 'Edit', datafield: 'edit', width: 60, cellsrenderer: editimagerenderer, pinned: true, align: 'center', sortable: false, filterable: false, exportable: false}
                 ] 
				  
				 
            }); 
			 
	  		if(grid_init == false ){
			
					$("#datagrid").on('cellclick', function (event) { 
						var column = $("#datagrid").jqxGrid('getcolumn', event.args.datafield).text;
						if(column == 'Edit') {   
							var org_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'org_id'); 
							var mother_part_number = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'mother_part_number'); 
							window.location.href='part_set_edit.cfm?org_id='+org_id+'&mother_part_number=' + mother_part_number;   
						}
					}); 	 
			}
		 
      });
	   
	  grid_init = true;
	  
	} 