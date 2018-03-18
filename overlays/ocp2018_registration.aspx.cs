﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class ocp2018_registration : System.Web.UI.Page
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
        public string current_speaker = "Speaker Name";

        public string day_of_week = "Monday";
        public string number_of_date = "6";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {
                fnsignUrl = _settings.site_url();

                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                Event ev = _events.single(Convert.ToInt32(Session["event_id"]));

                DateTime td = new DateTime();

                td = DateTime.Today;

                day_of_week = td.DayOfWeek.ToString();
                number_of_date = td.Day.ToString();

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

                    Session current = _sessions.current(ev.id, l.sched_id, _timewarp.display(t.event_id));

                    current_title = current.name;
                    current_start_time = current.start.ToShortTimeString();
                    current_end_time = current.end.ToShortTimeString();
                    current_speaker = current.speakers;

                    List<Session> sess = _sessions.get_future_by_event_by_day(t.event_id, _timewarp.display(t.event_id))
                        .OrderBy(x => x.start).ToList<Session>();

                    DateTime old = new DateTime();

                    if (sess.Any())
                    {
                        foreach (Session s in sess)
                        {
                            if (string.IsNullOrEmpty(s.speakers) || s.speakers.Equals("null"))
                            {
                                s.speakers = "";
                            }

                            if (old != s.start)
                            {
                                ph_sessions.Controls.Add(
                                    new LiteralControl(
                                        "<div class=\"session\">" +
                                        "<div class=\"session-time-block\"><div class=\"start-time\">" +
                                        s.start.ToShortTimeString().Replace(" ", "") +
                                        "</div></div>" +
                                        "<div class=\"session-type-block\"><div class=\"session-type\" " + " style=\"background-color:" + s.event_bgcolor + "\"></div></div>" +
                                        "<div class=\"session-speaker-block\"><div class=\"session-title\">" +
                                        s.name + "</div><div class=\"speaker-name\">" + s.speakers +
                                        "</div><div class=\"room-name\">" + s.venue.ToUpper() +
                                        "</div></div></div><div class=\"space\"></div>"));

                                old = s.start;
                            }
                            else
                            {
                                ph_sessions.Controls.Add(
                                    new LiteralControl(
                                        "<div class=\"session\">" +
                                        "<div class=\"session-type\" " + " style=\"background-color:" + s.event_bgcolor + "\"></div>" +
                                        "<div class=\"session-speaker-block\"><div class=\"session-title\">" +
                                        s.name + "</div><div class=\"speaker-name\">" + s.speakers +
                                        "</div><div class=\"room-name\">" + s.venue.ToUpper() +
                                        "</div></div></div><div class=\"space\"></div>"));
                            }
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