/**
 * Disabilita AJAX
**/

$(document).bind("mobileinit", function () {
    $.mobile.ajaxEnabled = false;
    $.mobile.listview.prototype.options.headerTheme = "a";
});