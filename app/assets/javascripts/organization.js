//= require social_stream/callback

var Organization = (function(SS, $, undefined) {
  var callback = new SS.Callback();

  var initTabs = function() {
    var section = window.location.search.match(/section=(\w+)/);

    if (section) {
      // [ "section=other", "other" ]
      section = section[1];
    } else {
      section = 'owned';
    }

    $('#organizations ul.nav-tabs a').on("show", loadTab);

    $('#organizations ul.nav-tabs a[href="#' + section + '"]').tab('show');
  };

  var loadTab = function(event) {
    var tab = $(event.target);

    if (tab.attr('data-loaded'))
      return;

    $.ajax({
      url: tab.attr('data-path'),
      data: {
        section: tab.attr('href').substr(1),
        q: $('#contact-filter').val()
      },
      dataType: 'html',
      type: 'GET',
      success: function(data) {
        $(tab.attr('href')).html(data);
        tab.attr('data-loaded', 'true');
      },
      error: function(jqXHR, status, error) {
        SS.Flash.error(error);
      }
    });
  };

  callback.register('index',
                    initTabs);
  

  return callback.extend({
  });

})(SocialStream, jQuery);
