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

// Contextual Update button
function setupUpdateButton() {
  var button = $('#update-button');
  var form = button.parents('.row-fluid').find('form');

  button.click(function() {
    form.submit();
  });
}

// Twitter Bootstrap
function setupPopOver() {
  $("*[data-content]").popover();
}

function initializeBehaviours() {
  setupSlidepathLinks();
  setupCaseAssignment();
  setupUpdateButton();
  setupPopOver();
  setupBillingAddressToggle();
}

$(document).ready(initializeBehaviours);
