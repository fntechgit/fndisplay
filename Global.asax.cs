using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Routing;

namespace fnsignDisplay
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            // this is the routing engine
            RegisterRoutes(RouteTable.Routes);
        }

        void RegisterRoutes(RouteCollection routes)
        {
            // ######################## LOGIN SECTION ################################### //
            routes.MapPageRoute("login-route", "login", "~/login.aspx");
            routes.MapPageRoute("details-route", "details", "~/details.aspx");
            routes.MapPageRoute("display-route", "displays/{id}", "~/display.aspx");

            // ####################### DISPLAYS SECTION ################################# //
            routes.MapPageRoute("no-twitter-1920-route", "no-twitter-1920/{id}", "~/overlays/overlay_1920V_no_twitter.aspx");
            routes.MapPageRoute("twitter-1920-route", "twitter-1920/{id}", "~/overlays/overlay_1920V_twitter.aspx");
            routes.MapPageRoute("blank-1920-route", "blank-1920/{id}", "~/overlays/overlay_blank.aspx");
            routes.MapPageRoute("marketplace-1920-route", "market-1920/{id}", "~/overlays/overlay_1920_market.aspx");
            routes.MapPageRoute("brownbag-route", "brownbag-1920/{id}", "~/overlays/overlay_1920_brownbag.aspx");
            routes.MapPageRoute("design-summit-route", "summit-1920/{id}", "~/overlays/overlay_1920_summit.aspx");
            routes.MapPageRoute("housekeeping-route", "housekeeping/{id}", "~/overlays/overlay_housekeeping_slides.aspx");
            routes.MapPageRoute("ocp-route", "ocp/{id}", "~/overlays/overlay_ocp.aspx");
            routes.MapPageRoute("austin-route", "austin/{id}", "~/overlays/austin.aspx");
            routes.MapPageRoute("austin-route3", "austin3/{id}", "~/overlays/austin3.aspx");
            routes.MapPageRoute("atscale-office-hours-route", "atscale-office/{id}", "~/overlays/atscale_office_hours.aspx");
            routes.MapPageRoute("atscale-route", "atscale/{id}", "~/overlays/atscale.aspx");
            routes.MapPageRoute("vertical-route", "vertical/{terminal_id}/{template_id}/{overlay_id}", "~/vertical.aspx");
            routes.MapPageRoute("oc30route", "oc3/{id}", "~/overlays/oc3.aspx");
            routes.MapPageRoute("schedule", "schedule/{id}", "~/overlays/schedule_of_events.aspx");
            routes.MapPageRoute("oc3-group-route", "oc3-group/{id}", "~/overlays/oc3_group.aspx");
            routes.MapPageRoute("barcelona-scrolling-route", "barcelona-scrolling/{id}", "~/overlays/barcelona.aspx");
            routes.MapPageRoute("barcelona-hilton-p0-route", "barcelona-p0/{id}", "~/overlays/barcelona_p0.aspx");
            routes.MapPageRoute("barcelona-blue-route", "barcelona-blue/{id}", "~/overlays/barcelona_blue.aspx");
            routes.MapPageRoute("barcelona-registration-route", "barcelona-registration/{id}", "~/overlays/barcelona_registration.aspx");
            routes.MapPageRoute("bafcelona-red-route", "barcelona-red-scrolling/{id}", "~/overlays/barcelona_red_scrolling.aspx");
            routes.MapPageRoute("barcelona-blue-scrolling-route", "barcelona-blue-scrolling/{id}", "~/overlays/barcelona_blue_scrolling.aspx");
            routes.MapPageRoute("barcelona-design-summit-route", "barcelona-design-summit/{id}", "~/overlays/barcelona_design_summit.aspx");
            routes.MapPageRoute("barcelona-design-working-group-summit-route", "barcelona-working-group/{id}", "~/overlays/barcelona_working_groups.aspx");
            routes.MapPageRoute("barcelona-green-route", "barcelona-green/{id}", "~/overlays/barcelona_green.aspx");
            routes.MapPageRoute("ocp-2017-breakout-route", "ocp-2017-breakout/{id}", "~/overlays/ocp2017_breakout.aspx");
            routes.MapPageRoute("ocp-2017-registration-route", "ocp-2017-registration/{id}", "~/overlays/ocp2017_registration.aspx");
            routes.MapPageRoute("ocp-2018-breakout-route", "ocp-2018-breakout/{id}", "~/overlays/ocp2018_breakout.aspx");
            routes.MapPageRoute("ocp-2018-registration-route", "ocp-2018-registration/{id}", "~/overlays/ocp2018_registration.aspx");
            routes.MapPageRoute("ocp-2018-expo-route", "ocp-2018-expo/{id}", "~/overlays/ocp2018_expo.aspx");
            routes.MapPageRoute("preview-route", "preview/{event_id}/{location_id}/{overlay_id}", "~/template_builder_live_preview.aspx");
            routes.MapPageRoute("preview-with-announcement-route", "preview/{event_id}/{location_id}/{overlay_id}/announce/{announcement_id}/{type}", "~/overlay_display.aspx");
            routes.MapPageRoute("preview-with-end-of-day-route", "preview/{event_id}/{location_id}/{overlay_id}/end-of-day/{end_id}/{type}", "~/overlay_display.aspx");
            routes.MapPageRoute("preview-with-announcement-and-end-of-day-route", "preview/{event_id}/{location_id}/{overlay_id}/{announcement_id}/{end_id}/{type}", "~/overlay_display.aspx");

            //test route
            routes.MapPageRoute("ocp-2018-breakout-route-test", "current_session_test/{id}", "~/overlays/ocp2018_breakout_testcurrentsize.aspx");

            // general routes
            routes.MapPageRoute("overlay-template-builder-route", "overlay/display/{id}", "~/overlay_display.aspx");
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}