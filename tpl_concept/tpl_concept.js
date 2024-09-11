//1: UPDATE BY SYAHMI HANAFIAH FOR GEAR UP PROJECT || 26/08/2024
var grid_init = false; 
$jqtips(document).ready(function() { 		   
	$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY:5}); 		   
});
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
					  else if($("#tier").val()==''){
						  showTips('tier','Please select tier',1000);	
					  }
					  else if($("#ownership_id").val() == ''){
						showTips('ownership_id','Please select an ownership',1000);
					  }
						 
					  else {
						  var filePath = '../systems/general_master/master_data/tpl_concept/';
						  
						  var fullPath = filePath + 'tpl_concept_add.cfm?org_id='+$("#org_id").val()
						  +'&tpl_id='+''+'&tier='+$("#tier").val()+'&type=add'+'&ownership_id=' + $("#ownership_id").val();
						  
						  window.parent.openNewTab('TPl Cost Elements (Add)',fullPath,$("#fID").val());
					  }
 				});
				
				$("#reset").click(function() {	 
					window.location.href=self.location
				});	
				
				$("#org_id").change(function(){
				getGroup(this.value);
				});			
							
				
		   
	}); 
		
	

function getData(){

	 	$(document).ready(function () {
			
		
		
            var source =
            { 
               
                datatype: "json", 
                datafields: [  
					 { name: 'rnum', type: 'number' } ,
					 { name: 'tpl_id', type: 'number' },
					 { name: 'org_id', type: 'integer' },					 
					 { name: 'org_description', type: 'string' } ,
					 { name: 'ownership_name', type: 'string' } ,
					 { name: 'ownership_id', type: 'number' } ,
					 { name: 'group_code', type: 'string' },
					 { name: 'group_desc', type: 'string' },
					 { name: 'tier', type: 'string' },
					 { name: 'status', type: 'string' },
					 { name: 'status_img', type: 'string' },
					 { name: 'creation_date', type: 'date' },
					 { name: 'creation_by', type: 'string' },
					 { name: 'updated_date', type: 'date' },
					 { name: 'updated_by', type: 'string' }
					 
                ], 
				
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					target:'grid', //search bg process
					action_flag:'search_rt' ,
					org_id:$("#org_id").val(),
					tier:$("#tier").val(), 
					group_code:($("#group_code").val()).trim(),
					status:$("#status").val(),
					ownership_id: $("#ownership_id").val(),
					
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
				
				if(value == 'ACTIVE'){
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
				//selectionmode: 'checkbox',
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
					
					{ text: 'No', datafield: 'rnum', align: 'center', cellsalign: 'center', width: 40},
					{ text: 'Organization', datafield: 'org_description', align: 'left', cellsalign: 'left', minwidth: 200 },
					{ text: 'Ownership', datafield: 'ownership_name', align: 'left', cellsalign: 'left', minwidth: 200 },
					{ text: 'Ownership ID', datafield: 'ownership_id', align: 'left', cellsalign: 'left', minwidth: 200 , hidden: true },					
					{ text: 'Group Code', datafield: 'group_code', align: 'center', cellsalign: 'center' , width: 90 },
					{ text: 'Description', datafield: 'group_desc', align: 'center', cellsalign: 'center', width: 200},					
					{ text: 'Trans Type', datafield: 'tier', align: 'center', cellsalign: 'center', width: 90  }, 
					{ text: 'Status', datafield: 'status', align: 'center', cellsalign: 'center', width: 90 },
					{ text: 'Created Date', datafield: 'creation_date',
					   cellsformat: 'dd/MM/yyyy hh:mm:ss tt',align: 'center', cellsalign: 'center', width: 150  },
					{ text: 'Created By', datafield: 'creation_by', align: 'center', cellsalign: 'center', width: 100 },
					{ text: 'Updated Date', datafield: 'updated_date', 
					   cellsformat: 'dd/MM/yyyy hh:mm:ss tt', align: 'center', cellsalign: 'center', width: 150  },
					{ text: 'Updated By', datafield: 'updated_by', align: 'center', cellsalign: 'center', width: 100 },
					{ hidden: 'tpl_id', datafield: 'tpl_id'},{ hidden: 'org_id', datafield: 'org_id'},
					{ text: 'Edit', datafield: 'status_img', cellsrenderer:editimagerenderer, pinned: true, align:'center', cellsalign: 'center', sortable: false, filterable: false, exportable: false, width: 40 }          
					
                 ]  
            }); 
			
			
	if(grid_init == false ){								
		
		$("#datagrid").on('cellclick', function (event) {  
				//--> check for clicked column by its title, and opened the new screen while passing data/id
				var column = $("#datagrid").jqxGrid('getcolumn', event.args.datafield).text;
				var status = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'status');

				
				if(column == 'Edit' && status == 'ACTIVE') { 
				  
					var org_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'org_id');
					var tpl_id  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'tpl_id'); 
					var tier  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'tier');
					var ownership_id  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'ownership_id');					
					var filePath =  '../systems/general_master/master_data/tpl_concept/';
						  
					var fullPath = filePath + 'tpl_concept_add.cfm?org_id='+org_id+'&tpl_id='+tpl_id+'&tier='+tier+'&type=edit' + '&ownership_id=' + ownership_id;
						  
					window.parent.openNewTab('TPl Cost Elements (Edit)',fullPath,$("#fID").val());
					 
				} 
				
			}); 	
	}
		}); 
	  grid_init = true;
	}


function getGroup(org_id){
	  $(document).ready(function () {
		
		if(org_id != '') {
			$.ajax({
						type: 'POST',
						url: 'bgprocess.cfm',
						data: {
						target:'grid',
						action_flag:'getGroupCode',
						org_id:org_id
	
					}, 
		
						
						success:function(data){ 
						var resultArr2 = data.split("~~");    
						$("#displayGC").html(resultArr2[1]);

					  },
						error:function(){ 
							window.parent.notify("error","TPL COncept",'Error while processing your request',"3000");
						}
					});
				
			
		}
		else{
			var select = document.getElementById('group_code');
				select.value = "";
				select.disabled = true;		
			
		}

	  });
	  
}
