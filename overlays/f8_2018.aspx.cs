using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class f8_2018 : System.Web.UI.Page
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
        public string font_color;
        public string start_time;
        public string end_time;
        public string next_session;
        public string current_title = "Test Session Title";
        public string current_start_time = "2:00pm";
        public string current_end_time = "5:00pm";
        public string current_time_separator = "-";
        public string current_bgcolor = "#FFFFFF";
        public string current_full_session_graphic = "";
        public string next_title = "Next Test Session Title";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {
                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                Event ev = _events.single(Convert.ToInt32(Session["event_id"]));

                if (t.template_id > 0)
                {
                    // fill the content
                    Location l = _locations.single(Convert.ToInt32(t.location_id));
                    location_sched.Value = l.sched_id;

                    Template temp = _templates.single(Convert.ToInt32(t.template_id));

                    bgcolor = string.Format("#{0}", temp.bgcolor);
                    font_color = string.Format("#{0}", temp.overlay_font_color);

                    Session current = _sessions.current(ev.id, l.sched_id, _timewarp.display(t.event_id));

                    //TODO: In next method in sessions it's returning a value when no session is coming back. 
                    if (current.internal_id == 0)
                    {
                        current_title = "No official session at this time. Check SCHED for full agenda.";
                        current_start_time = string.Empty;
                        current_end_time = string.Empty;
                        current_time_separator = string.Empty;  
                    }
                    else
                    {
                        current_title = current.name;
                        current_start_time = current.start.ToString("h:mm");
                        current_end_time = current.end.ToString("h:mm tt").ToLower();

                        var names = current.speakers.Split(',').ToList();
                        var companies = current.speaker_companies.Split(',').ToList();
                        var speakers = names.Zip(companies, (n, c) => new { Name =  n , Company = c });

                        foreach (var speaker in speakers)
                        {
                            ph_speakers.Controls.Add(
                                new LiteralControl(
                                    string.Format("<div class=\"speaker\"><div class=\"speaker-name\">{0}</div><div class=\"speaker-company\">{1}</div></div>"
                                    , speaker.Name.ToUpper()
                                    , speaker.Company.ToUpper())));                            
                        }

                        current_bgcolor = current.event_bgcolor;
                        current_full_session_graphic = ev.full_session;

                    }

                    Session next = _sessions.next(t.event_id, l.sched_id, current.internal_id != 0 ? current.end : _timewarp.display(t.event_id));

                    //TODO: In next method in sessions it's returning a value when no session is coming back. 
                    if (next.internal_id == 0)
                    {
                        next_title = "No more sessions at this time. Check SCHED for full agenda.";
                    }
                    else
                    {
                        next_title = next.name;
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