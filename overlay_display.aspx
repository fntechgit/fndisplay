<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="overlay_display.aspx.cs" Inherits="fnsignDisplay.overlay_display" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
        <script src="https://use.fontawesome.com/07105a45a7.js"></script>
    
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="//momentjs.com/downloads/moment.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <script src="/js/daily.js?ver=10.28.17.C" type="text/javascript"></script>
        <script src="/js/twitter.js?ver=4.26.17.D" type="text/javascript"></script>
        <script src="/js/ticker.js?ver=4.26.17.I3" typte="text/javascript"></script>
        <script src="/js/production.js?ver=4.27.17.B" type="text/javascript"></script>
        
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link href="//cloud.typenetwork.com/projects/400/fontface.css/" rel="stylesheet" type="text/css">
    
        <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />
    
        <script src="https://use.typekit.net/uzf7lvs.js"></script>
        <script>try{Typekit.load({ async: true });}catch(e){}</script>
		                                                    
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('http://fnsign.azurewebsites.net/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;/*overflow: hidden;*/ }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
            .theme-options { position: absolute; }
            .fr-marker { visibility: hidden; }
            .fa-code { visibility: hidden; }

            .repeater { position: relative;float: left;width: 100%;margin-bottom: 0px;clear: both;display: inline-block; margin-bottom:80px; }
            .repeater:after { clear: both;content: "";display: table;}

            #scrolling_size { overflow: hidden; }
            #announcement_ticker { overflow: visible; }
			
			video#bgvid { 
                position: fixed;
                top: 50%;
                left: 50%;
                min-width: 100%;
                min-height: 100%;
                width: auto;
                height: auto;
                z-index: -100;
                -webkit-transform: translateX(-50%) translateY(-50%);
                transform: translateX(-50%) translateY(-50%);
                background: url(polina.jpg) no-repeat;
                background-size: cover; 
            }

            .space { height: 50px;margin-bottom: 50px; }
            textarea { display: none; }

            .control { float: left;margin-right: 15px; }
            .right { float: right; }

            .bottom-overlay { width: 1080px;height: <%= o.bottom_height %>px;position: fixed;/*bottom: 0px;*/left: 0px;right: 0px;margin: 0;background-image: url('/uploads/<%= o.bottom_overlay %>');z-index: 499; }

            /*#speaker_name { height:30%!important;top:0%!important;}*/
            /*#session_title { height:70%!important;}*/
		</style>
    
    <style type="text/css">
        #controls { width: 100%;float: left;height: 35px;position: fixed;top: 0;left: 0;background-color: #cccccc;z-index: 1000;}
        #preview { width: 1080px; height:1920px; }

    </style>

