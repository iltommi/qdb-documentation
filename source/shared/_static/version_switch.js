(function() {
  'use strict';

  var all_versions = {
    // 'url_string': 'display_name_when_not_active'
    '1.1.2': '1.1.2'
  };
  
  // Builds a <select> tag with options from each of the all_versions variable above.
  // 
  //
  function build_select(major_minor_version, full_version) {
    var new_select_tag = ['<select>'];
    
    // For each of the versions in var all_versions...
    $.each(all_versions, function(url_string, display_name) {
      
        // Create a new option using the url string as the 
        new_select_tag.push('<option value="' + url_string + '"');
        
        // If the all_versions item we're on matches the SPHINX Documentation version,
        // set the combo box to display it as the selected item.
        // Also, replace the var all_versions display name with SPHINX Documentation full version number.
        if (url_string == major_minor_version)
            new_select_tag.push(' selected="selected">' + full_version + '</option>');
        else
            new_select_tag.push('>' + display_name + '</option>');
    });

    new_select_tag.push('</select>');
    
    return new_select_tag.join('');
  }

  function patch_url(url, new_version) {
    
    // Find url instances like:
    //   .net/1/
    //   .net/1.0/
    //   .net/1.0*/
    //   .net/2.7.6*/
    //
    // Test at http://regexpal.com/ by removing the first and last forward slashes.
    //
    var url_regex = /\.net\/(\d|(\d\.\d[\w\d\.]*))\//;
    
    // Replace the part of the url that matched the regex with '.net/version/
    var new_url = url.replace(url_regex, '.net/' + new_version + '/');
    
	// If the regex changed the incoming string, use that.
    if (new_url != url) {
        return new_url;
	}
    else {
        // Otherwise hard-replace '.net/' with '.net/version/'.
        return url.replace(/\.net\//, '.net/' + new_version + '/');
    }
  }
  
  
  function on_switch() {
    // Get the variable the user chose.
    var selected = $(this).children('option:selected').attr('value');

    // When the selection is changed,
    // run patch_url on the window url.
    var url = window.location.href;
    var new_url = patch_url(url, selected);
    
    // So long as the patched URL doesn't match our existing URL... (e.g. user clicked same version)
    if (new_url != url) {
      
      // Ensure the patched URL exists before loading it, otherwise redirect to version's start page
      $.ajax({
        url: new_url,
        success: function() {
           window.location.href = new_url;
        },
        error: function() {
           window.location.href = 'http://doc.quasardb.net/' + selected;
        }
      });
    }
  }

  // When the document is ready...
  $(document).ready(function() {
    
    // Get the MAJOR.MINOR.PATCH version from the SPHINX version embedded in the HTML.
    // e.g. "2.6.7"
    var full_version = DOCUMENTATION_OPTIONS.VERSION;
    
    // Strip off the end so it's just MAJOR.MINOR version, e.g. 2.6
    var mm_version = full_version.substr(0, 3);
    
    // Build the <select> tag in the header.
    var select = build_select(mm_version, full_version);
    
    // Bind the on_switch() function to the <select> tag's on-change event.
    $('.version_switcher_placeholder').html(select);
    $('.version_switcher_placeholder select').bind('change', on_switch);
  });
})();