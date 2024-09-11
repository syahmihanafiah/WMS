var grid_init = false; 

$(document).ready(function () {  
	$jqtips(document).ready(function() { 
	$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});	
		$("#UIPanel").jqxExpander({ width: '100%', disabled: false });
		
				$("#org_id").change(function(e) {
					  if( $("#org_id").val() == '' ){
						  $("#route_group_header_id").val('');
						  $("#route_group").val('');
						  $("#route_group").removeClass('formStyle').addClass('formStyleReadOnly');
						  $("#route_group").attr('readOnly',true);
						  $("#lookupRGBtn_disabled").show();
						  $("#lookupRGBtn").hide();
					  }
					  else {
						  $("#route_group_header_id").val('');
						  $("#route_group").val('');
						  $("#route_group").removeClass('formStyleReadOnly').addClass('formStyle');
						  $("#route_group").attr('readOnly',false);
						  $("#lookupRGBtn_disabled").hide();
						  $("#lookupRGBtn").show();
					  }
				 });
				 setTimeout(function(){ 
					 if( $("#org_id").val() == '' ){
						  $("#route_group_header_id").val('');
						  $("#route_group").val('');
						  $("#route_group").removeClass('formStyle').addClass('formStyleReadOnly');
						  $("#route_group").attr('readOnly',true);
						  $("#lookupRGBtn_disabled").show();
						  $("#lookupRGBtn").hide();
					  }
				 },100); 
				 
				 $("#route_group").keyup(function(e) {
					 $("#route_group_header_id").val('')
				 });
				 
				 $("#tpl_id").keyup(function(e) {
					 $("#tpl_name").val('')
				 });

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
				
				$(".lookupRGBtn").click(function(e) { 
		  
					var f1 = $(this).attr('field1');
					var f2 = $(this).attr('field2');
					var lookupStr = trim($("#" + $(this).attr('lookupField') ).val());
					lookupStr = lookupStr.replace('&','chr38');
					var lookupFile = '../../../includes/lookup/routegroup.cfm?prefix=RG&org_id='+$("#org_id").val()+'&field1='+f1+'&field2='+f2+'&lookupStr='+lookupStr;
					document.getElementById('lookupRGContent').src=lookupFile; 
					
					$('#lookupRGWindow').jqxWindow({ 
						maxHeight: 600, maxWidth: 600, 
						minHeight: 400, minWidth: 400, 
						height: 500, width: 500, 
						resizable: true,
						isModal: true,
						modalOpacity:0.1,
						showAnimationDuration: 0,
						closeAnimationDuration: 0
					});  
					$('#lookupRGWindow').jqxWindow('open'); 
					 
				});
				
				$("#searchBtn").click(function(){
					
					if( $("#org_id").val() == '' ){
						showTips("org_id", "Please select an organization", 1000);
					}
					/*else if( $("#tpl_name").val() == ''){ 
						showTips("lookupTPLBtn","Please select a transporter",1000);
						return false	
					}
					else if( $("#tpl_name").val() != '' && $("#tpl_id").val() == ''){ 
						showTips("lookupTPLBtn","Invalid transporter",1000);
						return false	
					}
					else if( $("#route_group").val() == "" ){ 
						showTips("lookupRGBtn","Please select route group",1000);
						return false	
					}*/
					else {
					$("#datagrid").jqxGrid("clearfilters");
					getData();
					}
				});
								
				$("#addBtn").click(function(){				
	 				  if($("#org_id").val()==''){
						  showTips('org_id','Please select an organization',1000);	
					  }
					  else if($("#ownership_id").val() == ''){
						showTips('ownership_id','Please select an ownership',1000);
						return false;
					  }
						else if( $("#tpl_name").val() == ''){ 
							showTips("lookupTPLBtn","Please select a transporter",1000);
							return false	
						}
						else if( $("#tpl_name").val() != '' && $("#tpl_id").val() == ''){ 
							showTips("lookupTPLBtn","Invalid transporter",1000);
							return false	
						}
					  else if( $("#route_group").val() == "" ){ 
						showTips("lookupRGBtn","Please select route group",1000);
						return false	
					  }
					  else if($("#route_group").val() != '' && $("#tier").val() == ''){ 
						showTips("tier","Please select tier",1000);
						return false	
					  }
					  else {
						checkIfExist();	
					  }
 				});
				
				$("#reset").click(function() {	 
					window.location.href=self.location
				});			
		   
	}); 
	
	
	function checkIfExist(){
		$(document).ready(function(e) {
             $.ajax({
				type: 'POST',
				url: 'bgprocess.cfm',
				data: 
				{
					route_group_header_id:$("#route_group_header_id").val(), 
					tier:$("#tier").val(), 
					org_id:$("#org_id").val(), 
					tpl_id:$("#tpl_id").val(), 
					action_flag:'checkIfExist'
				}, 
				success:function(data){ 
					var responseArr = data.split("~~"); 
					
					var filePath = '../systems/general_master/master_data/trans_route/';
					if(trim(responseArr[1]) >= 1 && trim(responseArr[2]) == $("#tier").val()){	
						alert(trim(responseArr[1])); alert(trim(responseArr[2]));
						var fullPath = filePath + 'trans_route_add.cfm?org_id='+$("#org_id").val()+'&route_group_header_id='+$("#route_group_header_id").val()
												+ '&tpl_id='+$("#tpl_id").val()+'&tier='+$("#tier").val()+'&route_group='+$("#route_group").val()+'&type=edit';
							  
						window.parent.openNewTab('Transportation Route (Edit)',fullPath,$("#fID").val());						
					} 
					else if (trim(responseArr[1]) >= 1 && trim(responseArr[2]) != $("#tier").val()){
						window.parent.notify("error","Transportation Route",'Route Group already exist in Tier '+trim(responseArr[2]),"3000");	
					} 
					else{
						var fullPath = filePath + 'trans_route_add.cfm?org_id='+$("#org_id").val()
						+'&route_group_header_id='+''+'&tier='+$("#tier").val()+'&tpl_id='+$("#tpl_id").val()+'&route_group='+$("#route_group").val()+'&type=add'+'&ownership_id='+$("#ownership_id").val();
						
						window.parent.openNewTab('Transportation Route (Add)',fullPath,$("#fID").val());
					} 
				},
				error:function(){ 
					window.parent.notify("error","Transportation Route",'Error while processing your request',"3000");
				}
			});  
        });	
	}
		
	

	function getData(){

	 	$(document).ready(function () {
			
		
		
            var source =
            { 
               
                datatype: "json", 
                datafields: [  
					 { name: 'route_group_header_id', type: 'number' },
					 { name: 'org_id', type: 'integer' },					 
					 { name: 'org_description', type: 'string'},
					 { name: 'ownership_id', type: 'integer'},
					 { name: 'ownership_name', type: 'string'},
					 { name: 'tpl_id', type: 'integer' },
					 { name: 'tpl_name', type: 'string' },
					 { name: 'route_group', type: 'string'},
					 { name: 'total_sub_group', type: 'number'},
					 { name: 'tier', type: 'integer' },
					 { name: 'trans_type', type: 'string' },
					 { name: 'status', type: 'string'},					 
					 { name: 'creation_date', type: 'date'},
					 { name: 'creation_by', type: 'string'},
					 { name: 'updated_date', type: 'date'},
					 { name: 'last_updated_by', type: 'string'},
					 { name: 'status_img', type: 'string' }
					 
                ], 
				
                cache: false,  
                url: 'bgprocess.cfm',   
				data: {   
					target:'grid', //search bg process
					action_flag:'search_rt' ,
					org_id:$("#org_id").val(), 
					ownership_id:$("#ownership_id").val(), 
					tpl_id:$("#tpl_id").val(),
					route_group:($("#route_group").val()).trim(),
					status:$("#status").val()
					
				},
				pagesize: 20,
                root: 'Rows',   
				beforeprocessing: function (data) {    
                    source.totalrecords = data[0].TotalRows;
                }, 
                sort: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'sort'); //grind name
                }, 
                filter: function () { 
                    $("#datagrid").jqxGrid('updatebounddata', 'filter');
					//$("#datagrid").jqxGrid('refreshdata', 'filter');
                }
				
            }; 
		   
		   var editimagerenderer = function (row, datafield, value) {
				var editicon = "<div align='center' style='padding:2px; vertical-align:middle;'>";
				
				if(value == 'ACTIVE'){
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil.png' >";
				}
				else {
				editicon = editicon + 		"<img style='cursor:pointer; margin: 3px;' src='../../../includes/images/pencil_disabled.png' >";
				}
				editicon = editicon + 	"</div>";
				return editicon;
			};
		   
            var dataadapter = new $.jqx.dataAdapter(source);
			
			
            $("#datagrid").jqxGrid(
            {	
                width: '100%',
                source: dataadapter,  
				autoheight: true,	 
				columnsresize: true,
                pageable: true,
				selectionmode: 'none',
                virtualmode: true,
				sortable: true, 
				sorttogglestates: 1,
                filterable: true, 
				altrows: true, 
                enablebrowserselection: true, 

				 
				showtoolbar: true, 
				rendertoolbar: function (toolbar) {  
					if ($('#toolbardiv').length == 0) {	 
						var container = $("<div id='toolbardiv' style='margin: 5px;'></div>");
						var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px;font-size:11px; font-weight:bold;'>Search Result</span>");   
						toolbar.append(container);
						container.append(span);   
					}
				},
		  
                rendergridrows: function (params) {   
                    return params.data;
                } , 
                columns: [  
					
					{ text: 'Organization', datafield: 'org_description', align: 'left', cellsalign: 'left', minwidth: 180 },
					{ text: 'Ownership ID', datafield: 'ownership_id', align: 'left', cellsalign: 'left', minwidth: 180 ,hidden:true},
					{ text: 'Ownership', datafield: 'ownership_name', align: 'left', cellsalign: 'left', minwidth: 180 },
					{ text: 'Transporter', datafield: 'tpl_name', width:220, align: 'left', cellsalign: 'left'},
					{ text: 'Route Group', datafield: 'route_group', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'Total Sub Group', datafield: 'total_sub_group', width:140, align: 'center', cellsalign: 'center'},
					{ text: 'Trans Type', datafield: 'trans_type', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Status', datafield: 'status', width:100, align: 'center', cellsalign: 'center'},
					{ text: 'Created Date', datafield: 'creation_date', cellsformat: 'dd/MM/yyyy hh:mm:ss tt', width:170, align: 'center',
						cellsalign: 'center' }, 
					{ text: 'Created By', datafield: 'creation_by', width:130, align: 'center', cellsalign: 'center' },
					{ text: 'Updated Date', datafield: 'updated_date', 
					   cellsformat: 'dd/MM/yyyy hh:mm:ss tt', align: 'center', cellsalign: 'center', width: 150  },
					{ text: 'Updated By', datafield: 'last_updated_by', align: 'center', cellsalign: 'center', width: 100 },
					{ hidden: 'route_group_header_id', datafield: 'route_group_header_id'},{ hidden: 'org_id', datafield: 'org_id'},
					{ hidden: 'tpl_id', datafield: 'tpl_id'},{ hidden: 'tier', datafield: 'tier'},
					{ text: 'Edit', datafield: 'status_img', cellsrenderer:editimagerenderer, pinned: true, align:'center', cellsalign: 'center', sortable: false, filterable: false, exportable: false, width: 50 }          
					
                 ]  
            }); 
			
			
	if(grid_init == false ){								
		
		$("#datagrid").on('cellclick', function (event) {  
				//--> check for clicked column by its title, and opened the new screen while passing data/id
				var column = $("#datagrid").jqxGrid('getcolumn', event.args.datafield).text;
				var status = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'status');

				
				if(column == 'Edit' && status == 'ACTIVE') { 
				  
					var org_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'org_id');
					var route_group_header_id  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'route_group_header_id'); 
					var tpl_id  = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'tpl_id');
					var route_group = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'route_group');
					var tier = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'tier');
					var ownership_id = $("#datagrid").jqxGrid('getcellvalue', event.args.rowindex, 'ownership_id');				

					var filePath =  '../systems/general_master/master_data/trans_route/';
						  
					var fullPath = filePath + 'trans_route_add.cfm?org_id='+org_id+'&route_group_header_id='+route_group_header_id+'&tpl_id='+tpl_id+'&tier='+tier+'&route_group='+route_group+'&type=edit'+'&ownership_id='+ownership_id;
						  
					window.parent.openNewTab('Transportation Route (Edit)',fullPath,$("#fID").val());
					 
				} 
				
			}); 	
	}
		}); 
	  grid_init = true;
	}
