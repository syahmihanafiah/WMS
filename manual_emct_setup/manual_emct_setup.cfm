<!---
  Suite         : EMCT
  Purpose       : Manual EMCT Setup

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	     			Initial Creation
  1.1.00	 Harris				15/03/2021		Fix SIT BUGS   
  1.2.00     Syahmi             19/08/2024      Gear Up Project
--->

<cfsetting showdebugoutput="no">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
<cfinclude template="../../../includes/parameter_option_control.cfm" >
   
<script language="javascript" src="manual_emct_setup.js"></script> 
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)---> 

<cfquery name="getCategory" datasource="#dsprc#" >
   SELECT attr_value as category
   FROM GEN_ATTRIBUTES
   WHERE attr_code = 'EMCT_ELEMENTS'
   AND status ='Y'
   order by attr3_value asc
</cfquery> 

 
</head>	 
<body background="../../../includes/images/bground1.png">  

	<div id="content">
		<div class="screen_header"><cfoutput>#session.apps_name#</cfoutput> > General Master > Master Data > Manual EMCT Setup </div>  
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
                         <tr><td height="5"></td><td></td></tr>
                         <tr>
                              <td align="right" width="20%">Organization : </td>
                              <td align="left" width="25%" id="organizationOption"></td>
                              
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
                              <td align="right" >Category : </td>
                              <td align="left" >                               
                                <select id="category" name="category" class="formStyle tips">
                                  <option value="">-- All --</option> 
                                      <cfloop query="getCategory" >
                                          <option value="#category#">#category#</option>
                                      </cfloop>
                                   </select>
                              </td>
                            <td align="right" >Status :</td>
                            <td align="left">
                                <select name="status" id="status" class="formStyle tips" >
                                    <option value="">-- All --</option>
                                    <option value="Y" selected>ACTIVE</option>
                                    <option value="N">INACTIVE</option>
                                </select>
                            </td>
                        </tr>
                       <tr> 
                           <td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
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
        <div id="datagrid" class=".jqx-grid-header"></div>              
	</div>
    
</body> 
</html>


 