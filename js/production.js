$(document).ready(function () {
    setInterval(primary, 10000);
});

function primary() {
    priority_announcements();
}

function secondary() {

}

function priority_announcements() {
    // check for announcement
    // these are zero because we are in live preview and not tied to a terminal or template yet
    terminal_id = 0;
    template_id = 0;

    //session_full();

    $.ajax({
        type: "POST",
        url: "/display.asmx/get_message",
        data: "{'template_id': " + template_id + ", 'terminal_id': " + terminal_id + ", 'priority': true}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            if (data.d.id > 0) {
                // check to see if this is the announcement template 
                if ($("#is_announcement_template").val() === "no") {
                    if ($("#end_of_day_template").val() !== '') {
                        // build the whole url
                        window.location = '/preview/' + $("#event_id").val() + '/' + $("#location_id").val() + '/' + $("#regular_overlay").val() + '/' + $("#announcement_overlay").val() + '/' + $("#end_of_day_template").val() + '/announcement';
                    } else {
                        // build the url without end of day 
                        window.location = '/preview/' + $("#event_id").val() + '/' + $("#location_id").val() + '/' + $("#regular_overlay").val() + '/announce/' + $("#announcement_overlay").val() + '/announcement';
                    }
                }

                // if it is then render the announcement
                if ($("#priority_title").length) {
                    $("#priority_title .fr-editor").html($("#priority_title .fr-editor").html().replace(/{.+}/, data.d.title));
                }

                if ($("#priority_description").length) {
                    $("#priority_description .fr-editor").html($("#priority_description .fr-editor").html().replace(/{.+}/, data.d.message));
                }

                if ($("#priority_image").length) {
                    if (data.d.pic != null) {
                        $("#priority_image .fr-editor").html($("#priority_image .fr-editor").html().replace(/{.+}/, "<img src=\"/uploads/" + data.d.pic + "\" />"));
                    }
                }

                //$(".twitter").hide();
                //$(".announcement").show();

            } else {

                if ($("#is_announcement_template").val() === "yes") {
                    if ($("#end_of_day_template").val() !== '') {
                        // build the whole url
                        window.location = '/preview/' + $("#event_id").val() + '/' + $("#location_id").val() + '/' + $("#regular_overlay").val() + '/' + $("#announcement_overlay").val() + '/' + $("#end_of_day_template").val() + '/default';
                    } else {
                        // build the url without end of day 
                        window.location = '/preview/' + $("#event_id").val() + '/' + $("#location_id").val() + '/' + $("#regular_overlay").val() + '/announce/' + $("#announcement_overlay").val() + '/default';
                    }
                }

            }
        }
    });
}

function next() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/next",
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            if (data.d.name.length > 90) {
                $("#next_session").attr("class", "next-session-small");
            } else {
                $("#next_session").attr("class", "next-session");
            }

            $("#the_next_session").text(data.d.event_start + ': ' + data.d.name);

        }
    });
}

function refreshData() {

    // refresh the data

    location_id = $("#location_sched").val();

    var single_height = $("#current_session_header .session").height();

    $.ajax({
        type: "POST",
        url: "/display.asmx/current",
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            server_time();

            if (data.d.event_id == 0) {

                //console.log('EventID Lost');

                var cookie_id = $.cookie("FNSIGN_EventID");

                // if Session["event_id"] Is Null check for the cookie
                $.ajax({
                    type: "POST",
                    url: "/display.asmx/loginAgain",
                    data: "{'event_id': '" + cookie_id + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data, status) {
                        refreshData();
                    }
                });

            } else {

                //$("#session_type").text(data.d.event_type);
                $("#the_session_title").text(data.d.name);

                //$("#current_title").text(data.d.name);
                $("#the_session_start_time").text(data.d.event_start);

                $("#speaker_name").text(data.d.speakers);

                $("#the_session_category").text(data.d.event_type);

                background();

                setTimeout(function() {
                    if ($("#the_session_title").height() < 60) {
                        $("#the_session_title").css("font-size", "52px");
                    }
                }, 1000);

            }
        }
    });

}