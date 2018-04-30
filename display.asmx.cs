﻿using System;
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

        [WebMethod(Description = "Get Current Session Only", EnableSession = true)]
        public Session current_session(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);

            Session current =  _sessions.current(event_id, location, _timewarp.display(event_id));

            if (current.internal_id != 0)
            {
                current.event_start = current.start.ToString("h:mm");
                current.event_end = current.end.ToString("h:mm tt").ToLower();
            }

            return current;
        }

        //To avoid the gap between refreshing current and next.
        [WebMethod(Description = "Get F8 Keynote whole data to display", EnableSession = true)]
        public CurrentAndNext get_f8_keynote_display_data(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);
            Event evt = _events.single(event_id);
            CurrentAndNext result = new CurrentAndNext { eventId = event_id };

            var currentTime = _timewarp.display(event_id);

            //DAY 0
            if (currentTime.Date == evt.event_start.Value.AddDays(-1).Date)
            {
                result.sessions = _sessions.future_by_event_by_location_by_day(event_id, location, evt.event_start.Value.AddHours(11.5));
                result.isBeginOfDay = true;
            }
            else if (currentTime.TimeOfDay <= new TimeSpan(11, 30, 0)) //DAY 1-2 BEFORE 11:30
            {
                result.isPreBeginOfDay = true;
                result.PreBeginOfDayMessage = "10:00 - 11:30";
            }
            else if (currentTime.Date == evt.event_start.Value.Date) //DAY 1
            {
                Session current = _sessions.current(event_id, location, currentTime);
                if (current.internal_id != 0)
                {
                    current.event_start = current.start.ToString("h:mm");
                    current.event_end = current.end.ToString("h:mm tt").ToLower();
                }

                Session next = _sessions.next(event_id, location, current.internal_id != 0 ? current.end : currentTime);
                next = next.start.Date != currentTime.Date ? new Session() : next;

                if (currentTime.TimeOfDay > new TimeSpan(11, 30, 0) && currentTime.TimeOfDay < new TimeSpan(13, 0, 0)) //DAY 1 TODAY'S SESSIONS
                {
                    result.sessions = _sessions.future_by_event_by_location_by_day(event_id, location, evt.event_start.Value.AddHours(11.5));
                    result.isBeginOfDay = true;
                    
                    //SHOW FIRST ONLY -> 30MIN BEFORE
                    if (currentTime.TimeOfDay > new TimeSpan(12, 30, 0))
                    {
                        var sessions = result.sessions.Take(2).ToList<Session>();
                        result.current = sessions[0];
                        result.next = sessions[1];

                        result.isBeginOfDay = false;
                    }

                }
                else if (currentTime.TimeOfDay >= new TimeSpan(13, 0, 0) 
                    && (         (next.internal_id != 0 && next.end >= currentTime) 
                              || (next.internal_id == 0 && current.end >= currentTime)
                       )
                        )//DAY 1 SESSIONS
                {
                    result.current = current;
                    result.next = next;
                    
                    //AVOID GAP 
                    if (current.internal_id == 0 && next.internal_id != 0)
                    {
                        result.current = next;
                        result.current.event_start = result.current.start.ToString("h:mm");
                        result.current.event_end = result.current.end.ToString("h:mm tt").ToLower();

                        result.next = _sessions.next(event_id, location, result.current.end);
                        result.next = result.next.start.Date != currentTime.Date ? new Session() : result.next;
                    }

                } else if ((next.end < currentTime) && (next.internal_id == 0)) //DAY 1 END OF DAY
                {
                    result.isEndOfDay = true;
                    result.EndOfDayMessage = evt != null ? evt.eod_title : "End of day!";
                }

            } else if (currentTime.Date == evt.event_start.Value.AddDays(1).Date) //DAY 2
            {
                if (currentTime.TimeOfDay > new TimeSpan(11, 30, 0) && currentTime.TimeOfDay < new TimeSpan(18, 0, 0)) //DAY 2 HAPPY HOUR
                {
                    result.isEndOfDay = true;
                    result.EndOfDayMessage = "Join us for happy hour.";

                }
                else //DAY 2 END OF DAY
                {
                    result.isEndOfDay = true;
                    result.EndOfDayMessage = evt != null ? evt.eod_title : "End of day!";
                }
                
            }

            return result;
        }

        //To avoid the gap between refreshing current and next.
        [WebMethod(Description = "Get F8 whole data to display", EnableSession = true)]
        public CurrentAndNext get_f8_display_data(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);
            var currentTime = _timewarp.display(event_id);
            Event evt = _events.single(event_id);

            Session current = _sessions.current(event_id, location, currentTime);
            if (current.internal_id != 0)
            {
                current.event_start = current.start.ToString("h:mm");
                current.event_end = current.end.ToString("h:mm tt").ToLower();
            }

            Session next = _sessions.next(event_id, location, current.internal_id != 0 ? current.end : currentTime);
            next = next.start.Date != currentTime.Date ? new Session() : next;

            var result = new CurrentAndNext { eventId = event_id , current = current, next = next };

            
            if (currentTime.Date == evt.event_start.Value.AddDays(-1).Date) //DAY 0
            {
                result.sessions = _sessions.future_by_event_by_location_by_day(event_id, location, evt.event_start.Value);
                result.isBeginOfDay = true;

            } else if ((current.internal_id == 0) && (next.start > currentTime)) //DAY 1-2 TODAY'S SESSIONS
            {
                result.sessions = _sessions.future_by_event_by_location_by_day(event_id, location, currentTime.Date);

                result.isBeginOfDay = (next.internal_id == result.sessions.First<Session>().internal_id);

                if (result.isBeginOfDay && (next.start.AddMinutes(-30).TimeOfDay < currentTime.TimeOfDay)) //SHOW FIRST -30MIN BEFORE
                {
                    var sessions = result.sessions.Take(2).ToList<Session>();
                    result.current = sessions[0];
                    result.next = sessions[1];

                    result.isBeginOfDay = false;
                } else if (!result.isBeginOfDay) //AVOID GAP 
                {
                    result.current = next;
                    result.current.event_start = result.current.start.ToString("h:mm");
                    result.current.event_end = result.current.end.ToString("h:mm tt").ToLower();

                    result.next = _sessions.next(event_id, location, result.current.end);
                    result.next = result.next.start.Date != currentTime.Date ? new Session() : result.next;
                }
            }
            else if ((current.end < currentTime) && (next.internal_id == 0)) //DAY 1-2 END OF DAY
            {
                result.isEndOfDay = true;
                result.EndOfDayMessage = evt != null ? evt.eod_title : "End of day!";
            }
            else if (current.full) //SESSION FULL
            {
                result.currentIsFull = true;
                //TODO Update the manager to set a full session message
                result.currentFullMessage = "Session Full";
            }
            
            return result;
        }

        [WebMethod(Description = "Get Current Session", EnableSession = true)]
        public Session current(string location)
        {
            Int32 event_id = Convert.ToInt32(Context.Session["event_id"]);

            Event ev = _events.single(event_id);

            Session s = _sessions.current(event_id, location, _timewarp.display(event_id).AddMinutes(5));

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

        [WebMethod(Description = "Return Server Time or Timewarp", EnableSession = true)]
        public string server_time_or_timewarp()
        {
            return _timewarp.display(Convert.ToInt32(Context.Session["event_id"])).ToShortTimeString();
        }

        [WebMethod(Description = "Return Server Date or Timewarp", EnableSession = true)]
        public string server_date_or_timewarp()
        {
            var current_server_date = _timewarp.display(Convert.ToInt32(Context.Session["event_id"]));
            return string.Format("{0}, {1} {2}", current_server_date.DayOfWeek.ToString(), current_server_date.ToString("MMMM"), current_server_date.Day.ToString());
        }

        [WebMethod(Description = "Schedule by Day", EnableSession = true)]
        public List<Session> schedule_by_event()
        {
            return _sessions.get_future_by_event_by_day(Convert.ToInt32(Context.Session["event_id"] as string), _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)));
        }

        [WebMethod(Description = "Schedule by Day Ordered by Session Start", EnableSession = true)]
        public List<Session> schedule_by_event_order_by_start()
        {
            return _sessions.get_future_by_event_by_day(Convert.ToInt32(Context.Session["event_id"] as string), _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)))
                .OrderBy(x => x.start).ToList<Session>();
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
                sessions = _sessions.by_event_by_location_by_day(Convert.ToInt32(Context.Session["event_id"]), location, _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)).AddMinutes(5.01));
            }
            else
            {
                sessions = _sessions.skip_by_event_by_location_by_day(Convert.ToInt32(Context.Session["event_id"]), location, skip, _timewarp.display(Convert.ToInt32(Context.Session["event_id"] as string)).AddMinutes(5.01));
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

    public class CurrentAndNext {
        public Int32 eventId { get; set; }
        public Session current { get; set; }
        public Session next { get; set; }
        public bool currentIsFull { get; set; }
        public string currentFullMessage { get; set; }
        public bool isEndOfDay { get; set; }
        public string EndOfDayMessage { get; set; }
        public bool isBeginOfDay { get; set; }
        public bool isPreBeginOfDay { get; set; }
        public string PreBeginOfDayMessage { get; set; }
        public List<Session> sessions { get; set; }
    }
}
