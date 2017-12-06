using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay
{
    public partial class login : System.Web.UI.Page
    {
        #region declarations

        private schedInterface.users _users = new schedInterface.users();
        private schedInterface.permissions _permissions = new schedInterface.permissions();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.RouteData.Values["noevents"] != null)
            {
                pnl_no_events_assigned.Visible = true;
            }

            Session["user_id"] = "1";
            Session["user_name"] = "FNTECH";
            Session["company_name"] = "FNTECH";
            Session["user_access"] = "system";

            List<Event> myevents = _permissions.select_permitted_events(Convert.ToInt32(Session["user_id"].ToString()));

            if (myevents.Count > 0)
            {
                Session["event_id"] = myevents[0].id.ToString();

                Response.Redirect("/details");
            }
            else
            {
                pnl_no_events_assigned.Visible = true;
            }
        }

        protected void signin(object sender, EventArgs e)
        {
            User u = _users.login(email.Text.ToString(), pwd.Text.ToString());

            if (u.id > 0)
            {
                // you got it right
                Session["user_id"] = u.id.ToString();
                Session["user_name"] = u.first_name + " " + u.last_name;
                Session["company_name"] = u.company;
                Session["user_email"] = u.email;
                Session["user_pic"] = u.picture;
                Session["user_access"] = u.security_desc;

                List<Event> myevents = _permissions.select_permitted_events(Convert.ToInt32(Session["user_id"].ToString()));

                if (myevents.Count > 0)
                {
                    Session["event_id"] = myevents[0].id.ToString();

                    Response.Redirect("/details");
                }
                else
                {
                    pnl_no_events_assigned.Visible = true;
                }
            }
            else
            {
                pnl_error.Visible = true;
            }
        }
    }
}