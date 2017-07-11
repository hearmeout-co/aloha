$(document).ready(function() {
  $('button:has(a)').click(function(event) {
    window.location = $(event.target).find('a').attr('href');
  });
});