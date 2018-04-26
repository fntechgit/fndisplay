<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="f8_2018.aspx.cs" Inherits="fnsignDisplay.overlays.f8_2018" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="/js/jquery.cookie.js" type="text/javascript"></script>
    <script src="/js/display.js?ver=7.1.1.4"></script>

    <script type="text/javascript">
        setInterval(refreshF8EntryPoint, 15000);

        $(document).ready(function () {
            refreshF8EntryPoint();
        })
    </script>

    <style type="text/css">
        @font-face {
            font-family: Graphik;
            src: url("../overlays/fonts/graphik/Graphik-Regular.otf") format('opentype');
        }

        @font-face {
            font-family: Graphik;
            font-weight: bold;
            src: url("../overlays/fonts/graphik/Graphik-Bold.otf") format('opentype');
        }

        @font-face {
            font-family: Trim Mono;
            src: url("../overlays/fonts/trim-mono/TrimMono-Regular.ttf") format('truetype');
        }

    	body { width: 1920px; height: 1080px; overflow:hidden; background-color:<%= bgcolor %>}	
        .wrapper { width: 1920px; height: 1080px;}
		.content { position: absolute;top: 85px; color:#ffffff;
                   font-style: normal; font-weight: normal;
                   font-size: 52px;clear: both;
                   overflow: hidden;
                   height: 1030px;
                   width: 1500px;
                   margin-left: 120px;
		}


        .circle {  height: 25px; width: 25px;   border-radius: 50%;   border: 2px solid;   position: relative; background-color: <%= font_color %>; float:left;}
        .circle:before {   content: "";   display: block;   position: absolute;   z-index: 1;   top: -100px;   left: 50%;   border: 1px dotted;   border-width: 0 0 0 1px;   width: 1px;   height: 120px; background-color: <%= font_color %>;}
        
        .speaker-company, .current-time, .next-title, .current-full, .end-of-day, .bod-content { color: <%= font_color %> }

        .current-full { font-size: 112px; font-family: "Graphik"; font-weight: bold; position:absolute; top:500px; left:580px; }
        .end-of-day { font-size: 112px; font-family: "Graphik"; font-weight: bold; position:absolute; top:450px; width:75%; text-align: center; left:230px;}
        .pre-bod { font-size: 112px; font-family: "Trim Mono"; font-weight: bold; position:absolute; top:450px; width:75%; text-align: center; left:230px; color:#ffffff;}

        .bod-wrapper { }
        .bod-header { font-size: 112px; font-family: "Graphik"; font-weight: bold; color:#ffffff; float: left; height: 1080px; width: 520px; top:200px; left:200px;  position: absolute;}
        .bod-content { font-size: 42px; position: absolute; width: 1100px; left: 750px; padding:40px;}
        .bod-session {  }
        .bod-session-title {letter-spacing: 1px; font-family: "Graphik"; width:750px; height:150px; float:left; padding-left:40px;}
        .bod-session-start {font-family: "Trim Mono"; width:180px; float:left;text-align:right;padding-right:70px; height:150px;}

        .speaker-list {position: absolute; top: 680px; width: 1500px;}
        .speaker-name { float:left; padding-right: 20px;}
        .speaker { font-size: 33px; letter-spacing: 3px; line-height: 50px; font-family: "Graphik"; font-weight: bold;}

        .current-time-separator {margin: 0px 30px; float:left; position: relative; top: 22%; transform: translateY(-50%); }
        .current-time {font-size: 50px; font-family: "Trim Mono"; height: 100px; margin-top: 90px;}
        .current-start-time { float:left; }

        .current-title { font-size: 112px; font-family: "Graphik"; font-weight: bold; padding-bottom: 150px;}

        .next-title { font-size: 27px; letter-spacing: 1px; font-family: "Graphik"; font-weight: bold; position: absolute; top: 890px;}
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="location_sched" />

        <div class="wrapper">
            <div class="pre-bod" style="display:none ;"></div>
            <div class="current-full" style="display:none ;"></div>
            <div class="end-of-day" style="display:none ;"></div>
            <div class="bod-wrapper" style="display:none ;">
                <div class="bod-header">Today's Sessions
                </div>
                <div class="bod-content">
                </div>
            </div>

            <div class="content" style="display:none ;">
                <div class="current-time">
                    <div class="current-start-time"><%= current_start_time %></div>
                    <div class="current-time-separator"><%= current_time_separator %></div>
                    <div class="current-end-time"><%= current_end_time %></div>
                </div>

                <div class="current-title"><%= current_title %></div>

                <div class="speaker-list">
                    <asp:PlaceHolder runat="server" ID="ph_speakers" />
                </div>
                
                <div class="next-title"><%= next_title %></div>

            </div>
        </div>
    </form>
</body>
</html>
