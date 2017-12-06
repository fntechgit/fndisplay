using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class atscale : System.Web.UI.Page
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

                    List<Session> sess = _sessions.by_event_by_location_by_day(ev.id, l.sched_id, _timewarp.display(ev.id));

                    string color = "blue";

                    switch (t.location_id)
                    {
                        case 3790:
                            color = "blue";
                            break;
                        case 3788:
                            color = "red";
                            break;
                        case 3787:
                            color = "purple";
                            break;
                        case 3791:
                            color = "green";
                            break;
                        default:
                            color = "orange";
                            break;

                    }

                    if (sess.Any())
                    {
                        foreach (Session s in _sessions.by_event_by_location_by_day(ev.id, l.sched_id, _timewarp.display(ev.id)))
                        {
                            ph_sessions.Controls.Add(new LiteralControl("<div class=\"session-type\">" + s.start.ToShortTimeString() + " - " + s.end.ToShortTimeString() + "</div><div class=\"session-title\">" + s.name + "</div><div class=\"speakers article-row\">"));

                            if (!string.IsNullOrEmpty(s.speakers))
                            {
                                if (s.speakersList != null)
                                {
                                    i = 0;

                                    foreach (string sp in s.speakersList)
                                    {
                                        // render the speakers
                                        ph_sessions.Controls.Add(
                                            new LiteralControl(
                                                "<div class=\"article-author\"><div class=\"article-author-image\"><img src=\"http://fnsign.fntech.com/uploads/" +
                                                s.speakerImagesList[i] +
                                                "\" scale=\"0\" /></div><div class=\"article-author-details\"><div class=\"article-author-name-container\"><span class=\"article-author-name " + color + "\">" +
                                                sp + "</span></div><div class=\"article-author-job-title\">" +
                                                s.speakerCompaniesList[i] +
                                                "</div></div></div>"));

                                        i++;
                                    }

                                }
                                else
                                {
                                    ph_sessions.Controls.Add(
                                            new LiteralControl(
                                                "<div class=\"article-author\"><div class=\"article-author-image\"><img src=\"http://fnsign.fntech.com/uploads/" +
                                                s.speaker_images +
                                                "\" scale=\"0\" /></div><div class=\"article-author-details\"><div class=\"article-author-name-container\"><span class=\"article-author-name " + color + "\">" +
                                                s.speakers + "</span></div><div class=\"article-author-job-title\">" +
                                                s.speaker_companies +
                                                "</div></div></div>"));
                                }

                                ph_sessions.Controls.Add(new LiteralControl("</div>"));
                            }
                        }

                        ph_sessions.Controls.Add(new LiteralControl("</div><div class=\"space\" style=\"clear:both;\"></div>"));
                    }
                    else
                    {
                        ph_sessions.Controls.Add(new LiteralControl("<div class=\"session-type\">" + ev.eod_title + "</div><div class=\"session-title\">" + ev.eod_description + "</div>"));
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