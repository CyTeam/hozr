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
  $("[name$='[intra_day_id]']").live('focus', guessIntraDayIdFromPreviousCase);
  $("[name$='[examination_date]']").live('focus', guessExaminationDateFromPreviousCase);
  $("[name$='[doctor_id]']").live('focus', guessDoctorIdFromPreviousCase);
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

function initializeBehaviours() {
  setupSlidepathLinks();
  setupCaseAssignment();
}

$(document).ready(initializeBehaviours);
