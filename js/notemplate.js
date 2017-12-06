function check_again() {

    terminal_id = $("#terminal_id").val();

    window.location.href = '/displays/' + terminal_id;

}

setInterval(check_again, 60000);