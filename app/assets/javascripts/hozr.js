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
  $("body").on('click', '.submit-button', function() {
    var form = $(this).parents('.row-fluid, .modal:visible').find('form');
    form.submit();
  });
}

// Cancel button support
function setupCancelButtons() {
  // Key handler
  $(document).keydown(function(e) {
    var cancel_button = $('.cancel-button:visible')
    // No action if no visible cancel button present
    if (cancel_button.length == 0) {
      return;
    }

    if (e.which == 27) {
      cancel_button.click();
    }
  })
}

function showPatientHistory(element) {
  $(element).find('.case-history a').click();
}

function setupPatientHistoryHover() {
  $('.patient').live('hover', function(event) {
    showPatientHistory(this);
  });
}

// Rails Convention Helpers
function getId(element) {
  return $(element.attr('id').split('_')).last()[0];
}

// Patient merging
function setupPatientMerging() {
  $(document).on('click', '#merge-action', function() {
    var marked_id = getId($('tr.marked'));
    var selected_id = getId($('tr.selected'));
    var params = $.param({
      patient1_id: marked_id,
      patient2_id: selected_id
    });
    $.getScript('/patients/propose_merge?' + params);
  })
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
  $(row).scrollintoview();

  $(row).mouseenter();
}

function selectFirstRow() {
  var input_field = $('input[data-table-selection]');
  var table = $(input_field.data('table-selection'));
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
    // Jump to first row
    selectFirstRow();
    return;
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
  // Stop table selection when creating a new patient
  $('#new-patient-button').on('click', stopTableSelection);

  // Stop table selection when focusing anything
  $(document).on('focus', ':input', stopTableSelection);

  // Reactivate table selection and hide form when form is canceled
  $(document).on('click', '#patient-form .cancel-button', function() {
    $('#patient-form').hide();
    $('#patient-search').show();
    resetTableSelection();
  });

  // Key handler
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
      } else if (e.which == 78) {
        // 'n'
        $('#new-patient-button').click();
        return
      } else if (e.which == 32) {
        // SPACE
        $('tr.marked').removeClass('marked');
        selected_row.addClass('marked');
        return
      } else if (e.which == 69) {
        // 'e'
        action = 'edit';
      } else if (e.which == '86') {
        // 'v'
        e.preventDefault();
        stopTableSelection();

        $('#merge-action').click();
      } else if (e.which == 13) {
        // ENTER
        action = 'set-patient';
      }

      if (!(action === undefined)) {
        e.preventDefault();
        stopTableSelection();
        selected_row.find('a.action-' + action).click();
      };
    }
  });
}

function autofocus(selector) {
  $(selector).find('[data-autofocus=true]').first().focus();
}


// Twitter Bootstrap
function setupPopOver() {
  $("*[data-content]").popover();
}
