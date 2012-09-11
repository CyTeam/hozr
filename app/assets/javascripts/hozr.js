// Case assignment
function getValueFromPreviousCase(field, input) {
  var case_id = $(input).parents('.case').data('case-id');
  return $('#a_case_' + (case_id - 1) + '_' + field).val();
}

function guessIntraDayIdFromPreviousCase() {
  var value = getValueFromPreviousCase('intra_day_id', this);
  if (value === undefined) {
    return
  } else {
    $(this).val(parseInt(value) + 1);
  }
}

function guessExaminationDateFromPreviousCase() {
  $(this).val(getValueFromPreviousCase('examination_date', this));
}

function guessDoctorIdFromPreviousCase() {
  $(this).val(getValueFromPreviousCase('doctor_id', this));
}

function setupCaseAssignment() {
  var unassigned_sort_queue = $('#unassigned_sort_queue');
  unassigned_sort_queue.find("[name$='[intra_day_id]']").live('focus', guessIntraDayIdFromPreviousCase);
  unassigned_sort_queue.find("[name$='[examination_date]']").live('focus', guessExaminationDateFromPreviousCase);
  unassigned_sort_queue.find("[name$='[doctor_id]']").live('focus', guessDoctorIdFromPreviousCase);
}

// Billing Address switch
function updateBillingAddressUsage() {
  var usage_toggle = $('#patient_use_billing_address');
  use = (usage_toggle.attr('checked') != 'checked');

  $('#billing_data').find(':input').not('#patient_use_billing_address').prop("disabled", use);
}

function setupBillingAddressToggle() {
  var usage_toggle = $('#patient_use_billing_address');
  usage_toggle.change(updateBillingAddressUsage);

  updateBillingAddressUsage();
}

// SlidePath
function setupSlidepathLinks() {
  $('.slidepath_links').each(function() {
    $.ajax({
        type: 'GET',
        url: '/slidepath/links',
        data: 'case_id=' + $(this).data('case-id'),
        success: function(data){eval(data);}
    });
  });
};

// Contextual update and create buttons
function setupSubmitButtons() {
  var button = $('.submit-button');
  var form = button.parents('.row-fluid').find('form');

  button.click(function() {
    form.submit();
  });
}

function showPatientHistory(element) {
  $(element).find('.case-history a').click();
}

function setupPatientHistoryHover() {
  $('.patient').live('hover', function(event) {
    showPatientHistory(this);
  });
}

// Table selection
function startTableSelection() {
  $(':focus').blur();
  in_table_selection = true;
}

function stopTableSelection() {
  in_table_selection = false;
}

function resetTableSelection() {
  stopTableSelection();

  var input_field = $('input[data-table-selection]');
  input_field.focus();
}

function selectRow(row) {
  $('tr.selected').removeClass('selected');
  $(row).addClass('selected');

  $(row).mouseenter();
}

function selectFirstRow() {
  var table = $('table#patients');
  selectRow(table.find('tr').eq(1));
}

function selectNextRow() {
  startTableSelection();

  var current_row = $('tr.selected');

  if (current_row.length == 0) {
    // Select first content row
    selectFirstRow();
  }

  var new_row = current_row.next('tr');

  if (new_row.length == 0) {
    // Do nothing if there is no next row
    return
  }

  selectRow(new_row);
}

function selectPreviousRow() {
  startTableSelection();

  var current_row = $('tr.selected');

  if (current_row.length == 0) {
    // Select first content row
    selectFirstRow();
  }

  if (current_row.index() == 1) {
    // Do nothing if we're on the first content row
    return
  }

  var new_row = current_row.prev('tr');

  if (new_row.length == 0) {
    // Do nothing if there is no previous row
    return
  }

  selectRow(new_row);
}

in_table_selection = false;
function setupPatientTableSelect() {
  $(document).keydown(function(e) {
    // Only activate if an input with the table-selection marker is focused
    // or we're in table selection mode already
    var input_field = $('input[data-table-selection]:focus');

    if (input_field.length == 0 && !in_table_selection) {
      return
    }

    if (e.which == 9 || e.which == 40) {
      // Tab or Arrow Down
      selectNextRow();
      e.preventDefault();
    }
    if (e.which == 38) {
      // Arrow Up
      selectPreviousRow();
      e.preventDefault();
    }
    if (in_table_selection) {
      var selected_row = $('tr.selected');
      var action;
      if (e.which == 27) {
        // ESC
        resetTableSelection();
        return
      } else if (e.which == 69) {
        // 'e'
        action = 'edit';
      } else if (e.which == 90) {
        // 'z'
        action = 'set-patient';
      }

      if (!(action === undefined)) {
        e.preventDefault();
        stopTableSelection();
        var action_link = selected_row.find('a.action-' + action).click();
      };
    }
  });
}

// Twitter Bootstrap
function setupPopOver() {
  $("*[data-content]").popover();
}

function initializeBehaviours() {
  setupSlidepathLinks();
  setupCaseAssignment();

  setupSubmitButtons();
  setupPatientTableSelect();

  setupPopOver();
//  setupBillingAddressToggle();

  setupPatientHistoryHover();
}

$(document).ready(initializeBehaviours);
