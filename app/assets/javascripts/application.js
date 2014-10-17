// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .



var count = 0;
function rotate() {
  var elem = document.getElementById('loading');
  elem.style.MozTransform = 'scale(0.5) rotate('+count+'deg)';
  elem.style.WebkitTransform = 'scale(0.5) rotate('+count+'deg)';
  if (count==360) { count = 0 }
  count+=45;
  window.setTimeout(rotate, 100);
}
window.setTimeout(rotate, 100);

function show() {
	var elem = document.getElementById('target');
	elem.className = "visible"
}