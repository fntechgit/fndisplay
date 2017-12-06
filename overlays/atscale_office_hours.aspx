<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="atscale_office_hours.aspx.cs" Inherits="fnsignDisplay.overlays.atscale_office_hours" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    
    	<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link href="//cloud.typenetwork.com/projects/400/fontface.css/" rel="stylesheet" type="text/css">
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
			.content { position: absolute;top: 885px;overflow: hidden;height: 1005px;clear: both;margin-left: 100px;margin-right: 100px; }
			.session-type {font-family: "Titling Gothic FB Nar Bd";font-weight:800;font-size: 64px; margin-bottom:0px;color: #4e4e4e;width: 95%; }
			.session-title {font-family: "Titling Gothic FB Nar Standard";font-style: normal;font-weight: normal;font-size: 52px;margin-top:0px;color: #4e4e4e;margin-bottom: 70px; }
			
            .blue { color: #33a8df; }
            .red { color: #ff1c4d; }
            .green { color: #0fdd3c; }
            .orange { color: #f7ad1b; }
            .purple { color: #e23afc; }
			
			.left { float:left; }
			.right { float:right; }
			
			.ticker { position: absolute;top: 1850px;width: 100%; }
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

            .titlinggothicfbnarrowstandard{
                font-family: "Titling Gothic FB Nar Standard";
                font-style: Normal;
                font-weight: Normal;
            }

            .titlinggothicfbnarrowbold{
                font-family: "Titling Gothic FB Nar Bd";
                font-style: Normal;
                font-weight: Normal;
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
        <div class="content">
            <div class="session-type" id="start_time_to_end_time"><%= start_time %> - <%= end_time %></div>
            <div class="session-title" id="session_description">Take a break to meet with speakers for Q&A from the previous track sessions.</div>
            
            <div class="session-type" id="session_type"><%= category %> Track Speakers:</div>
            <div class="session-title" id="speakers_content">
                <asp:PlaceHolder runat="server" ID="ph_speakers"/>
            </div>
        </div>
    </div>
        
        <div class="ticker"></div>
        
    <script type="text/javascript" src="/js/display.js?ver=3.5.3.7"></script>
    
    <script type="text/javascript">

        
        setInterval(refreshOffice, 7500);
        refreshNews();
		
		</script>
        
        

    </form>
</body>
</html>
