$.getScript("/js/jquery.cookie.js", function () { });

var theContent = '';
var wasFull = false;

//##################################################################################
//Refreshing F8 Data
//##################################################################################
function refreshF8EntryPoint() {
    location_id = $("#location_sched").val();
    url = "/display.asmx/get_f8_display_data";
    if (location_id.toLowerCase() == 'keynote')
        url = "/display.asmx/get_f8_keynote_display_data";

    $.ajax({
        type: "POST",
        url: url,
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            if (data.d.eventId == 0) {
                var cookie_id = $.cookie("FNSIGN_EventID");

                // if Session["event_id"] Is Null check for the cookie
                $.ajax({
                    type: "POST",
                    url: "/display.asmx/loginAgain",
                    data: "{'event_id': '" + cookie_id + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data, status) {
                        refreshF8EntryPoint();
                    }
                });

            } else {
                //Pre-BeginningOfDay?
                refreshPreBeginningOfDay(data)
                //BeginningOfDay?
                refreshBeginningOfDay(data)
                //EndOfDay?
                refreshEndOfDay(data)
                //IsFull?
                refreshF8Full(data);
                //CURRENT
                refreshF8Current(data);
                //NEXT
                refreshF8Next(data);
            }
        }
    });

}

function refreshPreBeginningOfDay(data) {
    if (data.d.isPreBeginOfDay == true) {
        $('.pre-bod').css({ "display": '' });
        $('.pre-bod').text(data.d.PreBeginOfDayMessage);
    }
    else
        $('.pre-bod').css({ "display": 'none' });

}

function refreshBeginningOfDay(data) {
    if (data.d.isPreBeginOfDay == false && data.d.isBeginOfDay == true) {
        $('.bod-wrapper').css({ "display": '' });

        var html = '';
        $.each(data.d.sessions, function(i) {
            html += '<div class="bod-session"><div class="bod-session-start">' + data.d.sessions[i].event_start.replace('AM', '').replace('PM', '').trim() + '</div><div class="circle"></div><div class="bod-session-title">' + data.d.sessions[i].name + '</div></div>';
        });
        $('.bod-content').html(html);
    }
    else
        $('.bod-wrapper').css({ "display": 'none' });

}

function refreshEndOfDay(data) {
    if (data.d.isPreBeginOfDay == false && data.d.isBeginOfDay == false && data.d.isEndOfDay == true)
    {
        $('.end-of-day').css({ "display": '' });
        $('.end-of-day').text(data.d.EndOfDayMessage);
    }
    else
        $('.end-of-day').css({ "display": 'none' });

}

function refreshF8Full(data) {
    if (data.d.isPreBeginOfDay == false && data.d.isBeginOfDay == false && data.d.isEndOfDay == false && data.d.currentIsFull == true) {
        $('.current-full').css({ "display": '' });
        $('.current-full').text(data.d.currentFullMessage);
    }
    else
        $('.current-full').css({ "display": 'none' });
}

function refreshF8Next(data) {
    if (data.d.isPreBeginOfDay == false && data.d.isBeginOfDay == false && data.d.isEndOfDay == false && data.d.currentIsFull == false) {

        $('.content').css({ "display": '' });

        if (data.d.next.internal_id != 0)
            $('.next-title').text("UP NEXT: " + data.d.next.name);
        else
            $('.next-title').text("");
    }
}

function refreshF8Current(data) {
    if (data.d.isPreBeginOfDay == false && data.d.isBeginOfDay == false && data.d.isEndOfDay == false && data.d.currentIsFull == false) {

        $('.content').css({ "display": '' });

        if (data.d.current.internal_id != 0) {
            $('.current-start-time').text(data.d.current.event_start);
            $('.current-end-time').text(data.d.current.event_end);
            $('.current-time-separator').text('-');

            $('.current-title').text(data.d.current.name);

            var names = data.d.current.speakers.split(',');
            var companies = data.d.current.speaker_companies.split(',');
            /*
            var jobs = new Array(companies.length);
            if (data.d.current.speaker_job_titles != null)
                var jobs = data.d.current.speaker_job_titles.split(',');
            else
                jobs.fill("TBD");
            */

            var html = '';
            //if (names.length == companies.length && names.length == jobs.length) {
            if (names.length == companies.length) {
                var index;
                for (index = 0; index < names.length; index++) {
                    html += "<div class='speaker'><div class='speaker-name'>" + names[index].toUpperCase() + "</div><div class='speaker-company'>" + companies[index].toUpperCase() + "</div></div>";
                }
            }

            $('.speaker-list').html(html);
            switch(names.length) {
                case 6:
                    $('.speaker').css({ "font-size": '25px', "line-height": '33px' });
                    break;
                case 5:
                    $('.speaker').css({ "font-size": '30px', "line-height": '42px' });
                    break;
                default:
                    $('.speaker').css({ "font-size": '33px', "line-height": '50px' });
            }

        }
        else {
            //$('.current-start-time').text('');
            //$('.current-end-time').text('');
            //$('.current-time-separator').text('');

            //$('.current-title').text('No official session at this time. Check SCHED for full agenda.');

            //$('.speaker-list').html('');

        }

    }
    else
        $('.content').css({ "display": 'none' });

    
    
}
//##################################################################################

