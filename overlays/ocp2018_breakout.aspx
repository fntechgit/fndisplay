<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ocp2018_breakout.aspx.cs" Inherits="fnsignDisplay.overlays.ocp2018_breakout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
        
        <script src="/js/daily.js?ver=10.28.16" type="text/javascript"></script>
        
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link href="//cloud.typenetwork.com/projects/400/fontface.css/" rel="stylesheet" type="text/css">
        <link href="fonts/stylesheet.css" rel="stylesheet" type="text/css" media="screen" />
    
        <script src="https://use.typekit.net/uzf7lvs.js"></script>
        <script>try{Typekit.load({ async: true });}catch(e){}</script>
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;/*overflow: hidden;*/ }	
			.wrapper { width: 1080px; height: 1920px; }
			.content { position: absolute;top: 785px; font-family: "Titling Gothic FB Nar Standard";font-style: normal;font-weight: normal;color: #4e4e4e;font-size: 52px;clear: both;overflow: hidden;height: 1030px;width:910px: }
            .current-wrapper { position: relative;width: 910px; }
            .current-inner { position: absolute;z-index: 10;padding-top: 40px;padding-bottom: 40px;border-top-color: #494b4d;border-top-style: solid;border-top-width: 2.5px;border-bottom-color: #494b4d;border-bottom-style: solid;border-bottom-width: 2.5px;width: 910px; }
            .current-title {font-family: "Oculus Sans Light";font-size: 60px; margin-bottom:0px;color: #ffffff;clear: both; }
			.current-timespan {font-family: "Oculus Sans Medium";font-size: 52px;margin-top:0px;color: #777779; }
			.row { clear: both;height:40px; }
            .scroll-wrapper { position: relative;width: 910px;clear: both; }
            .scroll-wrapper-inner { position: absolute;top: 1125px; font-family: "Titling Gothic FB Nar Standard";font-style: normal;font-weight: normal;color: #4e4e4e;font-size: 52px;clear: both;overflow: hidden;height: 690px;width:910px: }
			.inner { position: absolute;width: 100%;overflow: visible;z-index: 2; }
            .inner-title {font-family: "Oculus Sans Light";font-size: 60px; margin-bottom:0px;color: #ffffff;clear: both; }
			.inner-timespan {font-family: "Oculus Sans Medium";font-size: 52px;margin-top:0px;color: #777779;margin-bottom: 40px; }

            .blue { color: #33a8df; }
			
			.left { float:left; }
			.right { float:right; }
        
			.ticker { position: absolute;top: 1850px;width: 100%;z-index: 9999; }
			.ticker div { float: left;margin-top: 0;font-family: "Titling Gothic FB Nar Bd";font-style: normal;font-weight: 500;color: #33a8df;font-size: 16px; }
			
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

            /* SPEAKERS SECTION */
            .speakers { padding-top: 24px;padding-bottom: 0px;width: 100%;clear: both; }
			.article-author { float: left;width: 50%;font-size: 50px;font-family: Helvetica;color: #4a4f55;margin-bottom: 25px; }
            .article-author-image { margin-right: 10px; }
            .article-author-image img { border-radius: 100%;float: left;width: 92px;height: 92px; }
            .article-author-details { align-self: center; }
            .article-author-name-container { font-size: 50px;font-family: Helvetica;color: #4a4f55; }
            .article-author-name { color: #33a8df; }
            .article-author-job-title { font-size: 50px;font-family: Helvetica;color: #4a4f55; }

            .Franklin-Gothic { font-family: "franklin-gothic-urw", sans-serif;}
            .medium { font-weight: 500; }
            .book { font-weight: 400; }

            .space { height: 50px;margin-bottom: 50px; }

            /* OCP 2018 HACKS */
            .sessions { width: 100%;position: relative;clear: both;height: 760px;overflow: hidden; }
            .session { width: 100%;float: left;position: relative;padding-right: 10px;margin-bottom: 50px; }
            .start-time { color: #63676b;font-family: "franklin-gothic-urw", sans-serif;font-weight: 500;font-size: 58px;float: left;text-transform: lowercase; }
            .session-title { color: #63676b;font-family: "franklin-gothic-urw", sans-serif;font-weight: 500;font-size: 58px;width: 98%;float: left; }
            .speaker-name { color: #63676b;font-family: "franklin-gothic-urw", sans-serif;font-weight: 400;font-size: 46px;width: 100%;float: left; }

            .future-sessions { width: 100%;position: absolute;}
            /*.future-sessions .session-title { border-bottom: 1px solid rgba(0,0,0,0.15); border-left: 1px solid transparent; border-radius: 4px; border-right: 1px solid rgba(0,0,0,0.15); border-top: 1px solid transparent; padding-left:5px; padding-bottom:3px;}*/

            .line {position: relative;float: left;width: 100%;height: 46px;background-image: url('/uploads/ocp_line.png');background-repeat: no-repeat; }

            .single { margin-top: 460px; }

            .bottom-overlay { width: 1080px;height: 341px;position: fixed;/*bottom: 0px;*/left: 0px;right: 0px;margin: 0;background-image: url('/uploads/ocp_bottom.jpg');z-index: 499; }

		    .session-type-block {width: 41px; height: 41px; border-radius: 21px; float:left; margin-top: 12px; margin-right: 15px;}
			#current_session_header div.session { height: 220px; padding-top:20px;}
			div.session {font-size: 58px; color: rgb(79,96,106); font-family: "Franklin Gothic";}
			.wrap { margin-left: 45px; }
			.time { background-color: #6adf32;font-family: "franklin-gothic-urw", sans-serif;color: #ffffff;font-weight: 500;padding: 15px;font-size: 24px;float: left; padding-top: 10px;    padding-bottom: 10px;    padding-right: 30px;    padding-left: 30px;}
            .session-time-block { width: 250px;float: left;}
            .session-speaker-block { width: 660px;float: left; padding-left:60px;}			
			.upcoming-sessions { color: #6adf32;font-family: "franklin-gothic-urw", sans-serif;font-size: 46px;font-weight: 500; margin-bottom: 50px; margin-left: 50px; }

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
            <div class="wrap">
                <div class="single" id="current_session_header">
                <div class="session">
                    <div class="session-type-block" id="current_type" style="background-color:<%= current_bgcolor %>"></div>
                    <div class="session-time-block">
                        <div class="start-time" id="current_time">
                            <%= DateTime.Now.ToShortTimeString() %>
                        </div>
                        <div class="time">
                            CURRENT TIME
                        </div>
                    </div>
                    <div class="session-speaker-block">
                        <div class="session-title" id="current_title">
                            <%= current_title %>
                        </div>
                        <div class="speaker-name" id="current_speaker">
                            <%= current_speaker %>
                        </div>
                    </div>
                </div>
            </div>
            </div>
            <div class="line"></div>
            <div class="wrap">
                <div class="upcoming-sessions">UPCOMING SESSIONS</div>
                <div class="sessions">
                    <div class="future-sessions" id="future_sessions">
                        <asp:PlaceHolder runat="server" ID="ph_sessions" />
                    </div>
                </div>
            </div>
        </div>
        
        <div class="ticker"></div>
        
        <div class="bottom-overlay"></div>
        
        <script type="text/javascript" src="/js/display.js?ver=7.1.1.4"></script>
    
        <script type="text/javascript">
            var scrollTop = 650;

            setInterval(refreshData_OCP_BREAKOUT_2018, 7500);
            setInterval(future, 50000);
            setInterval(session_full, 5000);
            setInterval(server_time, 5000);

                if ($("#future_sessions").height() > $("#sessions").height()) {
                    // make it scroll
                    $("#future_sessions").animate({ top: "-" + $("#future_sessions").height() }, ($("#future_sessions").height() * 20), "linear", slideBottom);
                }

            function slideBottom() {

                var height = $("#future_sessions").height();

                $("#future_sessions").css("top", scrollTop + "px");

                $("#future_sessions").animate({ top: "-" + height }, (height * 20), "linear", cycle);
            }

            function cycle() {
                slideBottom();
            }

            $(document).ready(function () {
                //$('div#current_title').css({ "font-size": '20px' });
            })
		
		</script>
    </form>
</body>
</html>
