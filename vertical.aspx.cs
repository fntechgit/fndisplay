using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay
{
    public partial class vertical : System.Web.UI.Page
    {
        public string fnsignUrl = "http://fnsign.fntech.com";
        public string bgimage;

        private templates _templates = new templates();
        private schedInterface.overlays _overlays = new schedInterface.overlays();
        private terminals _terminals = new terminals();
        private schedInterface.sessions _sessions = new sessions();
        private schedInterface.locations _locations = new locations();
        private schedInterface.settings _settings = new settings();
        private schedInterface.mediaManager _media = new mediaManager();
        private schedInterface.events _events = new events();
        private schedInterface.timewarp _timewarp = new timewarp();

        public Media m = new Media();

        public string twitimg;

        // twitter
        public string twitpic;

        protected void Page_Load(object sender, EventArgs e)
        {
            Template te = _templates.single(Convert.ToInt32(Page.RouteData.Values["template_id"] as string));
            Overlay o = _overlays.single(Convert.ToInt32(Page.RouteData.Values["overlay_id"] as string));

            bgimage = te.bgimage;

            Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"] as string), Convert.ToInt32(Page.RouteData.Values["terminal_id"] as string));

            Location l = _locations.single(Convert.ToInt32(t.location_id));

            event_id.Value = t.event_id.ToString();
            terminal_id.Value = t.id.ToString();
            template_id.Value = te.id.ToString();
            location_sched.Value = l.sched_id;

            Session current = _sessions.current(t.event_id, l.sched_id, _timewarp.display(t.event_id));

            Session next = new Session();

            if (current.internal_id > 0)
            {
                next = _sessions.next(t.event_id, l.sched_id, current.end);

                // replace with the current
                o.body =
                    o.body.Replace("{CURRENT_SESSION}", current.name)
                        .Replace("{CURRENT_SESSION_TYPE}", current.event_type)
                        .Replace("{START}", current.start.ToShortTimeString())
                        .Replace("{NEXT_SESSION_START_TIME}", next.start.ToShortTimeString())
                        .Replace("{NEXT_SESSION}", next.name);
            }
            else
            {
                next = _sessions.next(t.event_id, l.sched_id, DateTime.Now);

                Event ev = _events.single(t.event_id);

                if (next.start.Date > DateTime.Today.Date || next.internal_id == 0)
                {
                    o.body =
                    o.body.Replace("{CURRENT_SESSION}", ev.eod_title)
                        .Replace("{CURRENT_SESSION_TYPE}", ev.eod_category)
                        .Replace("{START}", ev.eod_time)
                        .Replace("{NEXT_SESSION_START_TIME}", next.start.ToShortTimeString())
                        .Replace("{NEXT_SESSION}", next.name);
                }
                else
                {
                    o.body =
                    o.body.Replace("{CURRENT_SESSION}", "NO CURRENT SESSION")
                        .Replace("{CURRENT_SESSION_TYPE}", "There is no session in this space at this time.")
                        .Replace("{START}", "TIME")
                        .Replace("{NEXT_SESSION_START_TIME}", next.start.ToShortTimeString())
                        .Replace("{NEXT_SESSION}", next.name);
                }

                
            }

            ph_content.Controls.Add(new LiteralControl(o.body));


        }
    }
}