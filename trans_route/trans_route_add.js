/*
  Suite         : EMCT
  Purpose       : Initial Creation 

  Version    Developer    		Date            Remarks
  2.0.00     Yusrah         	04/12/2020     	Add Transportation Route
*/

var currRow = 0;
var totalCreatedRow = 0;

$(document).ready(function(e) {
	 //--> this features allow panel to collapse or expand to get more space 
	$("#UIPanel").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false  }) 
	
	//--> START (FLOATING BUTTONS) ANIMATIONS
		$jqeff("#addFloatBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/add_round_green.png');
		}); 
		$jqeff("#addFloatBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/add_round_dimmed.png');
		});
		
		$jqeff("#removeFloatBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/dustbin_orange.png');
		}); 
		$jqeff("#removeFloatBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/dustbin_dimmed.png');
		});
		
		$jqeff("#saveBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/save.png');
		}); 
		$jqeff("#saveBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/save_dimmed.png');
		});
		
		$jqeff("#resetBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/reset_blue.png');
		}); 
		$jqeff("#resetBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/reset_dimmed.png');
		});
		
		$jqeff("#closeBtn").mouseenter(function() { 
		 	 $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		 	 $(this).attr("src",'../../../includes/images/close_round_red.png');
		}); 
		
		$jqeff("#closeBtn").mouseout(function() { 
		 	 $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		 	 $(this).attr("src",'../../../includes/images/close_round_dimmed.png');
		});
	//--> END (FLOATING BUTTONS) ANIMATIONS
	
	
	// ---> load edit
	if($("#action_flag").val() == 'edit'){
		$(".edit").each(function(index, element) {
            $(this).val($(this).attr('edit_value')).removeClass('formStyle').addClass('formStyleReadOnly').attr('disabled',true);
        });
	}
	if($("#action_flag").val() == 'add'){
		addNewRow();
		$("#group_status").attr("disabled",true);
	}
	
	$(".lookupTPLBtn").click(function(e) { 
		  
		  var f1 = $(this).attr('field1');
		  var f2 = $(this).attr('field2');
		  var lookupStr = trim($("#" + $(this).attr('lookupField') ).val());
		  lookupStr = lookupStr.replace('&','chr38');
		  var lookupFile = '../../../includes/lookup/transporter.cfm?prefix=TPL&field1='+f1+'&field2='+f2+'&lookupStr='+lookupStr;
		  document.getElementById('lookupTPLContent').src=lookupFile; 
		  
		  $('#lookupTPLWindow').jqxWindow({ 
			  maxHeight: 600, maxWidth: 600, 
			  minHeight: 400, minWidth: 400, 
			  height: 500, width: 500, 
			  resizable: true,
			  isModal: true,
			  modalOpacity:0.1,
			  showAnimationDuration: 0,
			  closeAnimationDuration: 0
		  });  
		  $('#lookupTPLWindow').jqxWindow('open'); 
		   
	  });
	
	//--> Submit Form on save button
	$("#saveBtn").click(function(e) {
		if($("#group_status").val() == 'N'){
			confirmBox( 'Inactive this Route group, all sub-groups will be auto inactive as well! Proceed?', function(){ $("#addForm").submit(); });	
		}
		else{
			confirmBox( function(){$("#addForm").submit();}); //--> Submit Form
		}
	});
	
	$("#route_group").blur(function(){
    	$("#route_group").val(trim(this.value.toUpperCase()))
    });
	
	$(".sub_group").blur(function(){
    	$(".sub_group").val(trim(this.value.toUpperCase()))
    });
	
	
	/* Validation and Response on form submit (START)*/
	var add_options = {   
	beforeSubmit: validateInput,
	success: showChangeResponse   
	}; 
	$('#addForm').ajaxForm(add_options);
	/* Validation and Response on form submit (END)*/
	
	
	$("#resetBtn").click(function(e) {
		window.location.href=self.location; //--> Reload current screen
	});
	
	$("#closeBtn").click(function(e) {
		window.parent.closeTab($("#tabid").val()); //--> Close current tab (Must define TAB ID)
	});
	
	/*------------------------------- JQX MENU (START)------------------------------------*/
	$("#TransRouteMenu").jqxMenu({ width: '20px', height: '20px', rtl: true}); //--> JQX MENU INITILIZATION
	$("#TransRouteMenu").css('visibility', 'visible'); //--> JQX MENU INITILIZATION

	currRow = $('#totalRows').val(); //--> get latest row to assign as ID on new rows
	
	
	//--> Add new row button in the configuration (gear)
	$("#addBtn").click(function(e) {
		addNewRow(); //-->Initialize new row
		//$("html, body").animate({ scrollTop: $(document).height() }, 1000); //-->Scroll the the page to bottom if scroll bar are available
	}); 
	
	//--> Add new row button in the configuration (gear) (FLOAT BUTTON)
	$("#addFloatBtn").click(function(e) {
		addNewRow(); //-->Initialize new row
		$("html, body").animate({ scrollTop: $(document).height() }, 1000); //-->Scroll the the page to bottom if scroll bar are available
	}); 
	
	//--> History button in the configuration (gear) icon (To show history if available)
	$("#showhistoryBtn").click(function(e) {
		$(".inactive_row").show();
		$("#showhistoryBtn").hide();
		$("#hidehistoryBtn").show(); 
	});
	
	//--> History button in the configuration (gear) icon (To hide history if available)	
	$("#hidehistoryBtn").click(function(e) {
		$(".inactive_row").hide();
		$("#showhistoryBtn").show();
		$("#hidehistoryBtn").hide(); 
	});
	
	$(".switchBtn").click(function(e) {  
		var getID = this.id.split("_");
		switchControl(getID[1]);
	});
	/*------------------------------- JQX MENU (END)------------------------------------*/
	
});

	//-->Create new rowsss
	function addNewRow(){ 
		$(document).ready(function(e) { 
		
			currRow++;  //--> set new row
			totalCreatedRow++;  //--> update created rows
			
			//--> Create row painter based on total column defined 
			var rowpainter = '';
				rowpainter = '<tr id="RowID_'+currRow+'" class="newRow" >'; 
				rowpainter = rowpainter + '<td align="center" ><img src="../../../includes/images/new.png"></td>';
				
				rowpainter = rowpainter + '<td align="center" ><input type="text" name="sub_route_group_'+currRow+'" id="sub_route_group_'+currRow+'"';
				rowpainter = rowpainter + 'class="formStyle sub_group" size="45" value="" currRowID="'+currRow+'"></td>';
								
				rowpainter = rowpainter + '<td align="center">';
				rowpainter = rowpainter + '<img src="../../../includes/images/switch_on.png" id="switchBtn_'+currRow+'" width="45" ';
				rowpainter = rowpainter + 'height="18" style="margin-top:3px;cursor:pointer" class="switchBtn">'; 
				rowpainter = rowpainter + '</td>'; 
				rowpainter = rowpainter + '</tr>';
			
			//--> Append row painter to table after the last row	
			$('#rowPainter > tbody:last').append(rowpainter);  
			
			/*Each appended rows using rowpainter will need to initialize they functinality */
			//-->  Set switch button functionality
			$("#switchBtn_"+currRow).click(function(e) { 
				var getID =  this.id.split("_");
				removeRow(getID[1]);
            });
			
			$("#sub_route_group_"+currRow).blur(function(){
    			$("#sub_route_group_"+$(this).attr("currRowID")).val(trim(this.value.toUpperCase()))
    		});
			
			
			regTips('sub_route_group_'+currRow); //--> Register Show Tips *Optional - Only use if you need a validation*
			//--> Toggle remove button on change
			$("#sub_route_group_"+currRow).keyup(function(e) { 
				if(trim(this.value) == ''){
					showTips(this.id,'Please insert a sub route group!', 3000);//--> Call showTips for validation (Please refer to Framework Tools)	
				}
            });
			
			
			
			updateRowList(); //--> Update Row List for submition
			
		});
	}
	
	
	
	
	function switchControl(getID){
		$(document).ready(function(e) {
			
            if($('#status_'+getID).val() == 'ACTIVE'){
				$("#RowID_"+getID).removeClass('active_row_style');
				$("#RowID_"+getID).addClass('inactive_row_style');
				$("#flag_"+getID).attr('src','../../../includes/images/inactive.png');
				$("#switchBtn_"+getID).attr('src','../../../includes/images/switch_red.png');	
				$('#status_'+getID).val('INACTIVE');
			}
			else{
				$("#RowID_"+getID).removeClass('inactive_row_style').addClass('active_row_style');
				$("#flag_"+getID).attr('src','../../../includes/images/active.png');
				$("#switchBtn_"+getID).attr('src','../../../includes/images/switch_on.png');	
				$('#status_'+getID).val('ACTIVE');
				
				
			}
        });	
	}
	
	function removeRow(getID){
		$(document).ready(function(e) { 
			$("#RowID_"+getID).remove();
			
			totalCreatedRow--;   //--> Update total created rows value
			if(totalCreatedRow<=0 && $(".active_row").length == 0){ addNewRow(); } 
			updateRowList(); //--> Update Row List for submition
        });
	}
	
	function updateRowList(){
		$(document).ready(function(e) {
            var newRowList = '';
			
			 //-->Loop through each new rows
			$(".newRow").each(function(index, element) {
				var getID = this.id.split("_");
                if(newRowList ==''){
					newRowList = getID[1];	
				}
				else{
					newRowList = newRowList + ',' + getID[1];	
				}
            });
			 //--> Store all new rows ID into a list of value
			$("#newRowList").val(newRowList);
        });	
	}
	
	//--> Validation on form submit
	function validateInput(formData, jqForm, options) { 
		var invalidDataCounter = 0; 
		  
		//--> Loop through each new created rows  
		$(".newRow").each(function(index, element) { 
        	var idArr = this.id.split("_");
			var r = idArr[1];
			if( ($("#route_group").val()).trim() == '' ){  
				showTips('route_group', 'Please insert route group!', 3000);
				invalidDataCounter++; 
				return false;
			}
			else if($("#tier").val()==''){  
				showTips('tier', 'Please select a tier!', 3000);
				invalidDataCounter++; 
				return false;
			}
		    else if( ($("#sub_route_group_"+r).val()).trim() == '' ){  
				showTips('sub_route_group_'+r, 'Please insert sub route group!', 3000);
				invalidDataCounter++; 
				return false;
			}
        });
		 
		//--> Return false or proceed to submit based on validation results
		if(invalidDataCounter > 0 ){
			confirmBox_close(); //--> Close confirmbox
			return false;
		}
		else { 
			return true; 
		}
		
	}
	
	//--> Submitted forms results
	function showChangeResponse(responseText, statusText, xhr, $form)  {  
		var responseArr = responseText.split("~~");   
		var ownership_id = responseArr[5];
		
		if(responseArr[1]== "success"){	
			if(responseArr[4] == 'Y'){
				window.parent.notify("success","Transportation Route","Transportation route are successfully updated","3000");
				window.parent.closeTab($("#tabid").val()); 
			}
			else{
				window.parent.notify("success","Transportation Route","Transportation route are successfully updated","3000");
				window.location.href='trans_route_add.cfm?org_id='+$("#org_id").val()+'&route_group_header_id='+responseArr[3]+'&tpl_id='+$("#tpl_id").val()+'&tier='+$("#tier").val()+'&route_group='+$("#route_group").val()+'&tabid='+$("#tabid").val()+'&type=edit'+'&ownership_id='+ownership_id;  
			}
		}  
		else { 
			window.parent.notify("error","Transportation Route",responseArr[2],"3000");
			confirmBox_close(); //--> Close confirmbox
			return false;
		}
	}