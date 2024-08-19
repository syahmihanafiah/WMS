<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	13/08/2024   	1. Add Ownership for Gear Up

--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
   
<script type="text/javascript">   
 	
	var grid_init = false; 
  
	$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });  
	});
  
	function generateDataGrid(){
 		
        $(document).ready(function () {
 
            var source =
            { 
                datatype: "json", 
                datafields: [   
					 { name: 'box_id', type: 'number' }, 
					 { name: 'box_code', type: 'string' },
					 { name: 'box_name', type: 'string' }, 
					 { name: 'measurement', type: 'string' }, 
					 { name: 'weight', type: 'string' },
					 { name: 'org_description', type: 'string' },
					 { name: 'ownership_name', type: 'string' },
					 { name: 'creation_date', type: 'date' }, 
					 { name: 'creation_by', type: 'string' }, 
					 { name: 'last_updated_date', type: 'date'}, 
					 { name: 'last_updated_by', type: 'string'}, 
					 { name: 'status', type: 'string'},
					 { name: 'edit', type: 'string'}
                ],
				  
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					action_flag:'load_data_grid',
					org_id:$("#org_id").val(), 
					status:$("#status").val(),
					ownership_id: $("#ownership_id").val(),
				},
                root: 'Rows',  
                sortcolumn: 'box_code, org_description',
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
				else {
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
						var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px; font-size:11px; font-weight:bold;'>Box List</span>");   
						toolbar.append(container);
						container.append(span);   
					}
				},
				  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [  
					{ text: 'Box Code', datafield: 'box_code'},  
					{ text: 'Box Name', datafield: 'box_name'}, 
					{ text: 'Measurement(mm)', datafield: 'measurement', align: 'center', cellsalign: 'center'}, 
					{ text: 'Weight(g)', datafield: 'weight', align: 'center', cellsalign: 'center'}, 
					{ text: 'Organization', datafield: 'org_description'}, 
					{ text: 'Ownership',datafield:'ownership_name'},
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
						var box_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'box_id'); 
						var status = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'status');
						
						if(status == 'ACTIVE'){
   							window.location.href='box_edit.cfm?box_id=' + box_id; 
						}
   						  
					}); 	 
			}
		 
      });
	   
	  grid_init = true;
	  
	} 
	
	<!---added by luqman 04102022 for co 2022/21616--->
	function downloadDataGrid(){
		var filename = 'Box Master Report';
		var param = 'filename='+filename
					+'&org_id='+$("#org_id").val()
					+'&status='+$("#status").val();
		document.getElementById('downloadFrame').src='download_box_data.cfm?'+param;
	}
	<!---added by luqman 04102022 for co 2022/21616--->
</script>

 
<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke>  
 <!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->

</head>	 
<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header">General Master > Master Data > Box Master </div>  
	</div>  
	
	<br><br><br>   
	
	<div style="width:99%; margin:auto">  
			<div id='UIPanel'> 
				<div>Search Parameters</div>  
				<div>   
					<cfoutput>
						<form name="searchForm">
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
											<select name="org_id" id="org_id" class="formStyle">
											<option value="">-- All --</option> 
												<cfloop query="registeredOrg">
													<option value="#org_id#">#org_description#</option>
												</cfloop>
											</select> 
										</cfif> 
									</td>  
									<td align="right" width="25%">Status : </td>
									<td align="left" width="30%">
										<select name="status" id="status" class="formStyle">
											 <option value="">-- All --</option>
											 <option value="ACTIVE" selected="selected">ACTIVE</option> 
											 <option value="INACTIVE">INACTIVE</option>
										</select> 
									</td> 
								</tr>
								<!---v1.1(START)--->
								<tr>
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
								</tr>
								<!---V1.1(END)--->
								<tr><td height="5"></td></tr>
								<tr> 
									<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px"> 
									    <input class="button white" type="button" value="Search" onClick="generateDataGrid()" /> 
										<input class="button white" type="button" value="Add" onClick="window.location.href='box_add.cfm'" />
                                        <!---added by luqman 04102022 for co 2022/21616--->
                                        <input class="button white" type="button" value="Export to excel" onClick="downloadDataGrid()" /> 
                                        <!---added by luqman 04102022 for co 2022/21616--->   
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
            
            <iframe name="downloadFrame" id="downloadFrame" height="0" width="0"></iframe>
	</div>
	
 
 
	  
</body> 
</html>








