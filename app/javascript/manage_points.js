// app/assets/javascripts/points.js

$(document).on('click', '#managePointsButton', function(e) {
    e.preventDefault();
    var email = $(this).attr('data-email'); // assuming the email is stored in data-email attribute

    $.ajax({
        url: '/points/manage',
        method: 'GET',
        dataType: 'script',
        data: { email: email },
    });
});