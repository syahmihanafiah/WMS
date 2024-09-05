<!---
  Suite         : LOCAL PART IMPROVEMENT
  Purpose       : 

  Version    Developer    		Date            Remarks
  1.0.00     Syahmi         	2/1/2024     	 
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes_3.0.cfm" >   
<script language="javascript" src="upload_op_st_vendor_verify.js"></script>
 
<link rel="stylesheet" href="upload_op_st_vendor.css" type="text/css">

</head>
<cfoutput>
<!---operation process--->
        
        <cfset headerArr = []>
        <cfset currentArr = []>
        <cfset status = ''>
        <cfset msg = ''>
        <cfparam  name="correctFormat" default=false>
        <cfset header_row_start = 1 >            
        <cfset allData = []>  
        <cfset rowrepaint = ''>
        <cfset hasRedundantPartNumber = false>        
       <!---<cfoutput> #IsDefined("reuploadFile")#</cfoutput>--->
       <cfif isDefined("reuploadFile")>
         <cfif len(trim(reuploadFile)) >
            <!--- Remove previously uploaded file if exists --->
          <cfif isDefined("prev_file") && prev_file NEQ ''>                      
                <cffile action="delete" file="#expandpath('./temp_file')#/#prev_file#">            
          </cfif>
        
            <cffile action="upload" nameconflict="makeunique" fileField="reuploadFile" destination="#expandpath('./')#temp_file" result="xlfile">          
             <!---
        	<cffile action="upload" nameconflict="makeunique" fileField="reuploadFile" destination="#expandpath('./')#temp_file" result="xlfile"> 
            --->
            <cfif xlfile.fileWasSaved>
                <cfset curr_file = xlfile.serverFile>
                <cfset fullpath =  expandpath('./') & "temp_file\" & curr_file >  
                
                <cfif isSpreadsheetFile(fullpath)>
                    <cfif fileExists(fullpath)>
                    <cfspreadsheet action="read" src="#fullpath#" name="excel_file">
                    <!---<cffile action="delete" file = "#fullpath#"> --->
                    </cfif>
                    <cfset row_count = excel_file.rowCount>
                    <cfset col_count = spreadsheetGetColumnCount(excel_file)>
                        <!---Checking The Header Format--->
                        <cfloop index="i" from="#header_row_start#" to="#row_count#">
                            <cfif spreadsheetGetCellValue(excel_file,i,1) EQ 'BACK NUMBER' and (spreadsheetGetCellValue(excel_file, i, 2) eq 'CURRENT QTY'
                                 OR spreadsheetGetCellValue(excel_file, i, 2) EQ 'CURRENT QUANTITY')>
                                <cfset initial_header_pos = i>
                            
                                <cfset correctFormat = true>
                                <cfset status="success">
                            <cfelse>
                                <cfset popup_msg = "File Name : #curr_file# is in wrong format and unsuccessful to be upload !"> 
                                <cfset status="error">

                            </cfif> 
                          
                        </cfloop> 

                    <cfif correctFormat>
                            <!---Read file---->
                            <cfloop index="r" from="#header_row_start+1#" to="#row_count#">  
                                <cfset back_number = spreadsheetGetCellValue(excel_file, r, 1)>
                                <cfset current_qty = spreadsheetGetCellValue(excel_file, r, 2)>
                                <cfset arrayAppend(headerArr, { "Back Number": back_number, "Current_Qty": current_qty })>
                            </cfloop>
                            <cfset index = 1>  

                            <cfset status = 'success'>
                                <script>
                                    <cfoutput>
                                    <cfset popup_msg = "File Name : #curr_file# is in right format and successfully uploaded !">
                                        window.parent.fw_notify('#status#','#popup_msg#');
                                    </cfoutput>
                                </script>                            
   
                        <cfelse>
                            <cfset msg = 'Excel file data format is incorrect'>
                                <script>
                                    <cfoutput>
                                    <cfset popup_msg = "File Name : #curr_file# is in wrong format and fail to upload !">
                                        window.parent.fw_notify('#status#','#popup_msg#');
                                    </cfoutput>
                                </script>  
                    </cfif>                        
                <cfelse>
                    <cfset msg = "File is not an Excel file">
                </cfif>
            <cfelse>
                <cfset msg = "The file was not properly uploaded">
            </cfif>
        </cfif>
    </cfif>    
         
    <cfquery name="getOrgName" datasource="#dswms#">
        SELECT ORG_DESCRIPTION FROM FRM_ORGANIZATIONS
        WHERE  org_id =<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">       
    </cfquery>