function setCurrentCss()
{
    $('div#current_title').css({ "font-size": '58px' });
    $('div#current_speaker').css({ "font-size": '46px' });
    $('.single .session-speaker-block').css({ "top": '0px' });
}

function fixSize(element, height, adjust, adjustTop) {
    if ($(element).height() > height) {
        var font = parseInt($(element).css("font-size"));
        $(element).css({ "font-size": (font - adjust) + "px" });

        if (adjustTop > 0) {
            var top = parseInt($('.single .session-speaker-block').css("top"));
            $('.single .session-speaker-block').css({ "top": (top + adjustTop) + 'px' });
        }

        fixSize(element, height, adjust, adjustTop);
    }
}

function adjustCurrentSession() {
    //var session_title_len = $('div#current_title').text().replace(/ /g, '').replace(/[\n\r]/g, '').length;
    var session_title_len = $('div#current_title').text().replace(/[\n\r]/g, '').trim().length;
    if (session_title_len >= 70) {
        $('div#current_title').css({ "font-size": '36px' });
        $('.single .session-speaker-block').css({ "top": '20px' });

        $('div#current_speaker').css({ "font-size": '26px' });

    } else if (session_title_len >= 40 && session_title_len < 70) {
        $('div#current_title').css({ "font-size": '46px' });
        $('.single .session-speaker-block').css({ "top": '12px' });

        //var speakers_len = $('div#current_speaker').text().replace(/ /g, '').length;
        var speakers_len = $('div#current_speaker').text().trim().length;
        if (speakers_len >= 25) {
            $('div#current_speaker').css({ "font-size": '22px' });
        } else {
            $('div#current_speaker').css({ "font-size": '30px' });
        }

    } else if (session_title_len >= 25 && session_title_len < 40) {
        $('div#current_title').css({ "font-size": '58px' });
        $('.single .session-speaker-block').css({ "top": '0px' });

        var speakers_len = $('div#current_speaker').text().trim().length;
        if (speakers_len >= 25) {
            $('div#current_speaker').css({ "font-size": '26px' });
        } else {
            $('div#current_speaker').css({ "font-size": '46px' });
        }
    } else {
        $('div#current_title').css({ "font-size": '58px' });
        $('.single .session-speaker-block').css({ "top": '0px' });
        var speakers_len = $('div#current_speaker').text().trim().length;
        if (speakers_len >= 25) {
            $('div#current_speaker').css({ "font-size": '32px' });
        } else {
            $('div#current_speaker').css({ "font-size": '46px' });
        }
    }
	
	exception_title = $('div#current_title').text().replace(/[\n\r]/g, '').trim();
	if (exception_title = 'Switch ASIC Programmability with SAI') 
	{
		$('div#current_title').css({ "font-size": '50px' });
		$('.single .session-speaker-block').css({ "top": '12px' });
		$('div#current_speaker').css({ "font-size": '34px' });
	}
	
	exception_title = $('div#current_title').text().replace(/[\n\r]/g, '').trim();
	if (exception_title = 'Disruption at the Edge: An update on the Central Office CORD on OCP - Presented by Flex') 
	{
		$('div#current_title').css({ "font-size": '36px' });
		$('.single .session-speaker-block').css({ "top": '20px' });
		$('div#current_speaker').css({ "font-size": '26px' });
	}		

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

            server_time_or_timewarp();

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
                $("#current_title").text(data.d.name);

                //$("#current_title").text(data.d.name);
                $("#current_timespan").text(data.d.event_start + '-' + data.d.event_end);

                $("#speaker_name").text(data.d.speakers);

                //console.log("Previous Height: " + single_height);
                //console.log("Current Height: " + $("#current_session_header .session").height());

                //single_height = ($("#current_session_header .session").height() - single_height);

                //console.log("New Height to Subtract: " + single_height);
                //console.log("Sessions Height: " + $(".sessions").height());

                //if (single_height > -1) {
                //    $(".sessions").css("height", ($(".sessions").height() - single_height) + "px");
                //} else {
                //    $(".sessions").css("height", ($(".sessions").height() + single_height) + "px");
                //}

                //if (data.d.name.length > 30) {
                //    $("#session_title").attr("class", "session-type");
                //} else {
                //    $("#session_title").attr("class", "session-type-big");
                //}

                //$("#start_time").text(data.d.event_start);

                //next();

                background();

                //twitter();
                //priority_announcements();


            }
        }
    });

}

