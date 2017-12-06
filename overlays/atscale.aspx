<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="atscale.aspx.cs" Inherits="fnsignDisplay.overlays.atscale" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
        
        <script src="/js/daily.js?ver=8.29.17" type="text/javascript"></script>
        
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link href="//cloud.typenetwork.com/projects/400/fontface.css/" rel="stylesheet" type="text/css">
		
		<style type="text/css">

			body { width: 1080px; height: 1920px; background-color: #000000; font-family: "Gotham Narrow A", "Gotham Narrow B";font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1080px; height: 1920px;padding: 40px;  }
			.content { position: absolute;top: 615px;width: 90%; font-family: "Titling Gothic FB Nar Standard";font-style: normal;font-weight: normal;color: #4e4e4e;font-size: 52px;clear: both;overflow: hidden;height: 1265px; }
            .session-type {font-family: "Titling Gothic FB Nar Bd";font-weight:800;font-size: 64px; margin-bottom:0px;color: #4e4e4e;clear: both; }
			.session-title {font-family: "Titling Gothic FB Nar Standard";font-style: normal;font-weight: normal;font-size: 52px;margin-top:0px;color: #4e4e4e;margin-bottom: 10px;margin-right: 20px; }
			.row { clear: both;height:40px; }
			.inner { position: absolute;width: 1000px;overflow: visible; }

            .blue { color: #33a8df; }
            .red { color: #ff1c4d; }
            .green { color: #0fdd3c; }
            .orange { color: #f7ad1b; }
            .purple { color: #e23afc; }
			
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
            .article-author-job-title { font-size: 50px;font-family: Helvetica;color: #4a4f55; }

            .space { height: 50px;margin-bottom: 50px; }

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
