<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
 
<script type="text/javascript"> 
  
  	$(document).ready(function () {  
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
		
		$("#active_date_picker").jqxDateTimeInput({width: '230px', height: '25px'});  
		$('#active_date_picker').on('valuechanged', function (event) {   
			$('#active_date').val( $('#active_date_picker').val());
			clear_tooltips();
		}); 
		$('#active_date_picker').jqxDateTimeInput('setDate', Date.now());
	 
		$("#inactive_date_picker").jqxDateTimeInput({width: '230px', height: '25px'}); 
		$('#inactive_date_picker').val(null);
		$('#inactive_date_picker').on('valuechanged', function (event) {   
			$('#inactive_date').val( $('#inactive_date_picker').val()); 
		}); 
		
		
		$("#saveBtn").click(function(e) {
			if(trim($("#org_id").val()) == "") { 
				  $jqtips(document).ready(function() {   
					$jqtips('#org_id').poshytip('update', 'Please select organization');
					$jqtips('#org_id').poshytip('show'); 
					$("#org_id").focus();
				}); 
			}
            else if(trim($("#box_code").val()) == "" ) { 
				  $jqtips(document).ready(function() {   
					$jqtips('#box_code').poshytip('update', 'Please insert box code');
					$jqtips('#box_code').poshytip('show'); 
					$("#box_code").focus();
				}); 
			}
			else {
				
				
				$.ajax({
					  type: 'POST',
					  url: 'bgprocess.cfm',
					  data: { action_flag: 'validateBoxCode', box_code:trim($("#box_code").val()), org_id:($("#org_id").val()) }, <!---add org_id 11/05/2018--->
					  beforeSend:function(){ 
						$('#progressbar').show();
					  },
					  success:function(data){  
					  	validateAJAXResponse(data);   
						var resultArr = data.split("~~"); 
						if(resultArr[1] == 0){
							$('#addForm').submit();
						}
						else
						{
							$jqtips(document).ready(function() {   
								$jqtips('#box_code').poshytip('update', trim($("#box_code").val()) + ' is already registered as a box code ' + resultArr[2]);
								$jqtips('#box_code').poshytip('show'); 
							}); 
						}
						$('#progressbar').hide();
					  },
					  error:function(){ 
						window.parent.notify("error","Validate box code",'Error while processing your request',"3000");
						$('#progressbar').hide();
					  }
				}); 
			}
		
        });
		 
		var add_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#addForm').ajaxForm(add_options); 
		 
  	}); 
	
	$jqtips(document).ready(function() { 
		$jqtips('#org_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });     
		$jqtips('#box_code').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#box_name').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#length').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#width').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#height').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#weight').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 }); 
		$jqtips('#active_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});
	  
	function clear_tooltips(){
		$jqtips('#org_id').poshytip('hide'); 
		$jqtips('#box_code').poshytip('hide'); 
		$jqtips('#box_name').poshytip('hide');   
		$jqtips('#length').poshytip('hide');   
		$jqtips('#width').poshytip('hide');   
		$jqtips('#height').poshytip('hide');   
		$jqtips('#weight').poshytip('hide');  
		$jqtips('#active_date_picker').poshytip('hide'); 
		$jqtips('#ownership_id').poshytip('hide'); 
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
		else if(trim(f.box_code.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#box_code').poshytip('update', 'Please insert box code');
					$jqtips('#box_code').poshytip('show'); 
				});
				f.box_code.focus();
				return false;
		} 
		else if(trim(f.box_name.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#box_name').poshytip('update', 'Please insert box name');
					$jqtips('#box_name').poshytip('show'); 
				});
				f.box_name.focus();
				return false;
		} 
		else if(trim(f.length.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#length').poshytip('update', 'Please insert box length');
					$jqtips('#length').poshytip('show'); 
				});
				f.length.focus();
				return false;
		} 
		else if(trim(f.width.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#width').poshytip('update', 'Please insert box width');
					$jqtips('#width').poshytip('show'); 
				});
				f.width.focus();
				return false;
		} 
		else if(trim(f.height.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#height').poshytip('update', 'Please insert box height');
					$jqtips('#height').poshytip('show'); 
				});
				f.height.focus();
				return false;
		} 
		else if(trim(f.weight.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#weight').poshytip('update', 'Please insert box weight');
					$jqtips('#weight').poshytip('show'); 
				});
				f.weight.focus();
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
					$jqtips('#ownership_id').poshytip('update', 'Please select omnwership');
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
				window.parent.notify("success","Add Box","Box "+$("#box_code").val()+" is successfully add!","5000");  
				window.location.href='box.cfm';
				
		} else if(trim(responseArr[1]) == "failed"){
				window.parent.notify("error","Add Box",trim(responseArr[2]),"5000");
		}
	}
	 
	function validateInputNumber(fieldID,data) {
 
		clear_tooltips();
	 	if(isNaN(data)) {
				$jqtips(document).ready(function() {  
					$jqtips('#'+fieldID).val('');  
					$jqtips('#'+fieldID).poshytip('update', 'Please insert a valid number');
					$jqtips('#'+fieldID).poshytip('show'); 
					$jqtips('#'+fieldID).focus();
				});
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
		<div class="screen_header">General Master > Master Data > Box Master > Add </div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Add new box</div> 
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
								<select name="org_id" id="org_id" class="formStyle">
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
											<option value="#org_id#">#org_description#</option>
										</cfloop>
									</select> 
								</cfif> 
							</cfoutput>
							</td> 							
					  </tr>   
					  <tr>
						<td align="right" width="20%">Box Code : </td>
						<td align="left" width="25%"><input type="text" name="box_code" id="box_code" class="formStyle" size="20" onKeyDown="clear_tooltips();"></td> 
						<td align="right" width="25%">Box Name : </td>
						<td align="left" width="30%" ><input type="text" name="box_name" id="box_name" class="formStyle" size="40" onKeyDown="clear_tooltips();"></td>
					  </tr>
					   <tr>
						<td align="right" width="20%" >Measurement(mm) : </td>
						<td align="left" width="25%">
							<table cellpadding="0" cellspacing="0">
								<tr> 
									<td>
										<input type="text" name="length" id="length" class="formStyle" style="text-align:center" size="10" 
										  onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
									<td> x </td>
									<td>
										<input type="text" name="width" id="width" class="formStyle" style="text-align:center" size="10" 
										onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
									<td> x </td>
									<td>
										<input type="text" name="height" id="height" class="formStyle" style="text-align:center" size="10" 
										onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
								</tr>
								<tr> 
									<td align="center" style="font-style:italic; font-size:smaller">(length)</td>
									<td></td>
									<td align="center" style="font-style:italic; font-size:smaller">(width)</td>
									<td></td>
									<td align="center" style="font-style:italic; font-size:smaller">(height)</td>
								</tr>
							</table> 
						</td> 
						<td align="right" width="25%">Weight(g) : </td>
						<td align="left" width="30%" >
							<input type="text" name="weight" id="weight" class="formStyle" style="text-align:center" size="10" 
							onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
						</td>
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
							<input id="saveBtn" name="submit" type="button" class="button white" value="Save" />
							<input id="resetBtn" name="button" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
							<input id="closeBtn" name="button" type="button" class="button white" onClick="window.location.href='box.cfm'" value="Close" />
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








