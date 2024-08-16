<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >  
<cfinclude template="../../../includes/parameter_option_control.cfm" > 
<script type="text/javascript" src="part_list.js"></script>  
 <!---v1.1(START)--->
 <cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
 <!---v1.1(END)--->
</head>	 
<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header">General Master > Master Data > Part List </div>  
	</div>  
	
	<br><br><br>   
	
	<div style="width:99%; margin:auto">  
			<div id='UIPanel'> 
				<div>Search Parameters</div>  
				<div>   
					<cfoutput>
						<form name="searchForm" id="searchForm" method="post">
                        	<input type="hidden" id="fID" value="#session.activefunctionid#" >
							<table width="100%" cellpadding="2" class="formStyle" cellspacing="0">
								<tr><td height="5"></td></tr>
								<!---1st Row--->
								<tr>
									<td align="right" width="20%">Organization : </td>
                                    	<td align="left" width="25%" id="organizationOption"></td> 
									<td align="right" width="20%">Ownership : </td> 
								<!---v1.1(START)--->
									<td align="left" width="25%">								
											<cfif getOwnerships.recordCount LT 2 > 
												 <input type="hidden" name="ownership_id" id="ownership_id" class="formStyle" value="#getOwnerships.ownership_id#">
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
									</td> 															
								<!---V1.1(END)--->										
								</tr>
								<!---2nd Row--->
								<tr>  
									<td align="right" width="25%">Part Number : </td>
										<td align="left" width="30%">
											<div style="float:left; margin-top:2px;">  
												<input name="part_number" type="hidden" id="part_number">
												<input type="text" id="lookup_part_number" name="lookup_part_number" class="formStyle formStyleReadOnly tips_left" size="20" readonly onKeyDown="clearHiddenField('part_number')" >
											</div>
											<div style="float:left"> 
											<img src="../../../includes/images/open_filter.png" style="cursor:pointer;display:none" id="lookupPartNumberBtn"  > 
											<img src="../../../includes/images/open_filter_disabled.png" id="lookupPartNumberBtnDisabled"   > 
											</div> 
										</td>
                                	<td align="right">Vendor Code : </td>
										<td align="left"> 
												<input type="text" id="vendor_code" name="vendor_code" class="formStyle" size="10" > 
										</td>
								</tr> 
								<!---3rd Row--->
								<tr> 
									<td align="right" width="20%">Vendor Name : </td>
									<td align="left" width="35%">
										<div style="float:left">
											<input name="vendor_id" type="hidden" id="vendor_id">
											<input type="text" id="vendor_name" name="vendor_name" class="formStyle" size="40" 
                                            onKeyUp="resetHiddenField('vendor_id');" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupVendorBtn"> </div> 
									</td>
									<td align="right">Back Number : </td>
									<td align="left">
										<div style="float:left"> 
											<input type="text" id="back_number" name="back_number" class="formStyle" size="10" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupBackNumberBtn"> </div> 
									</td>

								</tr>
								<!---4th Row--->
								<tr>
									<td align="right">Status : </td>
									<td align="left">
										<select name="status" id="status" class="formStyle">
											 <option value="">-- All --</option>
											 <option value="ACTIVE" selected="selected">ACTIVE</option> 
											 <option value="INACTIVE">INACTIVE</option>
										</select> 
									</td> 
								</tr>
								<tr><td height="5" colspan="4"></td></tr>
								<tr> 
									<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px"> 
									    <input class="button white" type="button" value="Search" onClick="generateDataGrid()" /> 
<!--- 										<input class="button white" type="button" value="Add" id="addBtn" onClick="initiateAddUI()" />    --->
										<input class="button white" type="button" value="Add" id="addBtn" />   
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
	
 
 	<div id="lookupVendorWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Vendor List</div>
			 <div id="lookupVendorProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupVendorContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	
	<div id="lookupPartNumberWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Part Number List</div>
			 <div id="lookupPartNumberProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupPartNumberContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	
	<div id="lookupBackNumberWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Back Number List</div>
			 <div id="lookupBackNumberProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupBackNumberContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
    
 <iframe name="downloadFrame" id="downloadFrame" height="0" width="0"></iframe>
	 
	  
</body> 
</html>








