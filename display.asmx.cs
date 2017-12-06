using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using schedInterface;

namespace fnsignDisplay
{
    /// <summary>
    /// Summary description for display1
    /// </summary>
    [WebService(Namespace = "http://fndisplay.fntech.com/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]

    public class displaySvc : System.Web.Services.WebService
    {
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.terminals _terminals = new terminals();
        private schedInterface.templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private schedInterface.settings _settings = new settings();
        private schedInterface.messages _messages = new messages();
        private schedInterface.events _events = new schedInterface.events();
        schedInterface.mediaManager _media = new mediaManager();
        private schedInterface.timewarp _timewarp = new timewarp();

        [WebMethod(Description = "Get Current Session", EnableSession = true)]
        public Session current(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);

            Event ev = _events.single(event_id);

            Session s = _sessions.current(event_id, location, _timewarp.display(event_id));

            if (s.internal_id == 0)
            {
                // check for next session date
                Session next = _sessions.next(event_id, location, DateTime.Now);

                if (next.start.Date > DateTime.Today.Date || next.internal_id == 0)
                {
                    s.name = ev.eod_title;
                    s.event_type = ev.eod_category;
                    s.event_start = ev.eod_time;
                    s.event_end = "";
                    s.description = ev.eod_description;
                    s.event_id = event_id;
                    s.id = "NO SESSION";
                }
                else
                {
                    // Make this Dynamic
                    s.name = "Another great session coming up! See schedule below.";
                    s.event_type = "No Official Session";
                    s.event_start = "";
                    s.event_end = "";
                    s.event_id = event_id;
                    s.id = "NO SESSION";
                }
            }
            else
            {
                s.event_start = s.start.ToShortTimeString();
                s.event_end = s.end.ToShortTimeString();

                //s.speakersList = s.speakers.Split(':').ToList();
                //s.speakerCompaniesList = s.speaker_companies.Split(':').ToList();
                //s.speakerImagesList = s.speaker_images.Split(':').ToList();
            }

            if (Context.Session["event_id"] == null)
            {
                s.event_id = 0;
            }

            return s;
        }

        [WebMethod(Description = "Barcelona Design Summit")]
        public List<Session> barcelona_design_summit()
        {
            return _sessions.barcelona_design_summit();
        }

        [WebMethod(Description = "Barcelona Working Group")]
        public List<Session> barcelona_working_group()
        {
            return _sessions.barcelona_working_group();
        }

        [WebMethod(Description = "Return Server Time")]
        public string server_time()
        {
            return DateTime.Now.ToShortTimeString();
        }

        [WebMethod(Description = "Schedule by Day", EnableSession = true)]
        public List<Session> schedule_by_event()
        {
            return _sessions.get_future_by_event_by_day(Convert.ToInt32(Context.Session["event_id"] as string), _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
        }

        [WebMethod(Description = "Custom Method for OC3", EnableSession = true)]
        public List<Session> oc3_group()
        {
            return _sessions.by_event_by_day_by_group(1009, _timewarp.display(1009));
        }

        [WebMethod(Description = "Future Sessions by Date, Location, Event", EnableSession = true)]
        public List<Session> future()
        {
            return _sessions.by_event_by_location_by_day(Convert.ToInt32(Context.Session["event_id"]), Context.Session["location"].ToString(), _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
        }

        [WebMethod(Description = "Skip Current", EnableSession = true)]
        public List<Session> future_skip_current(string location, Int32 skip)
        {
            List<Session> sessions = new List<Session>();

            if (current(location).id == "NO SESSION")
            {
                sessions = _sessions.by_event_by_location_by_day(Convert.ToInt32(Context.Session["event_id"]), location, _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
            }
            else
            {
                sessions = _sessions.skip_by_event_by_location_by_day(Convert.ToInt32(Context.Session["event_id"]), location, skip, _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
            }

            return sessions;
        }

        [WebMethod(Description = "Future Sessions by Date and Event", EnableSession = true)]
        public List<Session> future_by_date()
        {
            return _sessions.future_by_event_by_day(Convert.ToInt32(Context.Session["event_id"]), _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
        }
            
        [WebMethod(Description = "Login From Cookie", EnableSession = true)]
        public Boolean loginAgain(string event_id)
        {
            Context.Session["event_id"] = event_id;

            return true;
        }

        [WebMethod(Description = "Get Event FUll Session Graphic", EnableSession = true)]
        public string full_graphic()
        {
            return _events.single(Convert.ToInt32(Context.Session["event_id"])).full_session;
        }

        [WebMethod(Description = "Get Next Session", EnableSession = true)]
        public Session next(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);

            Session current = this.current(location);

            if (current.internal_id > 0)
            {
                return _sessions.next(event_id, location, current.end);
            }
            else
            {
                return _sessions.next(event_id, location, _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
            }
        }

        [WebMethod(Description = "Check for New Template", EnableSession = true)]
        public string template(Int32 terminal)
        {
            Terminal t = _terminals.single(Convert.ToInt32(Context.Session["event_id"]), terminal);

            Template temp = _templates.single(Convert.ToInt32(t.template_id));

            _terminals.online(terminal);

            return _settings.site_url() + "/uploads/" + temp.bgimage;
        }

        [WebMethod(Description = "Get Random Media", EnableSession = true)]
        public Media random()
        {
            return _media.random_by_event(Convert.ToInt32(Context.Session["event_id"]));
        }

        [WebMethod(Description = "Check for Announcement", EnableSession = true)]
        public Message get_message(Int32 template_id, Int32 terminal_id, Boolean priority)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);

            return _messages.random(event_id, template_id, terminal_id, priority);
        }

        [WebMethod(Description = "Is Session Full", EnableSession = true)]
        public Message session_full(Int32 terminal_id)
        {
            return _messages.session_full(terminal_id);
        }

    }
}