<body>  

	<div id="content">
		<div class="screen_header uiBreadcrumb"></div> 
	</div> 
	
	<br><br><br> 

	<div class="container-fluid no-padding">

        <div id="stock_verify_panel" class="card text-center" style="margin-bottom:10px;"> 
            <div class="card-header uiTitle"></div>
            <div class="card-body">
                <form id="reuploadForm" action="upload_op_st_vendor_verify.cfm"  enctype="multipart/form-data" method="post"  >                                          
                    <div class="fw_row" >
                    <div>
                        <div label="Organization"> 
                            <input type="text" class="form-control" id="organizationname" name="organizationname" value="#getOrgName.ORG_DESCRIPTION#" readOnly>  
                        </div>
                            <input type="hidden" id="prev_file" name="prev_file"><!--use to delete previous file---->
                            <input type="hidden"  id="organization" name="organization" value="#org_id#">                              
                    </div> 
                    <div>
                        <div label="Vendor"> 
                            <input type="text" class="form-control" id="upload_vendor" name="upload_vendor" value="#vendor_name#" readOnly>  
                        </div>
                            <input type="hidden" id="vendor_id" name="vendor_id" value="#vendor_id#">
                    </div>
                    <div>
                        <div label="File Name"> 
                            <input type="text" class="form-control" id="reupload_label" name="reupload_label"class="file_label" <cfif isDefined("file_name")>value="#file_name#"</cfif> readonly>  
                        </div>
                    </div>                             
                            <input type="hidden" name="action_flag" id="action_flag" value="reupload">
                            <input type="file" name="reuploadFile" id="reuploadFile" accept=".xlsx, .xls" style="display:none">  
                    </div>
                    <hr class="field_divider">
                
                    <div class="table-responsive text-center table-wrapper" id="appendTable" name="appendTable">
                        <table id="verify_table" name="verify_table" class="custom-table mx-auto">
                            <thead>
                                <tr>
                                    <th>No.</th>
                                    <th>Part Name</th>
                                    <th>Part Number</th>
                                    <th>Back Number</th>
                                    <th>Qty Per Box</th>
                                    <th>Current Qty</th>
                                    <th>Status</th>
                                    <th>Remarks</th>
                                </tr>
                            </thead> 
                            <tbody id="verify_table_body">
                                <cfif ArrayLen(headerArr) NEQ 0>
                                <cfloop array="#headerArr#" index="item">
                                    <cfset arrayAppend(currentArr,#item["BACK NUMBER"]#)>
                                                                    
                                    <cfquery name="getPartDetails" datasource="#dswms#">
                                        select a.part_name,a.part_number,a.back_number,b.qty_per_box from gen_part_list_headers a, gen_part_list_psi b
                                        where a.part_list_header_id = b.part_list_header_id
                                        and a.active_date <= sysdate and NVL(a.inactive_date,sysdate+1) > sysdate
                                        and b.active_date <= sysdate and NVL(b.inactive_date,sysdate+1) > sysdate
                                        and a.BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value= #item["Back Number"]#>
                                    </cfquery>
                                    <tr id= "#index#">
                                        <td>#index#</td>
                                        <td>#getPartDetails.PART_NAME#</td>
                                        <td>#getPartDetails.PART_NUMBER#</td>
                                        <td>#item["Back Number"]#</td>                                        
                                        <td>#getPartDetails.qty_per_box#</td>
                                        <td>#item["Current_Qty"]#</td>
                                        <!--- CHECK FOR DUPLICATES --->
                                        <cfset duplicate = false><!--- Flag to track duplicate status --->
                                        <cfset duplicatePartNumber = ""><!--- Variable to store the duplicate part number --->

                                        <cfloop from="1" 
                                        to="#index#" index="i">
                                            <cfif i neq index and currentArr[i] EQ item["Back Number"]>
                                            <cfset duplicate = true><!--- Set duplicate flag to true if a duplicate is found --->
                                            <cfset duplicatePartNumber = currentArr[i]><!--- Set the duplicate part number --->
                                            <cfbreak><!--- Exit the loop once a duplicate is found --->
                                            </cfif>
                                        </cfloop>

                                        <cfif duplicate>
                                            <td style="background-color: lightcoral;">INVALID</td>
                                            <td>Duplicate found: #duplicatePartNumber# already exists in the list.</td>
                                        <cfelseif getPartDetails.PART_NAME NEQ ''>
                                            <td style="background-color: lightgreen;">VALID</td>
                                            <td></td>
                                        <cfelse>
                                            <td style="background-color: lightcoral;">INVALID</td>
                                            <td>Part Number does not Exist!</td>
                                        </cfif>
                                        <cfset index = index + 1>
                                    </tr>                                                                                 
                                </cfloop>

                            <cfelse>
                                    <tr style="background-color: lightcoral;">
                                        <td colspan="8">Kindly Upload A Valid Excel File !</td>    
                                    </tr>   
                            </cfif>
                          
                            </tbody>
                        </table>                               
                    </div>
                </form>
            </div>
            <div id="table-pagination" class="table-pagination">

            </div>
            <div class="card-footer" style="text-align:right">  
                <button type="button" class="btn btn-success" id="approveBtn"><i class="fa-solid fa-arrow-up-from-bracket" style="margin-right:10px"></i>Approve</button>                  
                <button type="button" class="btn btn-reupload " id="reuploadBtn"><i class="fa-solid fa-cloud-upload" style="margin-right:10px"></i>Upload</button>  
                <button type="button" class="btn btn-danger" id="cancelBtn">Cancel</button>      
            </div>  
        </div>


	</div> 

	<div class="float">			
		<span class="btn-floating cross closeBtn" desc="Close" > </span>
	</div>
</body> 

</cfoutput>	 

</html>