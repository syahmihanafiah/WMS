/*
  Suite         : LOCAL PART IMPROVEMENT
  Purpose       : 

  Version    Developer    		Date            Remarks
  1.0.00     Syahmi         	2/1/2024     	 
*/
var allData = [];
$(document).ready(function () {
  var edit_options = {
    beforeSubmit: edit_showRequest,
    success: edit_showResponse,
  };
  $("#editForm").ajaxForm(edit_options);
  setTimeout(() => {
    $(".uiBreadcrumb").text(
      "Warehouse Management System > LSP > Inventory > Opening Stock Upload (Vendor)"
    );
  }, 500);

  $(".gridBtn").click(function (e) {
    $("#searchPanel").slideDown("slow");
  });
  $("#uploadBtn").click(function (e) {
    var org_id = $("#org_id").val();
    var vendor_id = $("#vendor_id").val();
    var vendor_name = $("#vendor_name").val();
    if (org_id != "" && vendor_name != "") {
      var filePath =
        "../systems/lsp/inventory/upload_opening_stock_vendor/upload_op_st_vendor_verify.cfm?org_id=" +
        $("#org_id").val();
      filePath +=
        "&vendor_id=" +
        $("#vendor_id").val() +
        "&vendor_name=" +
        $("#vendor_name").val();
      window.parent.openNewTab(
        "Opening Stock Upload (Verification)",
        filePath,
        1
      );
      var form = document.getElementById("uploadForm");
      var inputFields = form.getElementsByTagName("input");
      $("#vendor_id").val("");
      for (var i = 0; i < inputFields.length; i++) {
        var input = inputFields[i];
        if (
          input.type !== "submit" &&
          input.type !== "button" &&
          input.type !== "hidden"
        ) {
          input.value = "";
        }
      }
    } else {
      if (org_id == "") {
        window.parent.fw_notify("error", "Please Pick Organization");
        showTips("org_id", "Please Insert Organization!");
      } else {
        window.parent.fw_notify("error", "Please Pick Vendor");
        showTips("vendor_name", "Please Insert Vendor!");
      }
    }
  });
  $("#searchBtn").click(function () {
    if (!compulsaryValidation("uploadForm")) {
      return false;
    } else {
      loadDataGrid();
    }
  });

  $("#dwnldBtn").click(function (e) {
    var org_id = $("#org_id").val();
    var vendor_id = $("#vendor_id").val();
    var vendor_name = $("#vendor_name").val();

    if (org_id && vendor_id) {
      // Send the form data via AJAX
      $.ajax({
        url: "bgprocess.cfm",
        type: "POST",
        data: {
          org_id: org_id,
          vendor_id: vendor_id,
          action_flag: "chkvendorstockData",
        },
        beforeSend: function () {        
        },              
        success: function (data) {        
          var filteredData = data.split("~~");
          var totalData = filteredData[3];      
          if (totalData == 0){
            window.parent.fw_notify("error", "Data does not exist !");
          }
          else{
            var downloadUrl = "download.cfm?org_id=" + org_id + "&vendor_id=" + vendor_id + "&vendor_name=" + vendor_name;
            $("#download_panel").attr("src", downloadUrl);  
          }
        },
        error: function (xhr, status, error) {},
      });

      //make some if else statement to restrict org & vendor that has no data
      // var downloadUrl = "download.cfm?org_id=" + org_id + "&vendor_id=" + vendor_id;
      // $("#download_panel").attr("src", downloadUrl);
    } else {
      if (!org_id) {
        showTips("org_id", "Please Insert Organization!");
        window.parent.fw_notify("error", "Please pick organization!");
      }

      if (!vendor_id) {
        showTips("vendor_name", "Please Insert Vendor!");
        window.parent.fw_notify("error", "Please pick vendor!");
      }

      if (!org_id && !vendor_id) {
        showTips("org_id", "Please Insert Organization!");
        showTips("vendor_name", "Please Insert Vendor!");
        window.parent.fw_notify(
          "error",
          "Please pick both organization and vendor!"
        );
      }
    }
  });
});

