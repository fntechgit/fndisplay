using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using schedInterface;

namespace fnsignDisplay
{
    public partial class details : System.Web.UI.Page
    {
        private schedInterface.events _events = new events();
        private schedInterface.locations _locations = new locations();
        private schedInterface.terminals _terminals = new terminals();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["user_id"] != null)
            {
                if (!Page.IsPostBack)
                {
                    ddl_event.DataSource = _events.all();
                    ddl_event.DataValueField = "id";
                    ddl_event.DataTextField = "title";
                    ddl_event.DataBind();

                    ListItem i = new ListItem("Select Event", "0");

                    ddl_event.Items.Insert(0, i);
                }
            }
            else
            {
                Response.Redirect("/login");
            }
        }

        protected void get_locations(object sender, EventArgs e)
        {
            ddl_location.DataSource = _locations.by_event(Convert.ToInt32(ddl_event.SelectedValue));
            ddl_location.DataValueField = "id";
            ddl_location.DataTextField = "title";
            ddl_location.DataBind();

            ListItem i2 = new ListItem("Select Location", "0");

            ddl_location.Items.Insert(0, i2);

            ddl_terminals.DataSource = _terminals.by_event(Convert.ToInt32(ddl_event.SelectedValue));
            ddl_terminals.DataValueField = "id";
            ddl_terminals.DataTextField = "title";
            ddl_terminals.DataBind();

            ListItem i3 = new ListItem("Select Terminal", "0");

            ddl_terminals.Items.Insert(0, i3);
        }

        protected void set_terminal(object sender, EventArgs e)
        {
            Int32 terminal_id = Convert.ToInt32(ddl_terminals.SelectedValue);
            Session["event_id"] = ddl_event.SelectedValue;

            HttpCookie myCookie = new HttpCookie("FNSIGN_EventID");
            myCookie.Value = ddl_event.SelectedValue;
            myCookie.Expires = DateTime.Now.AddMonths(1);
            Response.Cookies.Add(myCookie);

            Response.Redirect("/displays/" + terminal_id);
        }

        protected void display(object sender, EventArgs e)
        {
            Terminal t = new Terminal();

            t.event_id = Convert.ToInt32(ddl_event.SelectedValue);
            t.location_id = Convert.ToInt32(ddl_location.SelectedValue);
            t.online = true;
            t.title = title.Text;

            t = _terminals.add(t);

            Session["event_id"] = t.event_id.ToString();

            Response.Redirect("/displays/" + t.id);
        }
    }
}