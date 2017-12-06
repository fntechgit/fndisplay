using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class schedule_of_events : System.Web.UI.Page
    {
        private schedInterface.terminals _terminals = new terminals();
        private schedInterface.templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.locations _locations = new locations();
        private schedInterface.settings _settings = new settings();
        private schedInterface.events _events = new events();
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
        public string current_title = "Test Session Title";
        public string current_start_time = "2:00pm";
        public string current_end_time = "5:00pm";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {
                fnsignUrl = _settings.site_url();

                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                Event ev = _events.single(Convert.ToInt32(Session["event_id"]));

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

                    DateTime dt = DateTime.Now.AddDays(-1);

                    Int32 i = 0;

                    List<Session> sess = _sessions.by_event_by_day(ev.id, _timewarp.display(ev.id));

                    string time = "";
                    DateTime prev = new DateTime();

                    if (sess.Any())
                    {
                        foreach (Session s in _sessions.by_event_by_day(ev.id, _timewarp.display(ev.id)))
                        {
                            if (s.start != prev)
                            {
                                prev = s.start;
                                time = s.start.ToShortTimeString();
                            }
                            else
                            {
                                time = "";
                            }

                            ph_sessions.Controls.Add(new LiteralControl("<div class=\"block-wrapper\"><div class=\"time-wrapper\"><span>" + time + "</span></div><div class=\"session-wrapper\"><div class=\"session-title\">" + s.name + "</div><div class=\"session-details\">" + s.venue + " / Until " + s.event_end + "</div></div></div>"));
                        }
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