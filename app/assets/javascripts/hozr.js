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
}

$(document).ready(initializeBehaviours);
