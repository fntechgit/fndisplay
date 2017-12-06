using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay.overlays
{
    public partial class overlay_blank : System.Web.UI.Page
    {
        public string bgimage;
        public string fnsignUrl;
        public string video;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["event_id"] != null)
            {
                settings _settings = new settings();
                schedInterface.terminals _terminals = new terminals();
                schedInterface.templates _templates = new templates();

                fnsignUrl = _settings.site_url();

                Terminal t = _terminals.single(Convert.ToInt32(Session["event_id"]),
                    Convert.ToInt32(Page.RouteData.Values["id"]));

                if (t.template_id > 0)
                {
                    Template temp = _templates.single(Convert.ToInt32(t.template_id));

                    bgimage = temp.bgimage;
                    video = bgimage;

                    if (temp.video)
                    {
                        video_bg.Visible = true;

                        bgimage = null;
                    }

                    template_id.Value = temp.id.ToString();
                    terminal_id.Value = t.id.ToString();


                }
            }
            else
            {
                Response.Redirect("/login");
            }
        }
    }
}