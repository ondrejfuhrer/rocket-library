// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets
//= require alerts
//= require bootstrap-datepicker

$(document).on('show.bs.modal', '#delete-modal', function (event) {
    var button = $(event.relatedTarget); // Button / link that triggered the modal
    var title = button.data('title');
    var author = button.data('author');
    var form_action = button.data('form-action');

    var modal = $(this);
    modal.find('.modal-title').text('Return book ' + author + ': ' + title);
    modal.find('form.delete-modal').attr('action', form_action);
});