function refreshData_OCP_BREAKOUT_2018() {

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

            server_time_or_timewarp();

            if (data.d.event_id == 0) {
                var cookie_id = $.cookie("FNSIGN_EventID");

                // if Session["event_id"] Is Null check for the cookie
                $.ajax({
                    type: "POST",
                    url: "/display.asmx/loginAgain",
                    data: "{'event_id': '" + cookie_id + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data, status) {
                        refreshData_OCP_BREAKOUT_2018();
                    }
                });

            } else {

                var nosession = "No official session at this time. Check SCHED for full agenda.";
                if (data.d.name != "")
                    $("#current_title").text(data.d.name);
                else
                    $("#current_title").text(nosession);

                $("#current_start_time").text(data.d.event_start);
                $("#current_speaker").text(data.d.speakers);
                $("#current_type").css({ "backgroundColor": data.d.event_bgcolor });

                background();

                //adjustCurrentSession();

                setCurrentCss();
                fixSize('div#current_title', 140, 4, 4);
                fixSize('div#current_speaker', 60, 2, 0);

            }
        }
    });

}

function refreshOffice() {

    // refresh the data

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/current",
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

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
                        refreshOffice();
                    }
                });

            } else {

                if (data.d.id == 'NO SESSION') {

                    $("#start_time_to_end_time").text(data.d.event_type);
                    $("#session_description").text(data.d.name);
                    $("#session_type").text('');
                    $("#speakers_content").text('');

                } else {

                    $("#session_type").text(data.d.event_type + ' Track Speakers:');
                    $("#session_description").text('Take a break to meet with speakers for Q&A from the previous track sessions.');

                    $("#start_time_to_end_time").text(data.d.event_start + ' - ' + data.d.event_end);

                    var speakerContent = '';

                    $.each(data.d.speakersList, function(i) {
                        speakerContent += '<span class="blue">' + data.d.speakersList[i] + '</span> / ' + data.d.speakerCompaniesList[i] + '<br />';
                    });

                    $("#speakers_content").html(speakerContent);

                    background();
                }
            }
        }
    });

}

function future() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/future_skip_current",
        data: "{'location': '" + location_id + "', 'skip': 0}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#future_sessions").html('');

            var inner_content = '';

            $.each(data.d, function(key, value) {
                inner_content += '<div class="session">'
                    + '<div class="session-type-block"' + ' style="background-color:' + value['event_bgcolor'] + '"></div>'
                    + '<div class="session-time-block"><div class="start-time">' + value['event_start'].replace(" ","") + '</div></div><div class="session-speaker-block">'
                    + '<div class="session-title">'
                    + value['name'] + '</div><div class="speaker-name">' + (value['speakers'] == null ? '' : value['speakers']) + '</div></div></div><div class="space"></div>';
            });

            $("#future_sessions").html(inner_content);

            background();

            //summit();
        }
    });
}

function futureRegistration() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/schedule_by_event",
        //data: "{'location': '" + location_id + "', 'skip': 1}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#future_sessions").html('');

            var inner_content = '';
            var time = '';

            $.each(data.d, function (key, value) {

                if (value['speakers'] == 'null' || value['speakers'] == null) {
                    value['speakers'] = '';
                }

                if (time == value['event_start']) {
                    inner_content += '<div class="session"><div class="session-time-block"><div class="start-time">&nbsp;</div></div><div class="session-speaker-block"><div class="session-title">' + value['name'] + '</div><div class="speaker-name">' + value['speakers'] + '</div><div class="room-name">' + value['venue'] + '</div></div></div><div class="space"></div>';
                } else {
                    inner_content += '<div class="session"><div class="session-time-block"><div class="start-time">' + value['event_start'] + '</div></div><div class="session-speaker-block"><div class="session-title">' + value['name'] + '</div><div class="speaker-name">' + value['speakers'] + '</div><div class="room-name">' + value['venue'] + '</div></div></div><div class="space"></div>';
                    time = value['event_start'];
                }

            });

            $("#future_sessions").html(inner_content);

            background();

            //summit();
        }
    });
}

