<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="vertical.aspx.cs" Inherits="fnsignDisplay.vertical" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
    <script src="/js/jquery.cookie.js" type="text/javascript"></script>
    <script src="http://momentjs.com/downloads/moment.min.js"></script>

    <link rel="stylesheet" type="text/css" href="//cloud.typography.com/6546274/756308/css/fonts.css" />

    <style type="text/css">
        

        .session-type-big {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            margin-top: 20px;
            font-size: 80px;
            margin-bottom: 0px;
            color: #000;
            width: 100%;
        }

        .session-type {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            margin-top: 340px;
            font-size: 50px;
            margin-bottom: 0px;
            color: #000;
            width: 100%;
        }

        .session-title {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 40px;
            margin-top: 0px;
            color: #82262f;
        }

        .time-block {
            position: absolute;
            top: 620px;
        }

        .start-time {
            margin-top: 0;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #000;
            font-size: 80px;
            float: left;
            width: 387px;
        }

        .current-time {
            float: left;
            margin-top: 20px;
            color: #82262f;
            font-size: 48px;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
        }

        .next-block {
            position: absolute;
            top: 695px;
            width: 100%;
        }

        .next-header {
            clear: both;
            margin-top: 50px;
            color: #82262f;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            font-size: 35px;
        }

        .next-session {
            position: relative;
            color: #000;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            font-size: 36px;
            width: 95%;
        }

        .left {
            float: left;
        }

        .right {
            float: right;
        }

        .next {
            margin-top: 55px;
            font-size: 24px;
        }

        #current_date {
            text-transform: uppercase;
        }

        .twitter {
            width: 100%;
        }

        .pic {
            float: left;
        }

            .pic img {
                width: 128px;
            }

        .twithead {
            float: left;
            margin-left: 10px;
        }

        #fullname {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #000;
            font-size: 48px;
        }

        #username {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #000;
            font-size: 36px;
        }

        .tweet {
            margin-top: 15px;
            width: 90%;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #000;
            font-size: 36px;
            clear: both;
        }

        .twitimg {
            margin-top: 15px;
            width: 100%;
        }

            .twitimg img {
                max-height: 250px;
            }

        .announcement {
            width: 100%;
        }

        #message_title {
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #ffffff;
            font-size: 48px;
        }

        #message {
            margin-top: 15px;
            width: 90%;
            font-family: "Gotham Narrow A", "Gotham Narrow B";
            font-style: normal;
            font-weight: 400;
            color: #ffffff;
            font-size: 36px;
            clear: both;
        }

        #message_img {
            margin-top: 15px;
            width: 100%;
        }

            #message_img img {
                max-height: 250px;
            }

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

    
    
    <style type="text/css">
        
        body { width: 1080px;height: 1920px;background-image: url('<%= fnsignUrl %>/uploads/<%= bgimage %>');background-repeat: no-repeat;padding: 0;margin: 0;overflow: hidden;}

    </style>

</head>
<body>
    <form id="form1" runat="server">
        
        <asp:HiddenField runat="server" ID="event_id" />
        <asp:HiddenField runat="server" ID="template_id" />
        <asp:HiddenField runat="server" ID="location_sched" />
        <asp:HiddenField runat="server" ID="terminal_id" />

        <asp:PlaceHolder runat="server" ID="ph_content"></asp:PlaceHolder>
    </form>
    
    <script type="text/javascript" src="/js/display.js?ver=2.1.1.5"></script>
    
    <script type="text/javascript">

        setInterval(refreshData, 7500);
        refreshNews();

    </script>

</body>
</html>
