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

<cfparam name="orgID" default="" > 
<cfparam name="part_number" default="" >  

<script type="text/javascript" src="part_set_add1.js"></script>
 
</head>

<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke>  
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->

<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Part Set Master > Add </div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Add new part set</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
			
            <div> 
				<cfoutput>  
				<form name="addForm" id="addForm" action="bgprocess.cfm" method="post" >  
					<input type="hidden" id="action_flag" name="action_flag" value="next" > 
				    <table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
                    	<tr>
                        	<td height="5"></td>
                      	</tr>
                      	<tr>
                       	 	<td align="right" width="20%">Organization : </td>
                        	<td align="left" width="20%"> 
								<cfif registeredOrg.recordCount LT 2 > 
									 <input type="hidden" name="org_id" id="org_id" class="formStyle" value="#registeredOrg.org_id#">
									 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#registeredOrg.org_description#" size="40" readonly> 
								<cfelse>
									<select name="org_id" id="org_id" class="formStyle" onChange="clear_tooltips();">
									<option value="">-- Please Select --</option>
									<cfloop query="registeredOrg">
										 <option value="#org_id#" <cfif orgID EQ org_id > selected </cfif> >#org_description#</option>
									</cfloop>
									</select>
								</cfif> 								
                        	</td>
                        	<td align="right" width="20%">Mother Part Number : </td>
                        	<td align="left" width="40%">
						  		<div style="float:left"> 
									<input type="text" id="mother_part_number" name="mother_part_number" class="formStyle" size="20" >
								</div>
								<div style="float:left"> <img src="../../../includes/images/open_filter.png" style="cursor:pointer;" id="lookupMotherPartNumberBtn"> </div> 
							</td>
							
                      	</tr>  
						<tr>
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
                      	<tr>
                        	<td height="10"></td>
                      	</tr> 
                      	<tr>
							<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
								<input id="nextBtn" name="submit" type="submit" class="button white" value="Next" />
								<input id="resetBtn" name="button" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
								<input id="closeBtn" name="button" type="button" class="button white" onClick="window.location.href='part_set.cfm'" value="Close" />
							</td>
                     	</tr>
                   </table>
				</form>
				</cfoutput>
 
			</div>
		</div> 
	<br> 
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
 
	
</body>
</html>








