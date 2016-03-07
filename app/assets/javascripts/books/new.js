$(document).on('click', '.search-row input[type="submit"]', function () {
    $(this).parent().find('.alert').remove();
});