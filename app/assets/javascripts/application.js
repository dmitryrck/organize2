//= require jquery
//= require jquery_ujs
//= require moment
//= require rome/rome.standalone
//= require_self

$(function() {
  $.each($('.date'), function (idx, input) {
    rome(input, {
      time: false,
      autoClose: false,
      inputFormat: 'YYYY-MM-DD'
    });
  });
});
