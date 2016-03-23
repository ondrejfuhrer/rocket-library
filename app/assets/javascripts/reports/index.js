$(document).on('page:change', function () {
    $('.bootstrap-datepicker').datepicker();
});

$(document).on('changeDate', '.bootstrap-datepicker', function(event) {
    var rails_date = event.date.getFullYear() + '-' + ('0' + (event.date.getMonth() + 1)).slice(-2) + '-' + ('0' + event.date.getDate()).slice(-2)
    $(this).next("input[type=hidden]").val(rails_date)
});

$(document).on('click', 'input.report-download-type', function () {
    var $this = $(this);
    if (this.checked) {
        $('input.report-download-type').each(function (key, value) {
            if ($(value).attr('id') != $this.attr('id')) {
                $(value).attr('checked', false);
            }
        });
    }
    var $selectedItem = $('input.report-download-type:checked');
    var $form = $('form#edit_options_rental');
    var defaultAction = $form.data('default-action');
    if ($selectedItem.length) {
        var downloadTypeUrl = $form.data($selectedItem.data('type') + '-action');
        if (downloadTypeUrl) {
            $form.attr('action', downloadTypeUrl);
        } else {
            $form.attr('action', defaultAction);
        }
    } else {
        $form.attr('action', defaultAction);
    }
});
