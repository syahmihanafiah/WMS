	var grid_init = false; 
  
	$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });  
		 
		$("#lookupVendorBtn").click( function(){ openLookupVendor(); } ); 
		$('#lookupVendorWindow').on('close', function (event) { 
			document.getElementById('lookupVendorContent').src="about:blank";
			$('#lookupVendorProgress').show();    
		}); 
		$jqtips(document).ready(function() { 
			$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		});
        function openLookupVendor() {
		  
			var lookupStr = trim($("#vendor_name").val());
			var org_id = trim($("#org_id").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/vendor.cfm?prefix=Vendor&parentForm=searchForm&field1=vendor_id&field2=vendor_name&lookupStr='+lookupStr+'&org_id='+org_id;
			
			document.getElementById('lookupVendorContent').src=lookupFile; 
            $('#lookupVendorWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupVendorWindow').jqxWindow('open');  
        }
		
	 
		$("#lookupPartNumberBtn").click( function(){ openLookupPartNumber(); } ); 
		$('#lookupPartNumberWindow').on('close', function (event) { 
			document.getElementById('lookupPartNumberContent').src="about:blank";
			$('#lookupPartNumberProgress').show();    
		}); 
        function openLookupPartNumber() {
		  	
 			var org_option = trim($("#org_id").val());
			var lookupStr = trim($("#lookup_part_number").val());
			var ownership_id = trim($("#ownership_id").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/raw_part_number.cfm?prefix=PartNumber&parentForm=searchForm&&field1=part_number&field2=lookup_part_number&org_option='+org_option+'&lookupStr='+lookupStr + '&ownership_id=' +ownership_id;
			
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
		
		
		$("#lookupBackNumberBtn").click( function(){ openLookupBackNumber(); } ); 
		$('#lookupBackNumberWindow').on('close', function (event) { 
			document.getElementById('lookupBackNumberContent').src="about:blank";
			$('#lookupBackNumberProgress').show();    
		}); 
        function openLookupBackNumber() {
		  
			var lookupStr = trim($("#back_number").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/back_number.cfm?prefix=BackNumber&parentForm=searchForm&field1=back_number&lookupStr='+lookupStr;
			
			document.getElementById('lookupBackNumberContent').src=lookupFile; 
            $('#lookupBackNumberWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupBackNumberWindow').jqxWindow('open');  
        }
		 
		$("#addBtn").click(function(e) {
		
			if( $("#org_id").val() == ''){
				showTips('org_id','Please select an organization',3000);	
			}
			else if ($("#ownership_id").val() == ''){
				showTips('ownership_id','Please select an ownership',3000);
			}
			else if( trim($("#part_number").val()) == ''){
				showTips('lookup_part_number','Please select a part number',3000);	
			}
			else{
				 
				 
             	$.ajax({
					  type: 'POST',
					  url: 'bgprocess.cfm',
					  data: { action_flag: 'validatePartNo', org_id:$("#org_id").val(), part_number:trim($("#part_number").val()) }, 
					  success:function(data){    
						var resultArr = data.split("~~");
						if( resultArr[1] == 'success' ){ 
							
							var filePath = '../systems/general_master/master_data/part_list/';
							var fullPath = filePath + 'part_list_add.cfm?org_id='+$("#org_id").val()+'&part_number='+$("#part_number").val();
							window.parent.openNewTab($("#part_number").val(),fullPath,$("#fID").val()); 
				
						}
						else if( resultArr[1] == 'duplicate' ) {
							showTips('lookup_part_number','The part number is already registered and still active',2000);
							generateDataGrid();
						}
						else if( resultArr[1] == 'fail' ) {
							showTips('lookup_part_number','No available vendor for this part number',2000);
							generateDataGrid();
						}
					  },
					  error:function(){ 
						window.parent.notify("error","Add new part",'Error while processing your request',"3000"); 
					  }
				}); 
			 
			 
			}
        });
		  
		
	});
	 
	 
	function clearHiddenField(elID){
		$(document).ready(function(e) {
			$("#"+elID).val('');
        });	
	}
	function organization_onChange(org_id){
		$("#part_number").val('');
		$("#lookup_part_number").val('');
		$("#lookup_part_number").attr('readOnly',true);
		$("#lookup_part_number").addClass('formStyleReadOnly');
		$("#lookupPartNumberBtn").hide();
		$("#lookupPartNumberBtnDisabled").show();
		if( org_id != '' ){ 
			$("#lookup_part_number").attr('readOnly',false);
			$("#lookup_part_number").removeClass('formStyleReadOnly');
			$("#lookupPartNumberBtn").show();
			$("#lookupPartNumberBtnDisabled").hide();
		} 
	}
  
	function generateDataGrid(){
 		
        $(document).ready(function () {
 			$("#filterList").val('');
            var source =
            { 
                datatype: "json", 
                datafields: [     
					 { name: 'part_list_header_id', type: 'number' }, 
					 { name: 'part_number', type: 'string' },
					 { name: 'part_name', type: 'string'},
					 { name: 'vendor_id', type: 'number' },
					 { name: 'vendor_name', type: 'string'},
					 { name: 'back_number', type: 'string'},
					 { name: 'line_shop', type: 'string'},
					 { name: 'dock_code', type: 'string'},
					 { name: 'shop_name', type: 'string'},
					 { name: 'color', type: 'string'}, 
					 { name: 'ownership_name', type: 'string'}, 
					 { name: 'org_description', type: 'string'},
					 { name: 'status', type: 'string'},
					 { name: 'creation_date', type: 'date'}, 
					 { name: 'creation_by', type: 'string'},
					 { name: 'last_updated_date', type: 'date'}, 
					 { name: 'last_updated_by', type: 'string'}
                ],
				  
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					target:'grid', 
					action_flag:'load_data_grid',
					org_id:$("#org_id").val(), 
					part_number:trim($("#lookup_part_number").val()), 
					back_number:trim($("#back_number").val()),
					vendor_id:trim($("#vendor_id").val()),
					vendor_code:trim($("#vendor_code").val()),
					ownership: $("#ownership_id").val(),
					status:$("#status").val()
				},
                root: 'Rows',   
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
			
			var detailimagerenderer = function (row, datafield, value) {
				var detailicon = 			"<div align='center' style='padding:2px; vertical-align:middle;'>";
				detailicon = detailicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/list.png' >";
				detailicon = detailicon + 	"</div>";
				return detailicon;
			};
  
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
						var buttons = "<input class='button white' id='btnExport' value='Export to Excel' type='button' style='float: right;' onClick='exportToExcel();' />"; 
						var tools = $(buttons);
								
						toolbar.append(container);
						container.append(span);
						container.append(tools); 
					}
				},
				  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [   
					{ text: 'Part Number', datafield: 'part_number', width:150, align: 'center', cellsalign: 'center'},
					{ text: 'Part Name', datafield: 'part_name', width:200}, 	  
					{ text: 'Vendor Code', datafield: 'vendor_id', width:90, align: 'center', cellsalign: 'center'},
					{ text: 'Vendor Name', datafield: 'vendor_name', width:200}, 
					{ text: 'Back Number', datafield: 'back_number', width:100, align: 'center', cellsalign: 'center'}, 
					{ text: 'Shop', datafield: 'shop_name', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Line Shop', datafield: 'line_shop', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Dock Code', datafield: 'dock_code', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Color', datafield: 'color', width:100, align: 'center', cellsalign: 'center'}, 
					{ text: 'Ownership', datafield: 'ownership_name', width:100, align: 'center', cellsalign: 'center'}, 					
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
				
					$("#btnExport").click(function(){ 
						var filename = 'PartListMaster';
						var param = 'filename='+filename+'&org_id='+$("#org_id").val()+'&part_number='+$("#lookup_part_number").val()+'&back_number='+$("#back_number").val()+'&vendor_id='+$("#vendor_id").val()+'&vendor_code='+$("#vendor_code").val()+'&status='+$("#status").val();
						document.getElementById('downloadFrame').src='download_partmaster_data.cfm?'+param;
					});
			
					$("#datagrid").on('cellclick', function (event) { 
					
						var column = $("#datagrid").jqxGrid('getcolumn', event.args.datafield).text;
						if(column == 'Edit') { 
							var part_list_header_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'part_list_header_id');  
							var part_number = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'part_number');  
							var filePath = '../systems/general_master/master_data/part_list/';
						 	var fullPath = filePath + 'part_list_edit.cfm?part_list_header_id=' + part_list_header_id;
						 	window.parent.openNewTab(part_number,fullPath,$("#fID").val()); 
						}
					}); 	 
			}
		 
      });
	   
	  grid_init = true;
	 
	  
	} 
	
	 