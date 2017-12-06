<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="overlay_1920_summit.aspx.cs" Inherits="fnsignDisplay.overlays.overlay_1920_summit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
        
        <script src="/js/daily.js?ver=10.28.15" type="text/javascript"></script>
        
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
			.content { position: absolute;top: 230px;margin-top: 15px;width: 90%; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400;color: #ffffff;font-size: 24px;clear: both;overflow: hidden;height: 1250px; }
			.time {font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 800; margin-top: 340px; font-size: 50px; margin-bottom:0px;color: #ffffff;width: 100%; }
			.session {font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;font-weight:bold;margin-bottom: 40px;margin-top:0px;color: #82262f; }
			.row { clear: both;height:40px; }
			.session-time { font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 800; margin-top: 15px;margin-bottom: 15px; font-size: 36px; color: #ffffff;width: 100%;clear: both; }
			.left { float: left;width: 70%;padding-top: 10px;}
			.right { float: right;width: 30%;padding-top: 10px;}
			.inner { position: absolute;}
			
			#current_date { text-transform: uppercase; }

            .ticker { position: absolute;top: 1850px;width: 100%; }
			.ticker div { float: left;margin-top: 0;font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 500;color: #ac3d72;font-size: 50px; }
			
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
                <div class="inner">
                <asp:PlaceHolder runat="server" ID="ph_sessions" />
                </div>
            </div>
        </div>
        
        <div class="ticker"></div>
        
        <script type="text/javascript" src="/js/display.js?ver=2.1.1.2"></script>
    
    <script type="text/javascript">

        refreshNews();
		
		</script>

    </form>
</body>
</html>

