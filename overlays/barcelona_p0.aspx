<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="barcelona_p0.aspx.cs" Inherits="fnsignDisplay.overlays.barcelona_p0" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    
    	<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
    
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
			.session-type-big {font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; margin-top: 240px; font-size: 80px; margin-bottom:0px;color: #ffffff;width: 100%; }
			.session-type {font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; margin-top: 240px; font-size: 50px; margin-bottom:0px;color: #ffffff;width: 100%; }
			.session-title {font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;font-weight:bold;margin-bottom: 40px;margin-top:0px;color: #ffde2d; }
			.time-block { position: absolute;top: 540px; }
			.start-time { margin-top: 0;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 80px;float: left;width: 500px; }
			.current-time { float: left;margin-top: 20px;color: #eb1f48;font-size: 45px;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; }
			.next-block { position: absolute;top: 650px;width: 100%; }
			.next-header {clear: both;margin-top: 50px;color: #fccc1d;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;font-size: 35px; }
			.next-session {position: relative;color: #ffffff;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;font-size: 36px;width: 90%; }
            .next-session-small {position: relative;color: #ffffff;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;font-size: 28px;width: 90%; }
			.left { float:left; }
			.right { float:right; }
			.next { margin-top: 55px;font-size: 24px; }
			#current_date { text-transform: uppercase; }
			.twitter {position: absolute;top: 1010px;width: 100%; }
			.pic { float: left; }
			.pic img { width: 128px; }
			.twithead { float: left;margin-left: 10px; }
			#fullname { font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 48px; }
			#username { font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 36px; }
			.tweet {margin-top: 15px;width: 90%; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 36px;clear: both; }
			.twitimg { margin-top: 15px;width: 100%; }
			.twitimg img { max-height: 250px; }

            .ticker { position: absolute;top: 1850px;width: 100%; }
			.ticker div { float: left;margin-top: 0;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 500;color: #740b24;font-size: 38px; }
			
			.announcement { position: absolute;top: 1010px;width: 100%; }
			#message_title { font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 48px; }
			#message { margin-top: 15px;width: 90%; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 36px;clear: both; }
			#message_img { margin-top: 15px;width: 100%; }
			#message_img img { max-height: 250px; }
			
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
<body id="thebody">
    <form id="form1" runat="server">
    
    <asp:HiddenField runat="server" ID="event_id" />
    <asp:HiddenField runat="server" ID="template_id" />
    <asp:HiddenField runat="server" ID="location_sched" />
    <asp:HiddenField runat="server" ID="terminal_id" />
    
    <asp:Panel runat="server" ID="video_bg" Visible="false">
    <video autoplay loop id="bgvid">
        <source src="http://fnsign.fntech.com/uploads/<%= video %>" type="video/mp4">
    </video>
    </asp:Panel>

    <div class="wrapper">
        <div class="session-type-big" id="session_title" runat="server"><%= session_title_val %></div>
        <div class="session-title" id="session_type"><%= session_type %></div>
        <div class="time-block">
            <div class="start-time" id="start_time"><%= start_time %></div>
            <div class="current-time" id="current_time">CURRENT TIME IS <span id="current_date"></span></div>
        </div>
        <div style="clear:both;"></div>
        <div class="next-block">
            <div class="next-header">NEXT SESSION</div>
            <div class="next-session" id="next_session"><%= next_session %></div>
        </div>
        
        <div class="twitter">
            <div class="pic">
                <img src="<%= twitpic %>" id="twitpic"/>
            </div>
            <div class="twithead">
                <span id="fullname"><%= m.full_name %></span>
                <br />
                <span id="username"><%= m.username %></span>
            </div>
            <div class="tweet" id="tweet">
                <%= m.description %>
            </div>
            <div class="twitimg" id="twitimg">
                <%= twitimg %>
            </div>
        </div>
        
        <div class="announcement" style="display:none;">
            <div id="message_title"></div>
            <div id="message"></div>
            <div id="message_img"></div>
        </div>
        


    </div>
        
    <div class="ticker"></div>
    
    <script type="text/javascript">

        function setDate() {

            $("#current_date").text(moment().format('h:mm a'));

        }

        //setInterval(setDate, 1000);
		
    </script>
        
        <script type="text/javascript" src="/js/display.js?ver=B.2"></script>
        
        <script type="text/javascript">
            
            setInterval(refreshData, 7500);
            //refreshNews();

        </script>

    </form>
</body>
</html>
