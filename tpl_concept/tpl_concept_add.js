	var act_r = 0 ;
	var r = 0 ;
	var totalRow = 0;
	var totalCreatedRow = 0;
	
	   
	$(document).ready(function () {  
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false, showArrow: false, toggleMode: "none" });
		
				
		
			updateChildRows();	
			act_r = $("#actRowID").val();
			r = $("#actRowID").val();
			totalRow =  $("#actRowID").val();
			totalCreatedRow = $("#actRowID").val();
			

		
			<!------------------------------------- DATE PICKER ------------------------------------------>
		
		$(".inactive_date_picker").jqxDateTimeInput({width: '120px', height: '25px', textAlign: "center"});
		$(".inactive_date_picker").each(function(index, element){
				
			var pickerID = this.id.split("_");
			var x = pickerID[3]; 
			
			if($("#active_date_"+x).val() >= $("#getCurrDate").val()){  
				setMinDate($("#active_date_"+x).val(),this.id);
			}
			else{
			setMinDate('',this.id); 
			} 
		});
		setTimeout(function(){
			$(".inactive_date_picker").each(function(index, element){ 
			 	setDatePicker($(this).attr('val'),this.id);
			});
		},1);
		 
		<!--------------------------------- MAIN CONFIGURATIONS -------------------------------------->
		
		$("#tier").change(function(){
			getTierData();										
		});

		var edit_options = {   
		beforeSubmit: validateInput,
		success: showChangeResponse   
		}; 
		
		$('#addForm').ajaxForm(edit_options);
	 
		$("#closeBtn").click(function(e) { 
			window.parent.closeTab($("#tabid").val()); 
        });
		
		$("#resetBtn").click(function(e) { 
			window.location.href=self.location 
        });

		
				
		
		/*---------------------------------------------------------------------------*/
		 
		$("#TPL_menu").jqxMenu({ width: '20', height: '20px', rtl: true});
		$("#TPL_menu").css('visibility', 'visible');
		
		
		
		
		
		act_r = $("#actRowID").val();  
		if(act_r==0){
			addNewRow();
		}
			
		$("#addBtn").click(function(e) {
			addNewRow();
		}); 
 
		$("#showhistoryBtn").click(function(e) {
			$(".inactive_row").show();
			$("#showhistoryBtn").hide();
			$("#hidehistoryBtn").show(); 
		});
			
		$("#hidehistoryBtn").click(function(e) {
			$(".inactive_row").hide();
			$("#showhistoryBtn").show();
			$("#hidehistoryBtn").hide(); 
		});
			   
		$("#checkAll").change(function () {  
			$(this).closest("table").find('.rowCheckBox').attr("checked", this.checked).change(); 
			toogleRemoveBtn("chkrowid","removeBtn"); 
		});
			
		$("#removeBtn").click(function(){ 
			var checkRowIDArr = new Array();
			var y = 0;
			var checkBoxes = document.getElementsByName('chkrowid');
			for (var counter=0; counter < checkBoxes.length; counter++) {
				if (checkBoxes[counter].checked == true) { 
					var x =  checkBoxes[counter].value; 
					checkRowIDArr[y] = x;
					y++;
				}
			}
				  
			for (var c=1; c <= totalCreatedRow; c++) { 
				 if(checkRowIDArr.indexOf(""+c+"") >= 0){   
					$("#newRow_"+c).remove();
					totalRow--;    
				}
			} 
				 
			if(act_r==0 && totalRow<=0){ addNewRow(); }
			  
			$("#checkAll").attr("checked", false);
			toogleRemoveBtn("chkrowid","removeBtn");	 
			updateNewRowID("chkrowid","new_row_id"); 
				  
		}); 
		 
	});
	
	function toogleRemoveBtn(chkRowName,removeBtnID){ 
		$(document).ready(function(e) {  
			var y = 0; 
			var checkBoxes = document.getElementsByName(chkRowName);
			for (var counter=0; counter < checkBoxes.length; counter++) {
				if (checkBoxes[counter].checked == true) {  
					y++;
				}
			}
			if(y > 0) { $("#"+removeBtnID).show(); } else { $("#"+removeBtnID).hide(); }
		});
	}
	
	function updateNewRowID(chkRowName,newRowFieldID){ 
		$(document).ready(function(){ 
			var new_row_id = ''; 
			var checkBoxes = document.getElementsByName(chkRowName);
			for (var counter=0; counter < checkBoxes.length; counter++) { 
				var x =  checkBoxes[counter].value; 
				if(new_row_id == '')
					new_row_id = x;  
				else 
					new_row_id = new_row_id + ',' + x; 
			}
			$("#"+newRowFieldID).val(new_row_id);						 
		}); 
	}  
	
	 
 	function addNewRow(){ 
		$(document).ready(function(e) { 
			$('.borderRow').empty();   
			r++; 
			totalRow++;
			totalCreatedRow++;
			
			var rowpainter = "";  
			rowpainter = rowpainter  + '<tr class="newRow" id="newRow_'+r+'">'; 
			rowpainter = rowpainter  + '<td width="1" align="center"><input type="checkbox" name="chkrowid" class="rowCheckBox" id="rowCheckBox_'+r+'" value="'+r+'"></td>';    
            rowpainter = rowpainter  + '<td width="1" align="center"><img src="../../../includes/images/new.png"></td>';    
								
			//----- route		 
			rowpainter = rowpainter  + '<td align="center" style="padding-right:9px;">';
            rowpainter = rowpainter  + '<input type="text" class="formStyle groupcodes" size=13 name="group_code_'+r+'" ';
			rowpainter = rowpainter  + ' id="group_code_'+r+'" style=";text-align:center;"></td>';
			
			
			//----- description	
			rowpainter = rowpainter  + '<td align="center" style="padding-right:9px;">';
            rowpainter = rowpainter  + '<input type="text" class="formStyle " size=13 name="get_desc_'+r+'" ';
			rowpainter = rowpainter  + ' id="get_desc_'+r+'" style="text-align:center;"></td>';
			
			//-----	collection
			rowpainter = rowpainter  + '<td align="center" style="text-align:center;">'; 
			rowpainter = rowpainter  + '<select name="get_collection_'+r+'" id="get_collection_'+r+'" class="formStyle tips">';
            rowpainter = rowpainter  + '<option value="">-- Please Select --</option>';
			rowpainter = rowpainter  + '<option value="Y">Y</option>';
			rowpainter = rowpainter  + '<option value="N">N</option>';
			rowpainter = rowpainter  + '</select></td>';  
			
			                    
			//-----	handling
			rowpainter = rowpainter  + '<td align="center" style="text-align:center;">'; 
			rowpainter = rowpainter  + '<select name="get_handling_'+r+'" id="get_handling_'+r+'" class="formStyle tips">';
            rowpainter = rowpainter  + '<option value="">-- Please Select --</option>';
			rowpainter = rowpainter  + '<option value="Y">Y</option>';
			rowpainter = rowpainter  + '<option value="N">N</option>';
			rowpainter = rowpainter  + '</select></td>';  
			
			//-----	delivery
			rowpainter = rowpainter  + '<td align="center" style="text-align:center;">'; 
			rowpainter = rowpainter  + '<select name="get_delivery_'+r+'" id="get_delivery_'+r+'" class="formStyle tips">';
            rowpainter = rowpainter  + '<option value="">-- Please Select --</option>';
			rowpainter = rowpainter  + '<option value="Y">Y</option>';
			rowpainter = rowpainter  + '<option value="N">N</option>';
			rowpainter = rowpainter  + '</select></td>';  
			
			//----- active date
			 rowpainter = rowpainter  + '<td align="center" style="width:120;text-align:center;">'; 
			 rowpainter = rowpainter + '<div align="left">';
			 rowpainter = rowpainter + ' <div id="start_date_'+r+'" class="start_date"></div> </div></td>';
			 
			
  			//----- inactive date
			 rowpainter = rowpainter  + '<td align="center" style="width:120;text-align:center;">'; 
			 rowpainter = rowpainter + '<div align="left">';
			 rowpainter = rowpainter + '<div id="end_date_'+r+'"  class="end_date"></div></div></td>';    
			//-----
			rowpainter = rowpainter  + '<td width="30" align="center"><img src="../../../includes/images/grey_status.png"></td>';	
            rowpainter = rowpainter  + '</tr>'; 
							
			rowpainter = rowpainter  + '<tr class="boldstyle bgstyle1 borderRow">';
			rowpainter = rowpainter  + '<td align="right" colspan="15" style="height:2px;padding:0px;"></td></tr>';

							
			$('#TPLTable > tbody:last').append(rowpainter);  
			
			regTips('group_code_'+r);
			regTips('get_desc_'+r);
			regTips('get_collection_'+r);
			regTips('get_handling_'+r);
			regTips('get_delivery_'+r);
			regTips('start_date_'+r);
			regTips('end_date_'+r);

 							
		// ================  DATE PICKER =====================
		
			$(".start_date").jqxDateTimeInput({width: '120px', height: '25px'});  
			$(".end_date").jqxDateTimeInput({width: '120px', height: '25px'}); 
			
			setMinDate('','start_date_'+r);  
			setMinDate('','end_date_'+r);
			
			setTimeout(function(){ 
				//$('#start_date_'+r).jqxDateTimeInput('setDate',null);
				$('#end_date_'+r).jqxDateTimeInput('setDate',null);
			},1);
		 

			
			$("#rowCheckBox_"+r).click(function(e) { 
            	toogleRemoveBtn("chkrowid","removeBtn"); 
        	});  
			
			updateNewRowID("chkrowid","new_row_id"); 

        });
		 
	}  
	 
	function removeRow(curr_rID){
		$(document).ready(function(e) { 
			$("#newRow_"+curr_rID).remove();
			totalRow--;   
			if(act_r==0 && totalRow<=0){ addNewRow(); } 
			$("#checkAll").attr("checked", false);
			toogleRemoveBtn("chkrowid","removeBtn");	 
			updateNewRowID("chkrowid","new_row_id"); 
        });
	}
	
	function validateInput(formData, jqForm, options) {  
		
		var invalidDataCounter = 0; 
		 
		 
		$(".newRow").each(function(index, element) { 
        	var idArr = this.id.split("_");
			var r = idArr[1]; 
			
			if( ($("#group_code_"+r).val()).trim() == '' ){  
				showTips('group_code_'+r, 'Please insert group code', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			else if ( ($("#get_desc_"+r).val()).trim() == '' ){  
				showTips('get_desc_'+r, 'Please insert description', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			else if ( ($("#get_collection_"+r).val()).trim() == '' ){  
				showTips('get_collection_'+r, 'Please select collection', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			else if ( ($("#get_handling_"+r).val()).trim() == '' ){  
				showTips('get_handling_'+r, 'Please select handling', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			else if ( ($("#get_delivery_"+r).val()).trim() == '' ){  
				showTips('get_delivery_'+r, 'Please select delivery', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			else if ( ($("#start_date_"+r).val()).trim() == '' ){  
				showTips('start_date_'+r, 'Please start date', 1000);
				invalidDataCounter++; 
				return false;
			}
			else if ( 
						($("#end_date_"+r).val() != '') &&
					($("#end_date_"+r).val() < $("#start_date_"+r).val()+1)
						
						)
			{  
				showTips('end_date_'+r, 'Inactive date must be more than active date', 1000);
				invalidDataCounter++; 
				return false;
			}
			
			
        });
		 
		if(invalidDataCounter > 0 )
			return false;
		else 
			return true; 
		
	}

	
	
	function showChangeResponse(responseText, statusText, xhr, $form)  {  
 
		var responseArr = responseText.split("~~");   
 
		if(responseArr[1]== "success"){	
			window.parent.notify("success","TPl Cost Elements","TPl Cost Elements successfully updated","3000");
			window.location.href=self.location  
		}  
		else { 
			window.parent.notify("error","TPl Cost Elements",responseArr[2],"3000");
			return false;
		}
	}
	
	
	
	
		
	
	
		function toggleDisplay(tableID){
			$(document).ready(function(e) { 
			
			 $jqeff(".resultDetail"+tableID).toggle();   
			 $jqeff("#up"+tableID).toggle();  
			 $jqeff("#down"+tableID).toggle();   
				
			collapeTheRest(tableID);
				            
			});
		}  
		
		function collapeTheRest(tableID){
			$(document).ready(function(e) { 
			
			
			 for (var t = 1; t <= act_r; t++){
					if (t != tableID){	
						 $jqeff(".resultDetail"+t).hide(); 
						 $jqeff("#up"+t).hide(); 
						 $jqeff("#down"+t).show();
					}
				}
				            
			});
		} 
		
<!------------------------------------- CHILD FUNCTIONS ------------------------------------------>		


	$(document).ready(function () {  
		
		
			var isRowInitialized = false;
		
			if(isRowInitialized == false){
				for(var rowID=0;rowID<=act_r;rowID++){
					
				$("#childBar_menu_"+rowID).jqxMenu({ width: '20', height: '20px', rtl: true});
				$("#childBar_menu_"+rowID).css('visibility', 'visible');		

					
						
				}
				isRowInitialized = true;
		
			}

	});
	
function toggleHistoryBtn(hID){	
	
	$(document).ready(function(e) {
		

		var getHistoryID = hID.split("_"); 
		
			$("#showchildhistoryBtn_"+getHistoryID[1]).click(function(e) {
				$(".childinactive_row_"+getHistoryID[1]).show();
				$("#showchildhistoryBtn_"+getHistoryID[1]).hide();
				$("#hidechildhistoryBtn_"+getHistoryID[1]).show(); 
			});
				
			$("#hidechildhistoryBtn_"+getHistoryID[1]).click(function(e) {
				$(".childinactive_row_"+getHistoryID[1]).hide();
				$("#showchildhistoryBtn_"+getHistoryID[1]).show();
				$("#hidechildhistoryBtn_"+getHistoryID[1]).hide(); 
			});
	});
}

function changeStatus(childStatusID){
	$(document).ready(function(e) {
		var tempArr = childStatusID.split("_");
		var getStatus = tempArr[2]+'_'+tempArr[3];
     
		
		if( $("#status_"+tempArr[2]+'_'+tempArr[3]).val() == 'Y' ) { 
				$("#childRow_"+tempArr[2]+'_'+tempArr[3]).removeClass('active_row_style').addClass('lock_row_style');
				$("#act_switchBtn_"+tempArr[2]+'_'+tempArr[3]).attr('src','../../../includes/images/switch_red.png')
				$("#flag_"+tempArr[2]+'_'+tempArr[3]).attr('src','../../../includes/images/inactive.png')
				$("#status_"+tempArr[2]+'_'+tempArr[3]).val('N') 
			} 
			else { 
				$("#childRow_"+tempArr[2]+'_'+tempArr[3]).removeClass('lock_row_style').addClass('active_row_style');
				$("#act_switchBtn_"+tempArr[2]+'_'+tempArr[3]).attr('src','../../../includes/images/switch_on.png')
				$("#flag_"+tempArr[2]+'_'+tempArr[3]).attr('src','../../../includes/images/active.png')
				$("#status_"+tempArr[2]+'_'+tempArr[3]).val('Y') 
			}
		
    });		
}



function openLookupVendor(rowId) {
				  
					var tier = $("#tier").val();
					var org_id = $("#org_id").val();
					var lookupID = ($("#lookupID").val()).trim();
					
					var lookupFile = 'lookupVendorList.cfm?tier='+tier+'&org_id='+org_id+'&rowid='+rowId+'&lookupID='+lookupID;
					
					document.getElementById('lookupContent').src=lookupFile; 
						$('#lookupWindow').jqxWindow({ 
							maxHeight: 450, maxWidth: 800, 
							minHeight: 350, minWidth: 700, 
							height: 250, width: 700, 
							resizable: true,
							isModal: true,
							modalOpacity:0.1,
							showAnimationDuration: 0,
							closeAnimationDuration: 0
						});  
						$('#lookupWindow').jqxWindow('open');  
}
				
			
				var readyStateCheckInterval = setInterval(function() {
					if (document.readyState == "complete") { 
							$('#lookupProgress').hide();
							$('#lookupGrid').show();			 
							clearInterval(readyStateCheckInterval);
					}
				}, 
				10);
			

					


function addChildRow(vn,vid,dc,route,dt,tid,dtid,lookupID,parentID,tpl_name){
	
	$(document).ready(function() {
		var getTR = $("#totalRow_"+parentID).val();
		
		var getDetailsID = $("#tpl_id_"+parentID).val();

		getTR++
		$("#totalRow_"+parentID).val(getTR);
		
			var childpainter = ""; ;
				
			childpainter = childpainter  + '<tr class="newChildRow" id="newChildRow_'+parentID+'_'+getTR+'">';

			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + ' <input type="hidden" name="childrowid" id="childrowid+'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'value="'+parentID+'_'+getTR+'" class="childrowid"> <img  src="../../../includes/images/new.png">'; 
			
			childpainter = childpainter  + ' <input type="hidden" id="lookupID_'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'name="lookupID_'+parentID+'_'+getTR+'" value="'+lookupID+'" class="lookupID">';
			
			childpainter = childpainter  + ' <input type="hidden" id="getDetailsID_+'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'name="getDetailsID_'+parentID+'_'+getTR+'" value="'+getDetailsID+'" >'

			
			childpainter = childpainter  + ' <input type="hidden" id="tplID_+'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'name="tplID_'+parentID+'_'+getTR+'" value="'+tid+'" >'
			
			childpainter = childpainter  + ' <input type="hidden" id="vendor_id_+'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'name="vendor_id_'+parentID+'_'+getTR+'" value="'+vid+'" >'
			
			childpainter = childpainter  + ' <input type="hidden" id="deliveryID_+'+parentID+'_'+getTR+'"'; 
			childpainter = childpainter  + 'name="deliveryID_'+parentID+'_'+getTR+'" value="'+dtid+'" >'
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<input type="text" readonly class="formStyleReadOnly " size=40 name="vendor_name_'+parentID+'_'+getTR+'" ';
			childpainter = childpainter  + ' id="vendor_name_'+parentID+'_'+getTR+'" style="text-align:center;" value="'+vn+'"></td>'; 
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<input type="text" readonly class="formStyleReadOnly " size=10 name="d_category_'+parentID+'_'+getTR+'" ';
			childpainter = childpainter  + ' id="d_category_'+parentID+'_'+getTR+'" style="text-align:center;" value="'+dc+'"></td>'; 
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<input type="text" readonly class="formStyleReadOnly " size=10 name="get_route_'+parentID+'_'+getTR+'" ';
			childpainter = childpainter  + ' id="get_route_'+parentID+'_'+getTR+'" style="text-align:center;" value="'+route+'"></td>'; 
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<input type="text" readonly class="formStyleReadOnly " size=10 name="d_type_'+parentID+'_'+getTR+'" ';
			childpainter = childpainter  + ' id="d_type_'+parentID+'_'+getTR+'" style="text-align:center;" value="'+dt+'"></td>'; 
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<input type="text" readonly class="formStyleReadOnly " size=40 name="tpl_name_add_'+parentID+'_'+getTR+'" ';
			childpainter = childpainter  + ' id="tpl_name_add_'+parentID+'_'+getTR+'" style="text-align:center;" value="'+tpl_name+'"></td>'; 
			childpainter = childpainter  + '</td>'; 
			
			childpainter = childpainter  + '<td align="center" style="text-align:center;">';
			childpainter = childpainter  + '<img src="../../../includes/images/switch_on.png" id="switchBtn_'+parentID+'_'+getTR+'" width="45" ';
			childpainter = childpainter  + 'height="18" style="margin-top:3px;cursor:pointer" onClick="removeRows(this.id)">';
			childpainter = childpainter  + '</td></tr>'; 
				
			$('#childtable_'+parentID+' > tbody:last').append(childpainter);
			
			
			updateChildRows();
		
			
	});
}



function removeRows(getID){
	
	$(document).ready(function(e) {
		var tempArr = getID.split("_");
		var getStatus = tempArr[1]+'_'+tempArr[2];
     	var setTR = $("#totalRow_"+tempArr[1]).val();

		$("#newChildRow_"+tempArr[1]+'_'+tempArr[2]).remove();

		setTR--
		$("#totalRow_"+tempArr[1]).val(setTR);
		updateChildRows();
	});
}


function updateChildRows(){
	$(document).ready(function(e) {
						
		var new_child_row = ''; 
		var filterLookUp = '';
		
			$(".childrowid").each(function(index, element){

					if(new_child_row == '')
					{
						new_child_row = this.value;  
					}
					
					else
					{
						new_child_row = new_child_row + ',' + this.value;
					}
			});
			
			$(".lookupID").each(function(index, element){

					if(filterLookUp == '')
					{
						filterLookUp = this.value;
					}
					
					else
					{
						filterLookUp = filterLookUp + ',' + this.value;
					}
			});
			
			$(".routes_id").each(function(index, element){

					if(filterLookUp == '')
					{
						filterLookUp = this.value;
					}
					
					else
					{
						filterLookUp = filterLookUp + ',' + this.value;
					}
			});
								
					$("#new_child_row").val(new_child_row);
					$("#lookupID").val(filterLookUp);
					//alert(new_child_row);
	       
    });
}


