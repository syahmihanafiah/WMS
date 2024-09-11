<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	26/08/2024   	1. Add Ownership for Gear Up

--->
<cfsetting showdebugoutput="yes">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
<cfinclude template="../../../includes/parameter_option_control.cfm" >
   
<script language="javascript" src="tpl_concept.js"></script> 


 
</head>	 
<body background="../../../includes/images/bground1.png">  
               
 <!---v1.1(START)--->
 <cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
 <!---v1.1(END)--->
                           	
	<div id="content">
		<div class="screen_header"><cfoutput>#session.apps_name#</cfoutput> > General Master > Master Data > Transportation Cost > TPL Concept </div>  
	</div>  
	
	<br><br><br>   
	
            <div style="width:99%; margin:auto">  
                    <div id='UIPanel'> 
                <div>
				<div style="float:left">Search Parameter</div>
                <div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                <img src="../../../includes/images/progress_green_small.gif" >
                </div>
                </div> 
                        <div>    
					<cfoutput>  
					
                         <form name="searchForm">
	                		<input type="hidden" id="fID" value="#session.activefunctionid#" >
							<table width="100%" cellpadding="4" class="formStyle" cellspacing="0" >
                            	 <tr><td height="5"></td></tr>
                                     <tr>
                                          <td align="right" width="20%">Organization : </td>
                                          <td align="left" width="25%" id="organizationOption" ></td> 
                                          <td align="right" width="20%">Ownership :</td>
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
                                                            <option value="#org_id#">
                                                                #org_description#
                                                            </option>
                                                        </cfloop>
                                                    </select> 
                                                </cfif> 
                                            </cfoutput>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td align="right" width="25%">Group Code :</td>
                                        <td width="30%" align="left">
                                        <div id="displayGC"  style="display: inline-block;">
                                             <select name="group_code" id="group_code" class="formStyle tips" disabled>
                                                  <option value="">-- All --</option>   
                                           </select>
                                        </div>   
                                        </td>                                        
                                          <td align="right" width="20%">Transporter Type : </td>
                                          <td width="25%" align="left" >           
                                           	<select name="tier" id="tier" class="formStyle tips">
                                            		<option  value="">-- Please Select --</option>
                                                    <option  value="1">Tier : 1</option>
                                                    <option value="2">Tier : 2</option>
                                            </select> 
                                          </td>                                                                                  
                                     </tr>
                                    <tr>
                                        <td align="right" width="25%">Status</td>
                                        <td width="30%" align="left" >
                                                <select name="status" id="status" class="formStyle tips">
                                                  <option  value="">-- All --</option>
                                                  <option selected value="ACTIVE">ACTIVE</option>
                                                  <option value="INACTIVE">INACTIVE</option>
                                          </select> 
                                        </td>                                        
                                    </tr>
                                    
                           
                                     <tr><td height="5"></td></tr>
                                     <tr> 
                                         <td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px"> <!--- funtion name for grid --->
                                              <input class="button white" type="button" value="Search" id="searchBtn"/>   
                                              <input class="button white" type="button" value="Add" id="addBtn" />  
                                              <input class="button white" type="button" value="Reset" id="reset" />
                                        </td>
                                     </tr>        
                                
							</table>
						</form> 
                    </cfoutput> 
                        

  
   
				</div> 
			</div>  
			<br>

                	<div id="datagrid" class=".jqx-grid-header"> </div> <!---GRIDD NAME--->
                    
	</div>
	  
</body> 
</html>


 