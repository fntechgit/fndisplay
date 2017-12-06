using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class austin : System.Web.UI.Page
    {
        private schedInterface.terminals _terminals = new terminals();
        private schedInterface.templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.locations _locations = new locations();
        private schedInterface.settings _settings = new settings();
        private schedInterface.mediaManager _media = new mediaManager();
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

        public Media m = new Media();

        public string twitimg;

        // twitter
        public string twitpic;

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
                    font_color = temp.overlay_font_color;

                    if (temp.video)
                    {
                        video_bg.Visible = true;

                        bgimage = null;
                    }

                    template_id.Value = temp.id.ToString();

                    event_id.Value = t.event_id.ToString();
                    location_sched.Value = l.sched_id;
                    terminal_id.Value = Page.RouteData.Values["id"].ToString();

                    Session current = _sessions.current(Convert.ToInt32(Session["event_id"]), l.sched_id, _timewarp.display(t.event_id));

                    if (current.internal_id > 0)
                    {
                        // good we have a session now let's get the rest
                        Session next = _sessions.next(Convert.ToInt32(Session["event_id"]), l.sched_id, current.end);

                        session_title_val = current.name;
                        session_type = current.event_type;
                        start_time = current.start.ToShortTimeString();
                        next_session = next.event_start + ": " + next.name;

                        Int32 title_length = session_title_val.Length;

                        if (title_length > 50)
                        {
                            session_title.Attributes.Add("class", "session-type-big");
                        }
                    }
                    else
                    {
                        session_title_val = "No Current Session";
                        session_type = "Currently there is no session in this room";
                        start_time = "No Session";

                        Session next = _sessions.next(Convert.ToInt32(Session["event_id"]), l.sched_id, DateTime.Now);

                        next_session = next.event_start + ": " + next.name;
                    }

                    // now get the first twitter item to be rotated
                    m = _media.random_by_event(Convert.ToInt32(Session["event_id"].ToString()));

                    twitpic = m.profilepic;

                    if (m.source != null)
                    {
                        twitimg = "<img src=\"" + m.source + "\" />";
                    }
                    else
                    {
                        twitimg = null;
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