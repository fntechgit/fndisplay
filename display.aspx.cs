using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay
{
    public partial class display : System.Web.UI.Page
    {
        private schedInterface.terminals _terminals = new terminals();
        private schedInterface.templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.locations _locations = new locations();
        private schedInterface.settings _settings = new settings();

        public string bgcolor;
        public string font;
        public string font_color;
        public string bgimage;
        public string session_type;
        public string session_title;
        public string start_time;
        public string end_time;
        public string next_session;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {

                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                t.online = true;
                t.last_online = DateTime.Now;
                t.notified = false;
                t.notified_date = null;

                _terminals.update(t);

                terminal_id.Value = t.id.ToString();

                if (t.template_id > 0)
                {
                    Template te = _templates.single(Convert.ToInt32(t.template_id));

                    Overlay o = _overlays.single(Convert.ToInt32(te.overlay));

                    if (o.preview == "CUSTOM")
                    {
                        Response.Redirect("/" + o.header + "/" + t.id);
                    }
                    else
                    {
                        Response.Redirect("/overlay/display/" + t.id.ToString());
                    }

                    //if (!string.IsNullOrEmpty(o.header))
                    //{
                    //    // this is a custom template not made through the template editor
                    //    Response.Redirect(_settings.display_url() + "/" + o.header + "/" + t.id);
                    //}
                    //else
                    //{
                    //    if (o.footer == "1080 x 1920")
                    //    {
                    //        // redirect to the vertical display
                    //        Response.Redirect(_settings.display_url() + "/vertical/" + t.id + "/" + te.id + "/" + o.id);
                    //    }
                    //    else
                    //    {
                    //        // redirect to the horizontal display
                    //        Response.Redirect(_settings.display_url() + "/horizontal/" + t.id + "/" + te.id + "/" + o.id);
                    //    }
                    //}
                }
                else
                {
                    // display the waiting signal
                    pnl_no_template.Visible = true;

                    footer.Controls.Add(
                        new LiteralControl("<script type=\"text/javascript\" src=\"/js/notemplate.js\"></script>"));
                }
            }
            else
            {
                Response.Redirect("/details");
            }
        }
    }
}