function futureRegistration_OCP_REGISTRATION_2018() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/schedule_by_event_order_by_start",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#future_sessions").html('');

            var inner_content = '';
            var time = '';
            var session_start;

            $.each(data.d, function (key, value) {

                if (value['speakers'] == 'null' || value['speakers'] == null) {
                    value['speakers'] = '';
                }

                session_start = value['event_start'];

                if (time == session_start) {
                    inner_content += '<div class="session">'
                        + '<div class="session-type"' + ' style="background-color:' + value['event_bgcolor'] + '"></div>'
                        + '<div class="session-speaker-block"><div class="session-title">' + value['name'] + '</div><div class="speaker-name">' + value['speakers'] + '</div><div class="room-name">' + value['venue'].toUpperCase() + '</div></div></div><div class="space"></div>';
                } else {
                    inner_content += '<div class="session">'
                        + '<div class="session-time-block"><div class="start-time">' + session_start.replace(" ","") + '</div></div>'
                        + '<div class="session-type-block"><div class="session-type"' + ' style="background-color:' + value['event_bgcolor'] + '"></div></div>'
                        + '<div class="session-speaker-block"><div class="session-title">' + value['name'] + '</div><div class="speaker-name">' + value['speakers'] + '</div><div class="room-name">' + value['venue'].toUpperCase() + '</div></div></div><div class="space"></div>';
                    time = session_start;
                }

            });

            $("#future_sessions").html(inner_content);

            background();
        }
    });
}

function futureBarcelona() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/future_skip_current",
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            $.each(data.d, function (key, value) {

                inner_content += '<div class="inner-timespan">' + value['event_start'] + ': ' + value['venue'] + '</div><div class="inner-title">' + value['name'] + '</div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function futureByEvent() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/future_by_date",
        //data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            $.each(data.d, function (key, value) {

                inner_content += '<div class="inner-timespan">' + value['event_start'] + ': ' + value['venue'] + '</div><div class="inner-title">' + value['name'] + '</div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function barcelonaDesignSummit() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/barcelona_design_summit",
        //data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            $.each(data.d, function (key, value) {

                inner_content += '<div class="inner-timespan">' + value['event_start'] + ': ' + value['venue'] + '</div><div class="inner-title">' + value['name'] + '</div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function barcelonaWorkingGroup() {

    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/barcelona_working_group",
        //data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            $.each(data.d, function (key, value) {

                inner_content += '<div class="inner-timespan">' + value['event_start'] + ': ' + value['venue'] + '</div><div class="inner-title">' + value['name'] + '</div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function schedule() {
    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/schedule_by_event",
        //data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            var currentDate;
            var dateString;

            $.each(data.d, function (key, value) {

                if (value['event_start'] != currentDate) {
                    dateString = value['event_start'];
                    currentDate = value['event_start'];
                } else {
                    dateString = '';
                }

                inner_content += '<div class="block-wrapper"><div class="time-wrapper"><span>' + dateString + '</span></div><div class="session-wrapper"><div class="session-title">' + value['name'] + '</div><div class="session-details">' + value['venue'] + ' / Until ' + value['event_end'] + '</div></div></div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function group() {
    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/oc3_group",
        //data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $(".inner").html('');

            var inner_content = '';

            var currentDate;
            var dateString;

            $.each(data.d, function (key, value) {

                if (value['event_start'] != currentDate) {
                    dateString = value['event_start'];
                } else {
                    dateString = '';
                }

                inner_content += '<div class="block-wrapper"><div class="time-wrapper"><span>' + dateString + '</span></div><div class="session-wrapper"><div class="session-title">' + value['name'] + '</div><div class="session-details">' + value['venue'] + ' / Until ' + value['event_end'] + '</div></div></div>';

            });

            $(".inner").html(inner_content);

            background();

            summit();
        }
    });
}

function twitter() {

    $(".twitter").show();
    $(".announcement").hide();

    $(".twitter").animate({ left: "-1080" }, 500, "swing", slideRight);
}

function priority_announcements() {
    // check for announcement
    terminal_id = $("#terminal_id").val();
    template_id = $("#template_id").val();

    session_full();

    $.ajax({
        type: "POST",
        url: "/display.asmx/get_message",
        data: "{'template_id': " + template_id + ", 'terminal_id': " + terminal_id + ", 'priority': true}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            if (data.d.id > 0) {
                // render the announcement
                $("#message_title").text(data.d.title);
                $("#message").text(data.d.message);

                if (data.d.pic != null) {
                    $("#message_img").html(data.d.pic);
                }

                $(".twitter").hide();
                $(".announcement").show();

            } else {
                twitter();
            }
        }
    });
}

