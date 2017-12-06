<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="oc4_reg.aspx.cs" Inherits="fnsignDisplay.overlays.oc4_reg" %>


<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
		<script src="http://momentjs.com/downloads/moment.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
        
        
        
        <script src="/js/jquery.cookie.js" type="text/javascript"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/jquery.marquee/1.3.1/jquery.marquee.min.js"></script>
        
        <link href="//cloud.typenetwork.com/projects/400/fontface.css/" rel="stylesheet" type="text/css">
        <link href="fonts/stylesheet.css" rel="stylesheet" type="text/css" media="screen" />
		
		<style type="text/css">

			body { width: 1920px; height: 1080px; background-color: #000000; font-family: sans-serif;font-style: normal;font-weight: 400; font-size: 36px;color: #000000;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden; }	
			.wrapper { width: 1920px; height: 1080px;margin-left: 85px;margin-right: 85px;  }
			.content { position: absolute;top: 450px; font-family: sans-serif;font-style: normal;font-weight: normal;color: #4e4e4e;font-size: 52px;clear: both;overflow: hidden;height: 700px;width: 1720px; }
            .current-wrapper { position: relative;width: 910px; }
            .current-inner { position: absolute;z-index: 10;padding-top: 40px;padding-bottom: 40px;border-top-color: #494b4d;border-top-style: solid;border-top-width: 2.5px;border-bottom-color: #494b4d;border-bottom-style: solid;border-bottom-width: 2.5px;width: 910px; }
            .current-title {font-family: "Oculus Sans Light", sans-serif;font-size: 60px; margin-bottom:0px;color: #ffffff;clear: both; }
			.current-timespan {font-family: "Oculus Sans Medium", sans-serif;font-size: 52px;margin-top:0px;color: #11745b; }
			.row { clear: both;height:40px; }
            .scroll-wrapper { position: relative;width: 1720px;clear: both; }
            .scroll-wrapper-inner { position: absolute;top: 450px; font-family: sans-serif;font-style: normal;font-weight: normal;color: #4e4e4e;font-size: 52px;clear: both;overflow: hidden;height: 700px;width: 1720px; }
			.inner { position: absolute;width: 100%;overflow: visible;z-index: 2; }
            .inner-title {font-family: "Oculus Sans Light", sans-serif;font-size: 60px; margin-bottom:0px;color: #ffffff;clear: both; }
			.inner-timespan {font-family: "Oculus Sans Medium", sans-serif;font-size: 52px;margin-top:0px;color: #11745b;margin-bottom: 40px; }

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

            .type { font-family: "Oculus Sans Medium"; width: 210px;font-size: 35px;color: #11745b;float: left;position: relative;min-width: 210px;padding-right: 20px;  }
            .schedule_content { font-family: "Oculus Sans Medium"; width: 880px;font-size: 40px;float: left;color: #fff;position: relative; }
            .sched_time { font-family: "Oculus Sans Medium"; font-size: 30px;margin-left: 230px; }
            .reg_space {font-family: "Oculus Sans Medium"; width: 100%;height: 40px;clear: both; }

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
            <div class="scroll-wrapper-inner" style="width: 1720px;">
                <div class="inner" id="future_sessions">
                    <asp:PlaceHolder runat="server" ID="ph_sessions" />
                </div>
            </div>
        </div>
        
        <div class="ticker"></div>
        
        <script type="text/javascript" src="/js/display.js?ver=4.12.2.7"></script>
        

    
        <script type="text/javascript">

            //setInterval(refreshData, 7500);
            //setInterval(future, 50000);

            //refreshNews();


            $(document).ready(function () {
                manual();
            });

            function manual() {
                setTimeout(reloadMe, 80000);
            }

            function reloadMe() {
                window.location.href = window.location.href;
            }

            var theContent = '';
            var wasFull = false;

            $(document).ready(function () {
                summit();
            });

            function summit() {
                var height = $(".inner").height();

                var outerHeight = $(".scroll-wrapper-inner").height();

                var speed = 0;

                speed = ($(".inner").height() * 20);

                if (height > outerHeight) {
                    $(".inner").animate({ top: "-" + height }, speed, "linear", slideBottom);
                }

                //checkHeight();
            }



            function checkHeight() {

                var loc = $(".inner").position().top * -1;
                var height = $(".inner").height() * -1;

                if (loc < height) {
                    $(".inner").stop();

                    $(".inner").style("top", $(".inner").height());

                    slideBottom();
                } else {
                    checkHeight();
                }

            }

            function slideBottom() {

                $(".inner").css("top", $(".content").height() + "px");

                var height = $(".inner").height();

                var outerHeight = $(".content").height();

                var speed = 0;

                speed = ($(".inner").height() * 20);

                if (height > outerHeight) {
                    $(".inner").animate({ top: "-" + height }, speed, "linear", cycle);
                }
            }

            function cycle() {
                slideBottom();
            }
		
		</script>

    </form>
</body>
</html>
