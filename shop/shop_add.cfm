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
<style>
	
	
</style>

<script type="text/javascript"> 
  
  	$(document).ready(function () {  
	<!--- PLANE PMSB Project --->
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
		
		$("#active_date_picker").jqxDateTimeInput({width: '230px', height: '25px'});  
		setMinDate('','active_date_picker'); 
		$('#active_date_picker').on('valuechanged', function (event) {   
			$('#active_date').val( $('#active_date_picker').val());
			clear_tooltips();
		}); 
		$('#active_date_picker').jqxDateTimeInput('setDate', Date.now());
	 
		$("#inactive_date_picker").jqxDateTimeInput({width: '230px', height: '25px'}); 
		setMinDate('','inactive_date_picker'); 
		$('#inactive_date_picker').on('valuechanged', function (event) {   
			$('#inactive_date').val( $('#inactive_date_picker').val()); 
		}); 
		
		
		setTimeout(function(){
		$("#inactive_date_picker").val(null);
		},1);
	<!--- PLANE PMSB Project --->	 
		var add_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#addForm').ajaxForm(add_options); 
		 
  	}); 
	
	$jqtips(document).ready(function() { 
		$jqtips('#org_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });   
		$jqtips('#shop_name').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });   
		$jqtips('#active_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});
	  
	function clear_tooltips(){
		$jqtips('#org_id').poshytip('hide');
		$jqtips('#shop_name').poshytip('hide'); 
		$jqtips('#active_date_picker').poshytip('hide'); 
	}
	
	function inprogress(status){
		if(status=="start"){
			$("#progressbar").show(); 
			document.getElementById("saveBtn").disabled = true; 
			document.getElementById("resetBtn").disabled = true; 
			document.getElementById("closeBtn").disabled = true; 
		}
		else {
			$("#progressbar").hide();
			document.getElementById("saveBtn").disabled = false; 
			document.getElementById("resetBtn").disabled = false; 
			document.getElementById("closeBtn").disabled = false; 
		}
	}
 
	function validateInput(formData, jqForm, options) {
		
		clear_tooltips();
		
		var f = document.addForm; 	
		
		if(trim(f.org_id.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#org_id').poshytip('update', 'Please select organization');
					$jqtips('#org_id').poshytip('show'); 
				});
				f.org_id.focus();
				return false;
		}
		else if(trim(f.shop_name.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#shop_name').poshytip('update', 'Please insert shop name');
					$jqtips('#shop_name').poshytip('show'); 
				});
				f.shop_name.focus();
				return false;
		} 
		else if(trim(f.active_date.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#active_date_picker').poshytip('update', 'Please insert active date');
					$jqtips('#active_date_picker').poshytip('show'); 
				});
				$('#active_date_picker').focus();
				return false;
		} 
		else if(trim(f.ownership_id.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#ownership_id').poshytip('update', 'Please insert ownership');
					$jqtips('#ownership_id').poshytip('show'); 
				});
				$('#ownership_id').focus();
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
				window.parent.notify("success","Add Shop","Shop "+$("#shop_name").val()+" is successfully add!","5000");  
				window.location.href='shop.cfm';
				
		} else if(trim(responseArr[1]) == "failed"){
				window.parent.notify("error","Add Shop",trim(responseArr[2]),"5000");
		}
	}
 
</script>
 
</head>
 
<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke>  
 <!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Shop Master > Add</div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Add new shop</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
			
            <div> 
				<cfoutput> 
				<form name="addForm" id="addForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="add" >  
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					  <tr>
						<td height="5"></td>
					  </tr>
					  <tr>
						<td align="right" width="20%">Organization : </td>
						<td align="left" width="25%">
							 
							<cfif registeredOrg.recordCount LT 2 > 
								<input type="hidden" name="org_id" id="org_id" class="formStyle" value="#registeredOrg.org_id#">
								<input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#registeredOrg.org_description#" 
								size="50" readonly> 
							<cfelse>
								<select name="org_id" id="org_id" class="formStyle" onChange="clear_tooltips();">
								<option value="">-- Please Select --</option>
								<cfloop query="registeredOrg">
									<option value="#org_id#">#org_description#</option>
								</cfloop>
							</select>
							</cfif>
						</td>
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
						<td align="right" width="20%">Shop Name : </td>
						<td align="left" width="25%"><input type="text" name="shop_name" id="shop_name" class="formStyle" size="20" onKeyDown="clear_tooltips();"></td> 
						<td align="right" width="25%">Description : </td>
						<td align="left" width="30%" ><input type="text" name="description" id="description" class="formStyle" size="40"></td>
					  </tr>  
					  <tr>
						<td align="right">Active Date : </td>
						<td align="right">
							<div align="left">
								<div id='active_date_picker'></div>
								<input type="hidden" name="active_date" id="active_date" class="formStyle" size="30">
							</div>
						</td>
						<td align="right">Inactive Date : </td>
						<td align="right">
							<div align="left">
								<div id='inactive_date_picker'></div>
								<input type="hidden" name="inactive_date" id="inactive_date" class="formStyle" size="30">
							</div>
						</td>
					  </tr>
					  <tr>
						<td height="10"></td>
					  </tr>
					  <tr>
						<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
							<input id="saveBtn" name="submit" type="submit" class="button white" value="Save" />
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








