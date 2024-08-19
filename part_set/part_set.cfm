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
   
<script type="text/javascript" src="part_set.js"></script>
 
<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke>  
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->

</head>	 
<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header">General Master > Master Data > Part Set </div>  
	</div>  
	
	<br><br><br>   
	
	<div style="width:99%; margin:auto">  
			<div id='UIPanel'> 
				<div>Search Parameters</div>  
				<div>   
					<cfoutput>
						<form name="searchForm" id="searchForm">
							<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
								<tr><td height="5"></td></tr>
								<tr>
									<td align="right" width="25%">Organization : </td>
									<td align="left" width="20%">
										<cfif registeredOrg.recordCount LT 2 > 
											 <input type="hidden" name="org_id" id="org_id" class="formStyle" value="#registeredOrg.org_id#">
											 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#registeredOrg.org_description#" 
											 size="40" readonly> 
										<cfelse>
											<select name="org_id" id="org_id" class="formStyle tips">
											<option value="">-- All --</option> 
												<cfloop query="registeredOrg">
													<option value="#org_id#">#org_description#</option>
												</cfloop>
											</select> 
										</cfif> 
									</td>   
									<td align="right" width="25%">Ownership: </td>
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
				 
								
								<tr class="motherPartFilterRow">
                                	<td align="right">Mother Part Vendor Code : </td>
									<td align="left"> 
											<input type="text" id="mother_vendor_code" name="mother_vendor_code" class="formStyle" size="10" > 
									</td>
									<td align="right">Mother Part Vendor Name : </td>
									<td align="left">
										<div style="float:left">
											<input name="mother_vendor_id" type="hidden" id="mother_vendor_id">
											<input type="text" id="mother_vendor_name" name="mother_vendor_name" class="formStyle" size="50" 
											onChange="clearNeccessaryHiddenFields(this.id,'mother_vendor_id');" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupMotherVendorBtn"> </div> 
									</td> 
								</tr> 
								
								<tr class="motherPartFilterRow"> 
									<td align="right">Mother Part Number : </td>
									<td align="left">
										<div style="float:left"> 
											<input type="text" id="mother_part_number" name="mother_part_number" class="formStyle" size="20" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupMotherPartNumberBtn"> </div> 
									</td>
									<td align="right" width="20%">Mother Back Number : </td>
									<td align="left">
										<div style="float:left"> 
											<input type="text" id="mother_back_number" name="mother_back_number" class="formStyle" size="10" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupMotherBackNumberBtn"> </div> 
									</td>
									
								</tr>
								 
								<tr class="partFilterRow">
									<td align="right"> Part Number : </td>
									<td align="left">
										<div style="float:left"> 
											<input type="text" id="part_number" name="part_number" class="formStyle" size="20" >
										</div>
										<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupPartNumberBtn"> </div> 
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
										<input class="button white" type="button" value="Add" onClick="window.location.href='part_set_add1.cfm'" />   
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
	
 	<div id="lookupMotherVendorWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Vendor List</div>
			 <div id="lookupMotherVendorProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupMotherVendorContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	 
	<div id="lookupMotherPartNumberWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Part Number List</div>
			 <div id="lookupMotherPartNumberProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupMotherPartNumberContent" frameborder="0" scrolling="auto" ></iframe>
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
	
	<div id="lookupMotherBackNumberWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Back Number List</div>
			 <div id="lookupMotherBackNumberProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupMotherBackNumberContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	 
	
	 
	  
</body> 
</html>








