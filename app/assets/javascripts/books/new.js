$(document).on('click', '.search-row input[type="submit"]', function () {
    closeAlert($(this).closest('div.search-row'));
});

$(document).on('click', '#js-search', function () {
    $('#search-results .row').empty();
    $('.loader').removeClass('hidden');
});