function validateInput(formData, jqForm, options) {
  return true;
}
function openNewTab(title, url, fid) {
  if (parseInt(countOpenedTabs(), 10) >= parseInt(MAX_OPENED_TAB)) {
    notify(
      "error_tab",
      appsname,
      "You are only allowed to open " +
        parseInt(MAX_OPENED_TAB) +
        " tabs at a time!",
      "3000"
    );
  } else {
    $jq(document).ready(function () {
      var iframeid = "iframe-" + tabCounter;
      var tabTemplate =
        "<li id='tabpanel" +
        tabCounter +
        "'><a href='#{href}' tabFunctionID='" +
        fid +
        "' iframeid='" +
        iframeid +
        "'>#{label}</a><span class='ui-icon ui-icon-close' ></span></li>"; // fix tab scroll location 09052019 shiddeq
      var tabid = "tabs-" + tabCounter;
      var li = $jq(
        tabTemplate
          .replace(/#\{href\}/g, "#" + tabid)
          .replace(/#\{label\}/g, title)
      );

      $tabs.find(".ui-tabs-nav").append(li);
      $tabs.append(
        "<div id='" +
          tabid +
          "' class='tbclass'><div class='content'><iframe id='" +
          iframeid +
          "' src='" +
          url +
          "&tabid=" +
          tabid +
          "&parentframeid=" +
          iframeid +
          "' frameborder='0' marginwidth='0' marginheight='0' scrolling='auto'></iframe></div></div>"
      );

      openTabMode = "open_UI";
      $tabs.tabs("refresh");
      $tabs.tabs("option", "active", -1);
      openTabMode = "switch_UI";
      tabCounter++;
    });
  }

  return false;
}

function fw_onSelectPartNumber(data) {
  $(document).ready(function (e) {
    $("#part_number").val(data[0]);
  });
}
function fw_onSelectBackNumber(data) {
  $(document).ready(function (e) {
    $("#back_number").val(data[0]);
  });
}
function fw_onSelectVendor(data) {
  $(document).ready(function (e) {
    $("#vendor_id").val(data[0]);
    $("#vendor_name").val(data[1]);
  });
}

function loadDataGrid() {
  $(document).ready(function (e) {
    function switchIcon(data, type, row) {}
    function editIcon(data, type, row) {
      var editIcon = '<i class="fas fa-pencil-alt edit-icon"></i>';

      return editIcon;
    }
    function undoIcon(data, type, row) {
      var icon =
        '<i class="fa-solid fa-arrow-rotate-left" style="cursor:pointer; font-size:16px"></i>';
      return icon;
    }
    function dateConvert(data) {
      var convertedDate = moment(data).format("DD/MM/YYYY");
      if (convertedDate == "Invalid date") convertedDate = "";
      return convertedDate;
    }

    function datetimeConvert(data) {
      var convertedDate = moment(data).format("DD/MM/YYYY h:mm:ss A");
      if (convertedDate == "Invalid date") convertedDate = "";
      return convertedDate;
    }

    $.ajax({
      type: "POST",
      url: "bgprocess.cfm",
      data: {
        action_flag: "loadDataGrid",
        vendor_id: $("#vendor_id").val(),
        org_id: $("#org_id").val(),
        back_number: $("#back_number").val(),
        part_number: $("#part_number").val(),
      },
      success: function (data) {
        var jsonArr = data.split("~~");
        var jsonObj = JSON.parse(jsonArr[1]);
        var jsonData = jsonObj["DATA"];
        allData = jsonData;
        $("#gridPanel").slideDown();
        var dg = $("#datagrid").DataTable({
          data: jsonData,
          columnDefs: [
            {
              width: "50px",
              targets: 0,
              className: "dt-center",
              orderable: false,
            },
            {
              width: "50px",
              targets: 1,
              className: "dt-center",
              orderable: false,
              render: editIcon,
            },
            { width: "150px", targets: 2, className: "dt-center" },
            { width: "100px", targets: 3, className: "dt-center" },
            { width: "100px", targets: 4, className: "dt-center" },
            { width: "100px", targets: 5, className: "dt-center" },
            { width: "100px", targets: 6, className: "dt-center" },
            { width: "100px", targets: 7, className: "dt-center" },
            {
              width: "100px",
              targets: 8,
              className: "dt-center",
              className: "dt-center editable-cell",
            },
            { width: "100px", targets: 9, className: "dt-center" },
            {
              width: "100px",
              targets: 10,
              className: "dt-center",
              render: dateConvert,
            },
          ],
          order: [[3, "asc"]],
          fixedColumns: {
            left: 1,
          },
        });

        dg.on("order.dt search.dt", function () {
          var i = 1;
          dg.cells(null, 0, { search: "applied", order: "applied" }).every(
            function (cell) {
              this.data(i++);
            }
          );
        }).draw();
        init_fw_datagrid_btns("datagrid");
        $(".gridReloadBtn").html('<i class="fa-solid fa-rotate-right"></i>');
        $(".gridReloadBtn").unbind("click");
        $(".gridReloadBtn").click(function (e) {
          loadDataGrid();
        });

        $(".grid_title").html($("#datagrid").attr("title"));
        $("#searchPanel").hide("blind");
        $(".gridBtn").slideDown();

        $("#datagrid tbody").unbind("click");
        $("#datagrid tbody").on("click", "td", function () {
          var table = $("#datagrid").DataTable();
          //to get number of column
          var colIdx = table.column(table.cell(this).index().column).dataSrc();
          var id = table.row($(this).parent("tr")).data()[1];
          var row = table.row($(this).closest("tr"));
          var data = row.data();
          if (colIdx === 1) {
            var editableCell = row.nodes().to$().find("td").eq(-3);
            editableCell.attr("contenteditable", "true");
            $("#updatePanel").modal("show");
            loadEditPanel(id);
            editableCell.focus();
          }
        });
      },
      error: function (request, status, error) {
        window.parent.fw_notify("error", error);
      },
    });
  });
}
function fw_searchPanelShown() {
  $(document).ready(function () {
    $("#float_addBtn").hide("drop");
  });
}

function fw_searchPanelHidden() {
  $(document).ready(function () {
    $("#float_addBtn").show("drop");
  });
}
function loadEditPanel(id) {
  $(document).ready(function () {
    $.ajax({
      type: "POST",
      url: "bgprocess.cfm",
      data: { id: id, action_flag: "loadQuantity" },
      success: function (data) {
        var resultArr = data.split("~~");
        var prev_qty = resultArr[8];
        $("#detail_id").val(id);
        $("#updateOrga").val(resultArr[3]);
        $("#updateVendor").val(resultArr[4]);
        $("#updatePartname").val(resultArr[7]);
        $("#updatePartnum").val(resultArr[6]);
        $("#updatebackNum").val(resultArr[5]);
        $("#updateprevQty").val(prev_qty !== "" ? resultArr[8] : "N/A");
        $("#updateQty").val(resultArr[9]);

        setTimeout(function () {}, 500);

        fw_refresh_compulsary("updateForm");

        $("#updatePanel").modal("show");
      },
      error: function () {
        window.parent.fw_notify(
          "error",
          "Load Update Quantity",
          "Error while processing your request",
          "3000"
        );
      },
    });
  });
}
function edit_showRequest(formData, jqForm, options) {
  //remove empty space
  $("#updateQty").val($.trim($("#updateQty").val()));
  if (!compulsaryValidation("updateForm")) {
    return false;
  } else {
    return true;
  }
}
function edit_showResponse(responseText, statusText, xhr, $form) {
  var responseArr = responseText.split("~~");

  if (responseArr[1] == "success") {
    $("#editPanel").modal("hide");
    loadDataGrid();
    window.parent.fw_notify("success", "Quantity is successfully updated");
    $("#updatePanel").modal("hide");
  } else {
    window.parent.fw_notify("error", responseArr[2]);
  }
}

function fw_udf_org_changed(org_id) {
  
  $(document).ready(function () {
    if (org_id == "") {
      $("#warehouse")
        .empty()
        .attr("disabled", "disabled")
        .append('<option value="">-- Please Select --</option>');

    } else {
      //load warehouse
      $.ajax({
        type: "POST",
        url: "bgprocess.cfm",
        data: { action_flag: "load_warehouse" },
        success: function (data) {
          var resultArr = data.split("~~");
          $("#warehouse")
          .empty()
            .removeAttr("disabled")
            .append(resultArr[2]);
        },
        error: function () {
          window.parent.notify(
            "error",
            "Activity",
            "Error while processing your request",
            "3000"
          );
        },
      });

    }
  });
}