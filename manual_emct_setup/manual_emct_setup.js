var grid_init = false; 

$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });
				
				$("#searchBtn").click(function(){
					
					if( $("#org_id").val() == '' ){
						showTips("org_id", "Please select an organization", 1000);
					}
					else {
					$("#datagrid").jqxGrid("clearfilters");
					getData();
					}
				});
								
				$("#addBtn").click(function(){
	 				  if($("#org_id").val()==''){
						  showTips('org_id','Please select an organization',1000);	
					  }
					  else if($("#category").val()==''){
						  showTips('category','Please select category',1000);	
					  }
					  else if($("#ownership_id").val() == ''){
						   showTips('ownership_id','Please select ownership',1000);
					  }					  
					  else {
						  var filePath = '../systems/general_master/master_data/manual_emct_setup/';
						  
						  var fullPath = filePath + 'manual_emct_setup_add.cfm?org_id='+$("#org_id").val()
						  +'&category='+$("#category").val()+'&type=add' + '&ownership_id=' + $("#ownership_id").val();
						  
						  window.parent.openNewTab('Manual EMCT Setup',fullPath,$("#fID").val());
					  }
 				});
				
				$("#reset").click(function() {	 
					window.location.href=self.location
				});			
				$jqtips(document).ready(function() { 
					$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });   
});
		   
	}); 
		
	

function getData(){

	 	$(document).ready(function () {
			
            var source =
            { 
               
                datatype: "json", 
                datafields: [
					 { name: 'setup_id', type: 'integer' },
					 { name: 'org_id', type: 'integer' },
					 { name: 'org_description', type: 'string' },
					 { name: 'ownership_name', type: 'string' },
					 { name: 'ownership_id', type: 'string' },
					 { name: 'category', type: 'string'},
					 { name: 'purpose', type: 'string' },
					 { name: 'do_number_flag', type: 'string'},
					 { name: 'trip_flag', type: 'string'},
					 { name: 'm3_flag', type: 'string'},
					 { name: 'status', type: 'string' },
					 { name: 'last_updated_by', type: 'string'},
					 { name: 'last_updated_date', type: 'date'},
					 { name: 'creation_by', type: 'string'},
					 { name: 'creation_date', type: 'date'},
					 { name: 'status_img', type: 'string' }
					 
                ], 
				
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					target:'grid', //search bg process
					action_flag:'search_rt' ,
					org_id:$("#org_id").val(), 
					category:$("#category").val(), 
					status:$("#status").val(),
					ownership_id:$("#ownership_id").val()
				},
				pagesize: 20,
                root: 'Rows',   
				beforeprocessing: function (data) {    
                    source.totalrecords = data[0].TotalRows;
                }, 
                sort: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'sort'); //grind name
                }, 
                filter: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'filter');
					//$("#datagrid").jqxGrid('refreshdata', 'filter');
                }
				
            }; 
		   
		   var editimagerenderer = function (row, datafield, value) {
				var editicon = "<div align='center' style='padding:2px; vertical-align:middle;'>";
				
				if(value == 'Y'){
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil.png' >";
				}
				else {
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil_disabled.png' >";
				}
				editicon = editicon + 	"</div>";
				return editicon;
			};
		   
            var dataadapter = new $.jqx.dataAdapter(source);
			
			
            $("#datagrid").jqxGrid(
            {	
                width: '100%',
                source: dataadapter,  
				autoheight: true,	 
				columnsresize: true,
                pageable: true,
				selectionmode: 'none',
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
						var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px;font-size:11px; font-weight:bold;'>Search Result</span>");   
						toolbar.append(container);
						container.append(span);   
					}
				},
		  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [  
					
					{ text: 'Organization', datafield: 'org_description', align: 'left', cellsalign: 'left', minwidth: 260 },
					{ text: 'Ownership', datafield: 'ownership_name', align: 'left', cellsalign: 'left', minwidth: 260 },
					{ text: 'Ownership ID', datafield: 'ownership_id', align: 'left', cellsalign: 'left', minwidth: 260, hidden:true },
					{ text: 'Category', datafield: 'category', width:220, align: 'center', cellsalign: 'center'},
					{ text: 'Purpose', datafield: 'purpose', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'DO Number', datafield: 'do_number_flag', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'Trip', datafield: 'trip_flag', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'M3', datafield: 'm3_flag', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'Status', datafield: 'status', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Creation By', datafield: 'creation_by', align: 'center', cellsalign: 'center', width: 100 },
					{ text: 'Creation Date', datafield: 'creation_date', 
					   cellsformat: 'dd/MM/yyyy hh:mm:ss tt', align: 'center', cellsalign: 'center', width: 150  },
					{ text: 'Last Updated By', datafield: 'last_updated_by', align: 'center', cellsalign: 'center', width: 150 },
					{ text: 'Last Updated Date', datafield: 'last_updated_date', 
					   cellsformat: 'dd/MM/yyyy hh:mm:ss tt', align: 'center', cellsalign: 'center', width: 150  },
					{ hidden: 'org_id', datafield: 'org_id'},
					{ text: 'Edit', datafield: 'status_img', cellsrenderer:editimagerenderer, pinned: true, align:'center', cellsalign: 'center', sortable: false, filterable: false, exportable: false, width: 50 }          
					
                 ]  
            }); 
			
			
	if(grid_init == false ){								
		
		$("#datagrid").on('cellclick', function (event) {  
				//--> check for clicked column by its title, and opened the new screen while passing data/id
				var column = $("#datagrid").jqxGrid('getcolumn', event.args.datafield).text;
				var status = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'status');

				
				if(column == 'Edit' && status == 'ACTIVE') { 
				  
					var org_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'org_id');
					var category  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'category');
					var ownership_id  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'ownership_id');					
					var filePath =  '../systems/general_master/master_data/manual_emct_setup/';
						  
					var fullPath = filePath + 'manual_emct_setup_add.cfm?org_id='+org_id+'&category='+category+'&type=edit'+'&ownership_id=' + ownership_id;
						  
					window.parent.openNewTab('Manual EMCT Setup (Edit)',fullPath,$("#fID").val());
					 
				} 
				
			}); 	
	}
		}); 
	  grid_init = true;
	}