</head>
<body>
    <form id="form1" runat="server">
    
        <asp:HiddenField runat="server" ID="event_id" />
        <asp:HiddenField runat="server" ID="template_id" />
        <asp:HiddenField runat="server" ID="location_sched" />
        <asp:HiddenField runat="server" ID="terminal_id" />
        <asp:HiddenField runat="server" ID="current_date" />
        <asp:HiddenField runat="server" ID="scroll_speed"/>
        
        <asp:HiddenField runat="server" ID="hdn_session_title" />
        <asp:HiddenField runat="server" ID="hdn_session_category" />
        <asp:HiddenField runat="server" ID="hdn_session_location" />
        <asp:HiddenField runat="server" ID="hdn_session_start" />
        <asp:HiddenField runat="server" ID="hdn_session_start_time"/>
        <asp:HiddenField runat="server" ID="hdn_session_end_time"/>
        <asp:HiddenField runat="server" ID="hdn_session_description"/>
        <asp:HiddenField runat="server" ID="hdn_speaker_name"/>
        <asp:HiddenField runat="server" ID="hdn_current_server_time"/>
        <asp:HiddenField runat="server" ID="hdn_multiple"/>
        
        <asp:HiddenField runat="server" ID="hdn_next_session_title" />
        <asp:HiddenField runat="server" ID="hdn_next_session_start_time"/>
        
        <asp:HiddenField runat="server" ID="hdn_multiple_session_title" />
        <asp:HiddenField runat="server" ID="hdn_multiple_session_location" />
        <asp:HiddenField runat="server" ID="hdn_multiple_session_start" />
        <asp:HiddenField runat="server" ID="hdn_multiple_session_start_time"/>
        <asp:HiddenField runat="server" ID="hdn_multiple_session_end_time"/>
        <asp:HiddenField runat="server" ID="hdn_multiple_session_description"/>
        <asp:HiddenField runat="server" ID="hdn_multiple_speaker_name"/>

        <asp:HiddenField runat="server" ID="hdn_group_by_start" />
        <asp:HiddenField runat="server" ID="hdn_group_by_location" />
        
        <asp:HiddenField runat="server" ID="is_announcement_template" />
        <asp:HiddenField runat="server" ID="is_end_of_day_template" />
        <asp:HiddenField runat="server" ID="regular_overlay" />
        <asp:HiddenField runat="server" ID="announcement_overlay" />
        <asp:HiddenField runat="server" ID="end_of_day_template" />
        
        <asp:HiddenField runat="server" ID="announcement_title" />
        <asp:HiddenField runat="server" ID="announcement_description" />
        <asp:HiddenField runat="server" ID="announcement_image" />
        
        <asp:HiddenField runat="server" ID="end_of_day_title" />
        <asp:HiddenField runat="server" ID="end_of_day_category" />
        <asp:HiddenField runat="server" ID="end_of_day_time" />
        <asp:HiddenField runat="server" ID="end_of_day_description" />
        
        <asp:HiddenField runat="server" ID="location_id" />

        <asp:HiddenField runat="server" ID="full_session_graphic"/>
        
        <asp:Panel runat="server" ID="video_bg" Visible="false">
            <video autoplay loop id="bgvid">
                <source src="http://fnsign.fntech.com/uploads/<%= video %>" type="video/mp4">
            </video>
        </asp:Panel>

        <div id="wrapper">
            <div id="preview">
                <asp:PlaceHolder runat="server" ID="ph_content"></asp:PlaceHolder>
            </div>
        </div>

    </form>
    
    <div id="hidden" style="visibility: hidden;">
        
    </div>
        
    <div class="bottom-overlay"></div>

    <script type="text/javascript">

        setInterval(session_full, 5000);
        setInterval(twitter, 10000);

        refreshNews();

        $(document).ready(function () {

            var $repeating_styles = "";

            $repeating_styles = $("#repeating_panel").html();

            $("#hidden").html($repeating_styles);

            $("#repeating_panel").html('');

            var group_location = $("#hdn_group_by_location").val();
            var group_start = $("#hdn_group_by_start").val();

            if (group_start === true) {
                group_location = false;
            }

            var old_location = '';
            var old_start = '';
            var old_time = '';

            if ($("#priority_title").length) {
                $("#priority_title .fr-editor").html($("#priority_title .fr-editor").html().replace(/{.+}/, $("#announcement_title").val()));
            }

            if ($("#priority_description").length) {
                $("#priority_description .fr-editor").html($("#priority_description .fr-editor").html().replace(/{.+}/, $("#announcement_description").val()));
            }

            if ($("#priority_image").length) {
                if ($("#announcement_image").val() != '') {
                    $("#priority_image .fr-editor").html($("#priority_image .fr-editor").html().replace(/{.+}/, "<img src=\"/uploads/" + $("#announcement_image").val() + "\" />"));
                }
            }

            // single current view
            if ($("#session_title").length) {
                $("#session_title .fr-editor").html($("#session_title .fr-editor").html().replace(/{.+}/, '<span id="the_session_title">' + $("#hdn_session_title").val() + '</span>'));
            }

            if ($("#session_category").length) {
                $("#session_category .fr-editor").html($("#session_category .fr-editor").html().replace(/{.+}/, '<span id="the_session_category">' + $("#hdn_session_category").val() + '</span>'));
            }

            if ($("#session_location").length) {
                $("#session_location .fr-editor").html($("#session_location .fr-editor").html().replace(/{.+}/, $("#hdn_session_location").val()));
            }

            if ($("#session_start_time").length) {
                $("#session_start_time .fr-editor").html($("#session_start_time .fr-editor").html().replace(/{.+}/, '<span id="the_session_start_time">' + $("#hdn_session_start_time").val() + '</span>'));
            }

            if ($("#session_start_date").length) {
                $("#session_start_date .fr-editor").html($("#session_start_date .fr-editor").html().replace(/{.+}/, $("#hdn_session_start").val()));
            }

            if ($("#session_end_time").length) {
                $("#session_end_time .fr-editor").html($("#session_end_time .fr-editor").html().replace(/{.+}/, $("#hdn_session_end_time").val()));
            }

            if ($("#session_description").length) {
                $("#session_description .fr-editor").html($("#session_description .fr-editor").html().replace(/{.+}/, $("#hdn_session_description").val()));
            }

            if ($("#speaker_name").length) {
                $("#speaker_name .fr-editor").html($("#speaker_name .fr-editor").html().replace(/{.+}/, $("#hdn_speaker_name").val()));
            }

            // DESKTOP TIME
            if ($("#current_desktop_time").length) {
                $("#current_desktop_time .fr-editor").html($("#current_desktop_time .fr-editor").html().replace(/{.+}/, '<span id="current_time">' + formatAMPM() + '</span>'));
                old_time = formatAMPM();
            }

            // next session
            if ($("#next_session_title").length) {
                $("#next_session_title .fr-editor").html($("#next_session_title .fr-editor").html().replace(/{.+}/, $("#hdn_next_session_title").val()));
            }

            if ($("#next_session_start_time").length) {
                $("#next_session_start_time .fr-editor").html($("#next_session_start_time .fr-editor").html().replace(/{.+}/, $("#hdn_next_session_start_time").val()));
            }

            if ($("#next_session_start_time_and_title").length) {
                $("#next_session_start_time_and_title .fr-editor").html($("#next_session_start_time_and_title .fr-editor").html().replace(/{.+}/, '<span id="the_next_session">' + $("#hdn_next_session_start_time").val() + ': ' + $("#hdn_next_session_title").val() + '</span>'));
            }

            $("#hidden").html($repeating_styles);

            // multiple
            if ($("#hdn_multiple").val() == 'True') {

                // loop and render mulitple
                var session_titles = $("#hdn_multiple_session_title").val().split(",;,");
                var session_starts = $("#hdn_multiple_session_start_time").val().split(',;,');
                var session_speakers = $("#hdn_multiple_speaker_name").val().split(',;,');
                var session_locations = $("#hdn_multiple_session_location").val().split(',;,');

                $.each(session_titles, function(index, value) {

                    //console.log(value);

                    var mult = 200;

                    if (index > 0) {
                        if ($("#hidden #session_title").length) {

                            //$("#hidden #session_title .fr-editor").html($("#hidden #session_title .fr-editor").html().replace(session_titles[index - 1], session_titles[index]));
                            
                            $("#hidden #hidden_session_title").text(value);

                        }

                        if ($("#hidden #session_title .fr-element").length) {
                            $("#hidden #session_title .fr-element").html($("#hidden #session_title .fr-element").html().replace(session_titles[index - 1], session_titles[index]));
                        }

                        if (group_start === 'true') {
                            if ($("#hidden #session_start_time").length) {
                                if (old_start !== session_starts[index]) {
                                    $("#hidden #session_start_time .fr-editor").html($("#hidden #session_start_time .fr-editor").html().replace(session_starts[index - 1], session_starts[index]));
                                    $("#hidden #session_start_time .fr-editor").html($("#hidden #session_start_time .fr-editor").html().replace('<span id="replace_start_time"></span>', session_starts[index]));
                                } else {
                                    $("#hidden #session_start_time .fr-editor").html($("#hidden #session_start_time .fr-editor").html().replace(session_starts[index - 1], '<span id="replace_start_time"></span>'));
                                }

                                old_start = session_starts[index];
                            }
                        } else {
                            if ($("#hidden #session_start_time").length) {
                                $("#hidden #session_start_time .fr-editor").html($("#hidden #session_start_time .fr-editor").html().replace(session_starts[index - 1], session_starts[index]));
                                //$("#hidden #session_start_time .fr-element").html($("#hidden #session_start_time .fr-element").html().replace(session_starts[index - 1], session_starts[index]));
                            }
                        }

                        if ($("#hidden #speaker_name").length) {
                            $("#hidden #speaker_name .fr-editor").html($("#hidden #speaker_name .fr-editor").html().replace(session_speakers[index - 1], session_speakers[index]));
                        }

                        if (group_location === 'true') {

                            if (old_location !== session_locations[index]) {
                                $("#hidden #session_location .fr-editor").html($("#hidden #session_location .fr-editor").html().replace(session_locations[index - 1], session_locations[index]));
                                $("#hidden #session_location .fr-editor").html($("#hidden #session_location .fr-editor").html().replace('<span id="replace_location"></span>', session_locations[index]));
                            } else {
                                $("#hidden #session_location .fr-editor").html($("#hidden #session_location .fr-editor").html().replace(session_locations[index - 1], '<span id="replace_location"></span>'));
                            }

                            old_location = session_locations[index];

                        } else {
                            if ($("#hidden #session_location").length) {
                                $("#hidden #session_location .fr-editor").html($("#hidden #session_location .fr-editor").html().replace(session_locations[index - 1], session_locations[index]));
                            }
                        }

                    } else {
                        if ($("#hidden #session_title").length) {
                            $("#hidden #session_title .fr-editor").html($("#hidden #session_title .fr-editor").html().replace(/{.+}/, '<span id="hidden_session_title">' + session_titles[index] + '</span>'));
                            //$("#hidden #session_title .fr-element").html($("#hidden #session_title .fr-element").html().replace(/{.+}/, session_titles[index]));
                        }

                        if ($("#hidden #session_start_time").length) {
                            $("#hidden #session_start_time .fr-editor").html($("#hidden #session_start_time .fr-editor").html().replace(/{.+}/, session_starts[index]));
                            //$("#hidden #session_start_time .fr-element").html($("#hidden #session_start_time .fr-element").html().replace(/{.+}/, session_starts[index]));

                            old_start = session_starts[index];
                        }

                        if ($("#hidden #speaker_name").length) {
                            $("#hidden #speaker_name .fr-editor").html($("#hidden #speaker_name .fr-editor").html().replace(/{.+}/, session_speakers[index]));
                        }

                        if ($("#hidden #session_location").length) {
                            $("#hidden #session_location .fr-editor").html($("#hidden #session_location .fr-editor").html().replace(/{.+}/, session_locations[index]));

                            old_location = session_locations[index];
                        }
                    }

                    $("#hidden #speaker_name").css("top", ($("#hidden #session_title .fr-editor").height() + 5) + "px");

                    var totalHeight = 0;

                    $(".repeating-help").remove();

                    //$("#hidden").children().each(function () {
                    //    totalHeight = totalHeight + $(this).height();
                    //});

                    //totalHeight = totalHeight * .8;

                    $("#hidden .ui-resizable").each(function(index) {
                        totalHeight += $(this).height();
                    });

                    //totalHeight = $("#hidden .ui-resizable").height();

                    ////$("#repeating_panel").append('<div class="repeater">' + $("#hidden").html().replace('%26', '&') + '</div>');
                    $("#repeating_panel").append('<div class="repeater" style="height: ' + totalHeight + 'px;">' + $("#hidden").html() + '</div>');
                });

            }

            slideBottomNow();

            /*setInterval(function() {

                var height = $("#repeating_size").height() * -1;
                var top = $("#repeating_block").position().top;

                if (top < height) {
                    $("#repeating_block").stop();

                    slideBottomNow();
                }

            }, 1000);*/


             
            //$(".theme-options").each(function (index) {
            //    var leftValue = $(this).offset().left;

            //    if (leftValue < 0) {
            //        leftValue = leftValue + 356;

            //        $(this).css("left", leftValue);
            //    }
            //});

            setInterval(function () { server_time(old_time) }, 1000);
            setInterval(refreshData, 5000);
            setInterval(next, 5000);

        });

        function slideBottomNow() {

            console.log("Running Slide BOttoom Now");

            var height = $("#repeating_size").height();

            var speed = $("#scroll_speed").val();

            if (speed < 1) {
                speed = ($("#repeating_size").height() * 20);
            } else {
                speed = ($("#scroll_speed").val() * 1);
            }

            var top = $("#scrolling_block").height();
            top = 0;
            $("#repeating_block").css("top", top + "px");

            height = 4572;
            speed = 50000;
            $("#repeating_block").animate({ top: "-" + height }, speed, "linear", cycle);
        }

        function cycle() {
            slideBottomNow();
        }

        function formatAMPM() {

            var date = new Date($.now());

            var hours = date.getHours();
            var minutes = date.getMinutes();
            var ampm = hours >= 12 ? 'pm' : 'am';
            hours = hours % 12;
            hours = hours ? hours : 12; // the hour '0' should be '12'
            minutes = minutes < 10 ? '0' + minutes : minutes;
            var strTime = hours + ':' + minutes + ' ' + ampm;
            return strTime;
        }

        function server_time(old_time) {
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

                    if ($("#current_desktop_time").length) {
                        $("#current_time").text(data.d);
                        old_time = data.d;
                    }

                }
            });
        }

    </script>

</body>
</html>
