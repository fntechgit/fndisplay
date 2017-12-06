<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="overlay_housekeeping_slides.aspx.cs" Inherits="fnsignDisplay.overlays.overlay_housekeeping_slides" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        
        <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			#wrapper { width: 1080px; height: 1920px;padding: 0;  }
			#deck {position: absolute;width: 100%;height: 100%; }
			#slides {position: relative;height: 1920px;width: 26880px;left: 0; }
			.slide { width: 1080px;height: 1920px;float: left; }
			
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
    
    <asp:Panel runat="server" ID="video_bg" Visible="false">
    <video autoplay loop id="bgvid">
        <source src="http://fnsign.fntech.com/uploads/<%= video %>" type="video/mp4">
    </video>
    </asp:Panel>     

    <div id="wrapper">
        <div id="deck">
            <div id="slides">
                <asp:PlaceHolder runat="server" ID="ph_slides" />
            </div>
        </div>    
    </div>

    </form>
    
    <script type="text/javascript">

        var leftval = 0;
        var slide_count = 0;

        function rotate() {

            if (slide_count >= 1) {

                leftval = 0;
                slide_count = 0;

                $("#slides").animate({ left: leftval }, 500, "swing");
            } else {
                leftval = leftval - 1080;
                slide_count++;

                $("#slides").animate({ left: leftval }, 500, "swing");
            }

        }

        setInterval(rotate, 15000);

    </script>

</body>
</html>
