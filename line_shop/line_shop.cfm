<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	9/08/2024   	1. Add Ownership for Gear Up

--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke> 
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)---> 

<script type="text/javascript">   

	var grid_init = false; 
  
	$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });  
		/* PLANE PMSB PROJECT */
		fillShop();
		$("#org_id").change(function(){
				fillShop();
		});
		
		
		$("#addBtn").click(function(){
			var filePath = '../systems/general_master/master_data/line_shop/';
		    var fullPath = filePath + 'line_shop_add.cfm?';
		    window.parent.openNewTab('Line Shop [Add]',fullPath,$("#fID").val());	
		});
		
	});
  
	function generateDataGrid(){
 		
        $(document).ready(function () {
 
            var source =
            { 
                datatype: "json", 
                datafields: [   
					 { name: 'line_shop_id', type: 'number' }, 
					 { name: 'line_shop', type: 'string' },
					 { name: 'shop_name', type: 'string' },
					 { name: 'ownership_name', type: 'string' },
					 { name: 'volume_source', type: 'string' },
					 { name: 'org_description', type: 'string' },
					 { name: 'creation_date', type: 'date' }, 
					 { name: 'creation_by', type: 'string' }, 
					 { name: 'last_updated_date', type: 'date'}, 
					 { name: 'last_updated_by', type: 'string'}, 
					 { name: 'status', type: 'string'},
					 { name: 'status2', type: 'string' },
					 { name: 'jit_flag', type: 'string' }
					 
                ],
				  
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					action_flag:'load_data_grid',
					org_id:$("#org_id").val(),
					shop_id:$("#shop_id").val(),
					status:$("#status").val(),
					ownership_id:$("#ownership_id").val(),
				},
                root: 'Rows',  
                sortcolumn: 'shop_name, line_shop, org_description',
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
				
				if(value == 'ACTIVE'){
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil.png' >";
				}
				else{ 
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil_disabled.png' >";
				}
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
						var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px; font-size:11px; font-weight:bold;'>Shop List</span>");   
						toolbar.append(container);
						container.append(span);   
					}
				},
				  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [  
				    { text: 'Organization', datafield: 'org_description', minwidth:200}, 
				    { text: 'Organization', datafield: 'ownership_name', minwidth:150}, 
					{ text: 'Line Shop', datafield: 'line_shop', width:100, align: 'center', cellsalign: 'center'},  
					{ text: 'Shop', datafield: 'shop_name', width:100, align: 'center', cellsalign: 'center'},  
					{ text: 'Volume Source', datafield: 'volume_source', width:100, align: 'center', cellsalign: 'center'}, 
					{ text: 'Status', datafield: 'status', width:80, align: 'center', cellsalign: 'center'}, 
					{ text: 'JIT Flag', datafield: 'jit_flag', width:80, align: 'center', cellsalign: 'center'}, 
					{ text: 'Created Date', datafield: 'creation_date', cellsformat: 'dd/MM/yyyy hh:mm:ss tt', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Created By', datafield: 'creation_by', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Last Update Date', datafield: 'last_updated_date', cellsformat: 'dd/MM/yyyy hh:mm:ss tt', width:150, align: 'center', cellsalign: 'center' }, 
					{ text: 'Last Update By', datafield: 'last_updated_by', width:150, align: 'center', cellsalign: 'center' },
					{ text: 'Edit', datafield: 'status2', width: 60, cellsrenderer: editimagerenderer, pinned: true, align: 'center', sortable: false, filterable: false, exportable: false}
                 ] 
				  
				 
            }); 
			 
	  		if(grid_init == false ){
			
					$("#datagrid").on('cellclick', function (event) { 
						var line_shop_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'line_shop_id'); 
						var getStatus = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'status'); 
						
						if (getStatus == 'ACTIVE'){
   							//window.location.href='line_shop_edit.cfm?line_shop_id=' + line_shop_id;   
							 var filePath = '../systems/general_master/master_data/line_shop/';
							 var fullPath = filePath + 'line_shop_edit.cfm?line_shop_id='+line_shop_id;
							 window.parent.openNewTab('Line Shop [Edit]',fullPath,$("#fID").val());
						}
					}); 	 
			}
		 
      });
	   
	  grid_init = true;
	  
	} 
	
	
	/* PLANE PMSB PROJECT */
	function fillShop(org_id){
		$(document).ready(function(){ 
			if($('#org_id').val() != '') {
			
			$.ajax({
						type: 'POST',
						url: 'bgprocess.cfm',
						data: {
						target:'grid',
						action_flag:'fillShop',
						org_id:$('#org_id').val()
					}, 	
						success:function(data){ 
						var resultArr = data.split("~~");    
						$("#displayShop").html(resultArr[1]);
					  },
						error:function(){ 
							window.parent.notify("error","Line Shop",'Error while processing your request',"3000");
						}
					});
		}
		else { 
				$("#displayShop").html('<select class="formStyle tips" disabled name="shop_id" id="shop_id"><option value="">-- Please Select --</option></select></div>');
			}

	  });
	}
