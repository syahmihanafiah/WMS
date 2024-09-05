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
<script language="javascript" src="upload_op_st_vendor.js"></script>
<link rel="stylesheet" href="upload_op_st_vendor.css" type="text/css">



</head>	 
<body>  

	<div id="content">
		<div class="screen_header uiBreadcrumb"></div> 
	</div> 
	
	<br><br><br> 

	<div class="container-fluid no-padding">
	
        <div id="searchPanel" class="card text-center" style="margin-bottom:10px;"> 
            <div class="card-header uiTitle"></div>
            <div class="card-body">
                <form id="uploadForm" action="upload_op_st_vendor_verify.cfm"  enctype="multipart/form-data" method="post" >  
                    
                    <div class="fw_row fw_options" fw_option_list="org_id*" ></div>

                    <hr class="field_divider">
                    
                    <div class="fw_row" >
                        <div>
                            <div label="Part Number" class="fw_lookup_field" fw_lookup="part_number" >  
                                <input type="text" class="form-control" id="part_number" name="part_number">  
                            </div>                             
                        </div> 
                        <div>
                            <div label="Back Number" class="fw_lookup_field" fw_lookup="back_number" >
                                <input type="text" class="form-control" id="back_number" name="back_number">  
                            </div>
                        </div>                    
                        <div>
                            <input type="hidden" id="vendor_id" name="vendor_id">  
                                <div label="Vendor" class="fw_lookup_field" fw_lookup="vendor"> 
                                <input type="text" class="form-control" id="vendor_name" name="vendor_name">   
                        </div>
                        </div>
                        <div>
                            <div label="Warehouse"> 
                                <select  class="form-select"  id="warehouse" name="warehouse" disabled >
                                    <option value="">-- Please Select --</option>
                                </select>
                            </div>
                        </div>                        
                    </div>
                </form>
            </div>
            <div class="card-footer" style="text-align:right"> 

                <button type="button" class="btn btn-success" id="uploadBtn"><i class="fa-solid fa-arrow-up-from-bracket" style="margin-right:10px"></i>Upload</button>                  
                <button type="button" class="btn btn-upload " id="dwnldBtn"><i class="fa-solid fa-cloud-download" style="margin-right: 10px;"></i>Download</button>
                <button type="button" class="btn btn-primary fw_search_btn" id="searchBtn"></button>
            </div>  
        </div>
            <iframe id="download_panel" style="display:none"></iframe>

        <div id="gridPanel" class="card text-center" style="display:none">  
            <div class="card-body">  
                <table title="Upload Opening Stock Vendor" id="datagrid" class="table promiseDataGrid table-hover table-bordered nowrap" style="width:100%">
                    <thead>
                        <tr> 
                            <th>No</th>
                            <th>Edit</th>
                            <th>Organization</th>
                            <th>Vendor</th>
                            <th>Part Name</th>
                            <th>Part Number</th> 
                            <th>Back Number</th> 
                            <th>Qty Per Box</th> 
                            <th>Previous Qty</th> 
                            <th>Current Qty</th> 
                            <th>Last Updated Date</th> 
                            <th>Last Updated By</th> 
                        </tr>
                    </thead> 
                </table>
            </div>
         </div>         
	</div> 

	<div class="float">
				
		<span class="btn-floating openSearchPanel gridBtn" desc="Open Search Panel" > </span>		 	      	
		<span id="downLoadBtn" class="btn-floating download gridBtn" desc="Download Button" ></span> 	
		<span id="uploadFloatBtn" class="btn-floating add_file gridBtn" desc="Upload Button" ></span> 	
		<span class="btn-floating reset resetBtn" desc="Reload" > </span>
		<span class="btn-floating cross closeBtn" desc="Close" > </span>
	</div>

 	<!-- ------------------------------- update quantity panel ------------------------------------------------>
  <div id="updatePanel" class="modal draggable fade">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fa-solid fa-pen"></i>Update Quantity</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <form id="editForm" action="bgprocess.cfm" method="post">
          <input type="hidden" id="action_flag" name="action_flag" value="updateQuantity">
          <div class="modal-body">  
             <div class="fw_modal_row2">                     
                <div>
                    <div label="Organization">
                        <input type="text" class="form-control" id="updateOrga" name="updateOrga" readOnly>
                    </div> 
                </div>
                <div>
                    <div label="Vendor">
                        <input type="text" class="form-control" id="updateVendor" name="updateVendor" readOnly>
                    </div> 
                </div>
                <div>
                    <div label="Part Name">
                        <input type="text" class="form-control" id="updatePartname" name="updatePartname" readOnly>
                    </div> 
                </div>
                <div>
                    <div label="Part Number">
                        <input type="text" class="form-control" id="updatePartnum" name="updatePartnum" readOnly>
                    </div> 
                </div>
                <div>
                    <div label="Back Number">
                        <input type="text" class="form-control" id="updatebackNum" name="updatebackNum" readOnly>
                    </div> 
                </div>
                <div>
                    <div label="Previous Quantity">
                        <input type="text" class="form-control" id="updateprevQty" name="updateprevQty" readOnly>
                    </div> 
                </div>                                                                  
                <div>               
                    <div label="Current Quantity">
                        <input type="text" class="form-control" id="updateQty" name="updateQty">
                    </div>
                </div>
            </div>
                        <input type="hidden" id="detail_id" name="detail_id">
                        <input type="hidden" id="prev_qty" name="prev_qty">
          </div>               
          <div class="modal-footer">
            <button type="button" class="btn btn-primary fw_confirmation" id="updateBtn">Save</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>

        </form>
      </div>
    </div>
  </div>

</body> 
</html>