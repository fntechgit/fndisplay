<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="f8_2018.aspx.cs" Inherits="fnsignDisplay.overlays.f8_2018" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="/js/display.js?ver=7.1.1.4"></script>

    <script type="text/javascript">
        setInterval(refreshF8Current, 5000);
    </script>

    <style type="text/css">
    	body { width: 1920px; height: 1080px; overflow:hidden; background-color:<%= bgcolor %>}	
        .wrapper { width: 1920px; height: 1080px; }
		.content { position: absolute;top: 85px; color:#ffffff; font-family: "Titling Gothic FB Nar Standard";
                   font-style: normal; font-weight: normal;
                   font-size: 52px;clear: both;
                   overflow: hidden;
                   height: 1030px;
                   width: 1500px;
                   margin-left: 120px;
		}


        .speaker-company, .current-time, .next-title { color: <%= font_color %> }

        .speaker-list {position: absolute; top: 640px; width: 900px;}
        .speaker-name { float:left; padding-right: 20px;}
        .speaker { font-size: 33px; letter-spacing: 3px; line-height: 50px; font-family: "Graphik"; font-weight: bold;}

        .current-time-separator {margin: 0px 30px; float:left; position: relative; top: 22%; transform: translateY(-50%); }
        .current-time {font-size: 50px; font-family: "Trim Mono"; height: 100px; margin-top: 90px;}
        .current-start-time { float:left; }

        .current-title { font-size: 112px; font-family: "Graphik"; font-weight: bold; padding-bottom: 150px;}

        .next-title { font-size: 27px; letter-spacing: 1px; font-family: "Graphik"; font-weight: bold; position: absolute; top: 850px;}
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="location_sched" />

        <div class="wrapper">
            <div class="content">

                <div class="current-time">
                    <div class="current-start-time"><%= current_start_time %></div>
                    <div class="current-time-separator"><%= current_time_separator %></div>
                    <div class="current-end-time"><%= current_end_time %></div>
                </div>

                <div class="current-title"><%= current_title %></div>

                <div class="speaker-list">
                    <asp:PlaceHolder runat="server" ID="ph_speakers" />
                </div>
                
                <div class="next-title">UP NEXT: <%= next_title %></div>

            </div>
        </div>
    </form>
</body>
</html>
