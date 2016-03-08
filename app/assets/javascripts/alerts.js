setTimeout(closeAlert, 4000);

function closeAlert($initialSelector) {
    if (!$initialSelector) {
        $initialSelector = $(document);
    }

    $initialSelector.find('.alert').alert('close');
}