function session_full() {
    terminal_id = $("#terminal_id").val();
    template_id = $("#template_id").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/session_full",
        data: "{'terminal_id': " + terminal_id + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            if (data.d.id > 0) {

                if (wasFull == false) {
                    theContent = $("body").html();
                }
                wasFull = true;

                console.log(wasFull);
                console.log(theContent);

                $("body").append("<div id='full' style='position:absolute;top:0;left:0;width:1080px;height:1920px;z-index:500;'><img src='/uploads/session_full.jpg' width='1080' height='1920' /></div>");

            } else {

                //if ($("#wasFull").val() == "1") {
                //    theContent = $("#theContentField").val();
                //}


                $("#full").remove();

            }
        }
    });
}

function session_full_OCP_BREAKOUT_2018() {
    location_id = $("#location_sched").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/current",
        data: "{'location': '" + location_id + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {
            server_time_or_timewarp();

            if (data.d.event_id == 0) {
                var cookie_id = $.cookie("FNSIGN_EventID");

                // if Session["event_id"] Is Null check for the cookie
                $.ajax({
                    type: "POST",
                    url: "/display.asmx/loginAgain",
                    data: "{'event_id': '" + cookie_id + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data, status) {
                        refreshData_OCP_BREAKOUT_2018();
                    }
                });

            } else {
                if (data.d.full === true) {
                    // show the full session graphic
                    var fullsess = $("#full_session_graphic").text();

                    console.log('Session Is Full');
                    $("body").append("<div id='full' style='position:absolute;top:0;left:0;width:1080px;height:1920px;z-index:500;'><img src='" + fullsess + "' width='1080' height='1920' /></div>");

                } else {
                    $("#full").remove();
                }

            }
        }
    });

}

function server_time_or_timewarp() {
    $.ajax({
        type: "POST",
        url: "/display.asmx/server_time_or_timewarp",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {
            $("#current_time").text(data.d.replace(" ", ""));
        }
    });
}


function server_time() {
    // check for announcement
    terminal_id = $("#terminal_id").val();
    template_id = $("#template_id").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/server_time",
        //data: "{'template_id': " + template_id + ", 'terminal_id': " + terminal_id + ", 'priority': true}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#current_time").text(data.d.replace(" ",""));

        }
    });
}

function registration_day() {
    $.ajax({
        type: "POST",
        url: "/display.asmx/server_date_or_timewarp",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {
            $("#registration_day").text(data.d);
        }
    });

}


var $mq = $(".ticker");

function refreshNews() {

    var template_id = $("#template_id").val();
    var terminal_id = $("#terminal_id").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/get_message",
        data: "{'template_id': " + template_id + ", 'terminal_id': " + terminal_id + ", 'priority': false}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            console.log("Length: " + data.d.length);

            if (data.d.id < 1) {

                $mq.hide();
                showMarquee();

            } else {

                $mq.show();
                $mq.marquee('destroy');
                $mq.html(data.d.message);
                $mq.marquee({ duration: 10000 });
            }
        }
    });
}

$mq.bind('finished', showMarquee);

function showMarquee() {
    refreshNews();
}

function slideRight() {

    tweet();

    $(".twitter").css("left", "1580px");

    setTimeout(enterRight, 1000);
}

function enterRight() {
    $(".twitter").animate({ left: "40px" }, 500, "swing");
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

            $("#next_session").text(data.d.event_start + ': ' + data.d.name);

        }
    });
}

function background() {

    terminal_id = $("#terminal_id").val();

    $.ajax({
        type: "POST",
        url: "/display.asmx/template",
        data: "{'terminal': " + terminal_id + "}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $('#thebody').css('background-image', 'url("' + data.d + '")');

        }
    });
}

function tweet() {
    $.ajax({
        type: "POST",
        url: "/display.asmx/random",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) {

            $("#twitpic").attr('src', data.d.profilepic);
            $("#fullname").text(data.d.full_name);
            $("#username").text(data.d.username);
            $("#tweet").text(data.d.description);

            if (data.d.source != null) {

                console.log(data.d.source);

                $("#twitimg").html('<img src="' + data.d.source + '" />');
            } else {
                $("#twitimg").text('');
            }
        }
    });
}