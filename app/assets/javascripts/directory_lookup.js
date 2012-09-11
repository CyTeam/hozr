function showDirectoryLookupDialog(selector) {
  var params = $("[name^='" + selector + "']").not("[name$='[id]']").serialize();
  var selector_param = $.param({selector: selector});

  var query = '/directory_lookup/search?' + params + '&' + selector_param;
  $.getScript(query);
}

function updateFromDirectoryLookup(selector, params) {
  $("input[name^='patient[billing_vcard_attributes][family_name]']").val(v.data('directory-lookup-attributes')['family_name'])
}


function addDirectoryLookupBehaviour() {
  $('[data-directory-lookup]').on('click', function(event) {
    var selector = $(this).data('directory-lookup');
    showDirectoryLookupDialog(selector);
  })
}