</script>

</head>	 
<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header"><cfoutput>#session.apps_name#</cfoutput> > General Master > Master Data > Line Shop Master </div>  
	</div>  
	
	<br><br><br>   
	
	<div style="width:99%; margin:auto">  
			<div id='UIPanel'> 
				<div>Search Parameters</div>  
				<div>   
					<cfoutput>
						<form name="searchForm">
                        	<input type="hidden" id="fID" value="#session.activefunctionid#" >
							<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
								<tr><td height="5"></td></tr>
								<tr>
									<td align="right" width="20%">Organization : </td>
									<td align="left" width="25%">
										<cfif registeredOrg.recordCount LT 2 > 
											 <input type="hidden" name="org_id" id="org_id" class="formStyle" value="#registeredOrg.org_id#">
											 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#registeredOrg.org_description#" 
											 size="40" readonly> 
										<cfelse>
											<select name="org_id" id="org_id" class="formStyle" onChange="fillShop(this.value);">
											<option value="">-- All --</option> 
												<cfloop query="registeredOrg">
													<option value="#org_id#">#org_description#</option>
												</cfloop>
											</select> 
										</cfif> 
									</td> 
								<!---v1.1(START)--->								
									<td align="right" width="20%"> Ownership :</td>
									<td align="left" width="25%">
										<cfoutput>
											<cfif getOwnerships.recordCount LT 2 > 
												 <input type="hidden" name="ownership_id" id="ownership_id" class="formStyle" value="#getOwnerships.org_id#">
												 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#getOwnerships.org_description#" 
												 size="40" readonly> 
											<cfelse>
												<select name="ownership_id" id="ownership_id" class="formStyle">
												<option value="">-- All --</option> 
													<cfloop query="getOwnerships">
														<option value="#org_id#">#org_description#</option>
													</cfloop>
												</select> 
											</cfif> 
										</cfoutput>
									</td> 																	
								<!---V1.1(END)--->									
								</tr> 
								<tr> 
									<td align="right" width="25%">Shop : </td>
									<td align="left" width="30%">
                                    <!--- PLANE PMSB PROJECT --->
										<div id="displayShop" style="display: inline-block;">
                                            <select id="shop_id" name="shop_id" class="formStyle" disabled="disabled">
                                                <option value="">-- Please Select --</option> 
                                            </select> 
                                        </div>
									</td> 
									<td align="right">Status : </td>
									<td align="left">
										<select name="status" id="status" class="formStyle">
											 <option value="">-- All --</option>
											 <option value="ACTIVE" selected="selected">ACTIVE</option> 
											 <option value="INACTIVE">INACTIVE</option>
										</select> 
									</td> 
								</tr>
								<tr><td height="5"></td></tr>
								<tr> 
									<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px"> 
									    <input class="button white" type="button" value="Search" onClick="generateDataGrid()" /> 
										<input class="button white" type="button" value="Add" id="addBtn"/>   
										<input class="button white" type="button" value="Reset" onClick="window.location.href=self.location" />
									</td>
								</tr>
							</table>
						</form> 
					</cfoutput>
				</div> 
			</div>
			<br>
			<div id="datagrid" ></div>  
	</div>
	
 
 
	  
</body> 
</html>








