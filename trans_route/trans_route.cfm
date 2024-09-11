<!---
  Suite         : EMCT
  Purpose       : Transportation Route

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	03/12/2020     	Initial Creation
--->

<cfsetting showdebugoutput="no">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
<cfinclude template="../../../includes/parameter_option_control.cfm" >
   
<script language="javascript" src="trans_route.js"></script> 
 <!---v1.1(START)--->
 <cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
 <!---v1.1(END)--->

 
</head>	 
<body background="../../../includes/images/bground1.png">  

	<div id="content">
		<div class="screen_header"><cfoutput>#session.apps_name#</cfoutput> > General Master > Master Data > Transportation Route </div>  
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
                              <td align="left" width="25%" id="organizationOption"></td> 
    								<!---v1.1(START)--->                                   
                                    <td align="right" width="20%"> Ownership :</td>
                                    <td align="left" width="25%">                                                     
                                                <select name="ownership_id" id="ownership_id" class="formStyle">
                                                <option value="">-- Please Select --</option> 
                                                    <cfloop query="getOwnerships">
                                                        <option value="#org_id#">#org_description#</option>
                                                    </cfloop>
                                                </select>                                                                           
                                    </td> 									                             
                                    <!---V1.1(END)--->
                        </tr>
                        <tr>
                            <td align="right" width="25%">Route Group : </td>
                            <td width="30%" align="left">
                               <div style="float:left; width:40%; margin-top:3px;"> 
                                    <input type="hidden" id="route_group_header_id" name="route_group_header_id">
                                    <input type="text" id="route_group" name="route_group" class="formStyle tips"
                                    style="width:94%">
                               </div>
                               <div style="float:left">
                                   <img src="../../../includes/images/open_filter.png" style="cursor:pointer; "
                                   class="lookupRGBtn tips" lookupField="route_group" field1="route_group_header_id"
                                   field2="route_group" id="lookupRGBtn">
                                   <img src="../../../includes/images/open_filter_disabled.png" id="lookupRGBtn_disabled"
                                   style="cursor:pointer;display:none;">
                                </div>    
                            </td>                            
                            <td align="right" width="20%">Transporter : </td>
                            <td align="left" width="25%">
                                <div style="float:left; width:70%; margin-top:3px;">
                                    <input type="hidden" id="tpl_id" name="tpl_id" class="formStyle">
                                    <input type="text" id="tpl_name" name="tpl_name" class="formStyle tips" style="width:94%" >
                                </div>
                                <div style="float:left">
                                     <img src="../../../includes/images/open_filter.png" style="cursor:pointer;"
                                    class="lookupTPLBtn tips" lookupField="tpl_name" field1="tpl_id"
                                    field2="tpl_name" id="lookupTPLBtn">
                                </div> 
                            </td>

                       </tr>
                       <tr>
                        <td align="right" width="25%">Tier : </td>
                        <td width="30%" align="left" >
                              <select name="tier" id="tier" class="formStyle tips">
                                  <option  value="">-- All --</option>
                                  <option value="1">Tier 1</option>
                                  <option value="2">Tier 2</option>
                          </select> 
                        </td>                        
                            <td align="right" width="20%">Status : </td>
                            <td align="left" width="25%">
                                  <select name="status" id="status" class="formStyle tips">
                                      <option  value="">-- All --</option>
                                      <option selected value="Y">ACTIVE</option>
                                      <option value="N">INACTIVE</option>
                              </select> 
                            </td>
                       </tr>
                       <tr><td height="5"></td></tr>
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
    
    <div id="lookupTPLWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Transporter List</div>
			 <div id="lookupTPLProgress" style="float:left; margin:2px 0px 0px 5px">
             <img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupTPLContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
    
     <div id="lookupRGWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Route Group</div>
			 <div id="lookupRGProgress" style="float:left; margin:2px 0px 0px 5px">
             <img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupRGContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
    
</body> 
</html>


 