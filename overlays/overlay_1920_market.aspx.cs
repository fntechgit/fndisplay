using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class overlay_1920_market : System.Web.UI.Page
    {
        private schedInterface.terminals _terminals = new terminals();
        private schedInterface.templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.locations _locations = new locations();
        private schedInterface.settings _settings = new settings();
        private schedInterface.timewarp _timewarp = new timewarp();

        public string bgcolor;
        public string font;
        public string font_color;
        public string bgimage;
        public string session_type;
        public string session_title_val;
        public string start_time;
        public string end_time;
        public string next_session;
        public string fnsignUrl;
        public string video;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {
                fnsignUrl = _settings.site_url();

                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                if (t.template_id > 0)
                {
                    // fill the content
                    Location l = _locations.single(Convert.ToInt32(t.location_id));

                    Template temp = _templates.single(Convert.ToInt32(t.template_id));

                    bgimage = temp.bgimage;
                    video = bgimage;

                    if (temp.video)
                    {
                        video_bg.Visible = true;

                        bgimage = null;
                    }

                    event_id.Value = t.event_id.ToString();
                    location_sched.Value = l.sched_id;
                    terminal_id.Value = Page.RouteData.Values["id"].ToString();

                    current_date.Value = DateTime.Now.Date.ToShortDateString();

                    foreach (Session s in _sessions.by_event_by_location_by_day(t.event_id, l.sched_id, _timewarp.display(t.event_id)))
                    {
                        ph_sessions.Controls.Add(new LiteralControl("<div class=\"row\"><div class=\"left\">" + s.start.ToShortTimeString() + "</div><div class=\"right\">" + s.name + "</div></div>"));
                    }
                }
                else
                {
                    // display the waiting signal
                    Response.Redirect("/not-assigned/" + t.id);
                }
            }
            else
            {
                Response.Redirect("/details");
            }
        }
    }
}