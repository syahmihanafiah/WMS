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
 
<script type="text/javascript"> 
  
  	$(document).ready(function () {  
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
		<!--- PLANE PMSB Project --->
		$("#active_date_picker").jqxDateTimeInput({width: '230px', height: '25px', disabled:"true"}); 
		$('#active_date_picker').val(convertDateFormat($('#active_date').val()));
		$('#active_date_picker').on('valuechanged', function (event) {   
			$('#active_date').val( $('#active_date_picker').val());
			clear_tooltips();
		}); 
	  
		$("#inactive_date_picker").jqxDateTimeInput({width: '230px', height: '25px'}); 
		setMinDate('','inactive_date_picker'); 
		
		if($('#inactive_date').val() == ''){
			setTimeout(function(){
				$("#inactive_date_picker").val(null);
			},1);
		}
		else {
			setTimeout(function(){
				$('#inactive_date_picker').val(convertDateFormat($('#inactive_date').val()));
			},1);
			
		}
		$('#inactive_date_picker').on('valuechanged', function (event) {   
			$('#inactive_date').val( $('#inactive_date_picker').val());
		});
		<!--- PLANE PMSB Project --->
		
		 
		var edit_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#editForm').ajaxForm(edit_options); 
		 
  	}); 
	
	$jqtips(document).ready(function() {    
		$jqtips('#active_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});
	  
	function clear_tooltips(){ 
		$jqtips('#active_date_picker').poshytip('hide'); 
	}
	
	function inprogress(status){
		if(status=="start"){
			$("#progressbar").show(); 
			document.getElementById("updateBtn").disabled = true; 
			document.getElementById("resetBtn").disabled = true; 
			document.getElementById("closeBtn").disabled = true; 
		}
		else {
			$("#progressbar").hide();
			document.getElementById("updateBtn").disabled = false; 
			document.getElementById("resetBtn").disabled = false; 
			document.getElementById("closeBtn").disabled = false; 
		}
	}
 
	function validateInput(formData, jqForm, options) {
		
		clear_tooltips();
		
		var f = document.editForm; 
	
		if(trim(f.active_date.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#active_date_picker').poshytip('update', 'Please insert active date');
					$jqtips('#active_date_picker').poshytip('show'); 
				});
				$('#active_date_picker').focus();
				return false;
		} 
		else { 
			inprogress("start");
			return true;
		}
	}
	
	function showChangeResponse(responseText, statusText, xhr, $form)  { 
		inprogress("end"); 
		var responseArr = responseText.split("~~");
 
		if(trim(responseArr[1]) == "success"){	
				window.parent.notify("success","Edit Shop","Shop "+$("#shop_name").val()+" is successfully update!","5000");  
				window.location.href='shop.cfm';
				
		} else if(trim(responseArr[1]) == "failed"){
				window.parent.notify("error","Edit Shop",trim(responseArr[2]),"5000");
		}
	}
 
</script>
 
</head> 
  
<cfquery name="getShop" datasource="#dswms#"> 
	 SELECT shop_name, description, org_id, 
			to_char(active_date,'dd/mm/yyyy') active_date, to_char(inactive_date,'dd/mm/yyyy') inactive_date
	 FROM gen_shop 
	 WHERE shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#shop_id#"> 
</cfquery>

<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr" ></cfinvoke>
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->
 
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Shop Master > Edit</div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Edit shop</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
		 
            <div> 
				<cfoutput> 
					<cfset ownID = #ownership_id#>
				<form name="editForm" id="editForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="edit" >  
					<input type="hidden" name="shop_id" value="#shop_id#" >
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					  <tr>
						<td height="5"></td>
					  </tr>
					  <tr>
						<td align="right" width="20%">Organization : </td>
						<td align="left" width="25%"><input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,getShop.org_id)#"></td>
						<td align="right" width="20%"> Ownership :</td>
						<td align="left" width="25%">
							<cfoutput>
								<cfif getOwnerships.recordCount LT 2 >

									 <input type="hidden" name="ownership_id" id="ownership_id" class="formStyle" value="#getOwnerships.ownership_id#">
									 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#getOwnerships.org_description#" 
									 size="40" readonly> 
								<cfelse>

									
									<select name="ownership_id" id="ownership_id" class="formStyle" disabled>
									<option value="">-- All --</option> 
										<cfloop query="getOwnerships">
											<option value="#org_id#"<cfif #ownID# EQ #getOwnerships.org_id#>selected><cfelse>></cfif>
												#org_description# 
											</option>
										</cfloop>
									</select> 
								</cfif> 
							</cfoutput>
						</td> 	
					  </tr> 
					  <tr>
						<td align="right" width="20%">Shop Name : </td>
						<td align="left" width="25%"><input type="text" id="shop_name" class="formStyleReadOnly" readonly size="20" value="#getShop.shop_name#"></td> 
						<td align="right" width="25%">Description : </td>
						<td align="left" width="30%" ><input type="text" name="description" id="description" class="formStyle" size="40" value="#getShop.description#"></td>
					  </tr>  
					  <tr>
						<td align="right">Active Date : </td>
						<td align="right">
							<div align="left">
								<div id='active_date_picker'></div>
								<input type="hidden" name="active_date" id="active_date" class="formStyle" size="30" value="#getShop.active_date#">
							</div>
						</td>
						<td align="right">Inactive Date : </td>
						<td align="right">
							<div align="left">
								<div id='inactive_date_picker'></div>
								<input type="hidden" name="inactive_date" id="inactive_date" class="formStyle" size="30" value="#getShop.inactive_date#">
							</div>
						</td>
					  </tr>
			
					  <tr>
						<td height="10"></td>
					  </tr>
					  <tr>
						<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
							<input id="updateBtn" name="submit" type="submit" class="button white" value="Update" />
							<input id="resetBtn" name="button" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
							<input id="closeBtn" name="button" type="button" class="button white" onClick="window.location.href='shop.cfm'" value="Close" />
						</td>
					  </tr>
					</table>
				</form>
				</cfoutput>
 
			</div>
		</div> 
	<br> 
	</div>  
</body>
</html>








