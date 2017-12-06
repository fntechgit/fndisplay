<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="overlay_ocp.aspx.cs" Inherits="fnsignDisplay.overlays.overlay_ocp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: Helvetica, Arial;font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
			.content { position: absolute;top: 230px;margin-top: 15px;width: 1000px; font-family: Helvetica, Arial;font-style: normal;font-weight: 400;color: #000;font-size: 32px;clear: both; }
			.time {font-family: Helvetica, Arial;font-style: normal;font-weight: 800; margin-top: 340px; font-size: 50px; margin-bottom:0px;color: #000000; }
			.session {font-family: Helvetica, Arial;font-style: normal;font-weight: 400; font-size: 36px;font-weight:bold;margin-bottom: 40px;margin-top:0px;color: #82262f; }
			.row { clear: both;height:40px; }
			.left { float: left;width: 20%;padding-top: 20px;}
			.right { float: right;width: 80%;padding-top: 20px;}
			
			.ticker { position: absolute;left: 0;top:1850px;width: 800px;height: 75px;overflow: hidden; }
			.ticker div { float: left;font-family: Helvetica, Arial;font-style: normal;font-weight: 600;font-size: 18px;color: #fff; }
			
			#current_date { text-transform: uppercase; }
			
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
			
		</style>

</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="event_id" />
        <asp:HiddenField runat="server" ID="template_id" />
        <asp:HiddenField runat="server" ID="location_sched" />
        <asp:HiddenField runat="server" ID="terminal_id" />
        <asp:HiddenField runat="server" ID="current_date" />
        
        <asp:Panel runat="server" ID="video_bg" Visible="false">
    <video autoplay loop id="bgvid">
        <source src="http://fnsign.fntech.com/uploads/<%= video %>" type="video/mp4">
    </video>
    </asp:Panel>

        <div class="wrapper">
            <div class="content">
                <asp:PlaceHolder runat="server" ID="ph_sessions" />
            </div>
            
            <div class="ticker">
                
            </div>

        </div>
    </form>
    
    <script type="text/javascript">
        
        function refreshData() {

            $.ajax({
                type: "POST",
                url: "/display.asmx/future",
                //data: "{'location': '" + location_id + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data, status) {

                    console.log("Length: " + data.d.length);

                    if (data.d.length == 0) {

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

                        $(".content").html('');

                        $.each(data.d, function() {

                            $(".content").append('<div class="row"><div class="left">' + this['event_start'] + '</div><div class="right">' + this['name'] + '</div></div>');

                        });

                    }
                }
            });

        }

        var $mq = $(".ticker");

        function refreshNews() {

            var template_id = 1023;
            var terminal_id = $("#terminal_id").val();

            $.ajax({
                type: "POST",
                url: "/display.asmx/get_message",
                data: "{'template_id': " + template_id + ", 'terminal_id': " + terminal_id + "}",
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

        setInterval(refreshData, 5000);
        refreshNews();

    </script>
</body>
</html>
