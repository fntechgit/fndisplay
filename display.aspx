<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="display.aspx.cs" Inherits="fnsignDisplay.display" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>


</head>
<body>
    <form id="form1" runat="server">
        
        <asp:HiddenField runat="server" ID="event_id" ClientIDMode="Static"/>
        <asp:HiddenField runat="server" ID="terminal_id" ClientIDMode="Static"/>
        <asp:HiddenField runat="server" ID="location_sched" ClientIDMode="Static"/>
    
    <asp:Panel runat="server" ID="pnl_no_template" ClientIDMode="Static" Visible="false">
        <h4>No Template Assigned - awaiting assignment</h4>
    </asp:Panel>
    
    <asp:PlaceHolder runat="server" ID="body"></asp:PlaceHolder>
    
    <asp:PlaceHolder runat="server" ID="footer"></asp:PlaceHolder>

    </form>
</body>
</html>
