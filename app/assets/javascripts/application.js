//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require moment
//= require rome/rome.standalone
//= require endless/uncompressed/pace
//= require endless/jquery.popupoverlay.min
//= require endless/jquery.slimscroll.min
//= require endless/modernizr.min
//= require endless/jquery.cookie.min
//= require endless/endless/endless
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
