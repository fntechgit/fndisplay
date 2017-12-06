using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class atscale_office_hours : System.Web.UI.Page
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
        public string category;

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

                    string color = "blue";

                    switch (t.location_id)
                    {
                        case 3795:
                            color = "blue";
                            break;
                        case 3794:
                            color = "red";
                            break;
                        case 3793:
                            color = "purple";
                            break;
                        case 3791:
                            color = "green";
                            break;
                        default:
                            color = "orange";
                            break;

                    }

                    Session s = _sessions.current(Convert.ToInt32(Session["event_id"] as string), l.sched_id, _timewarp.display(t.event_id));

                    category = s.event_type;

                    List<string> speakersList = new List<string>();
                    List<string> speakerCompanies = new List<string>();

                    if (!string.IsNullOrEmpty(s.speakers))
                    {
                        speakersList = s.speakers.Split(':').ToList();
                        speakerCompanies = s.speaker_companies.Split(':').ToList();
                    }
                    else
                    {
                        speakersList.Add(s.speakers);
                        speakerCompanies.Add(s.speaker_companies);
                    }

                    Int32 i = 0;

                    foreach (string sp in speakersList)
                    {
                        ph_speakers.Controls.Add(new LiteralControl("<span class=\"blue\">" + sp + "</span> / " + speakerCompanies[i] + "<br />"));

                        i++;
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