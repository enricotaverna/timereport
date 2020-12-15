using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Amazon.EC2;
using Amazon.EC2.Model;
using Amazon;
using Amazon.Runtime;
using System.Configuration;

public partial class m_utilita_AWSClient_AWSClient : System.Web.UI.Page
{
    
    public class AWSInstance
    {
        public int StatusCode { get; set; }
        public string StatusDescription { get; set; }
        public string ButtonState { get; set; }
        public string DivClass { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("STARTAWS", "DISPLAY");
        SetPageData();
    }

    // chiama API e valorizza stato dell'istanza
    protected  void SetPageData() {

        // Crea i parametri di lancio
        var myRegion = RegionEndpoint.GetBySystemName(ConfigurationManager.AppSettings["AWS_REGION"]); // non funziona in appsettings.json... 
        var ec2Client = new AmazonEC2Client(new BasicAWSCredentials(ConfigurationManager.AppSettings["AWS_ACCESSKEY"], ConfigurationManager.AppSettings["AWS_SECRETKEY"]), myRegion);
        var rq2 = new DescribeInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };

        // Recupera lo stato dell'instanza
        DescribeInstancesResponse r2 = ec2Client.DescribeInstances(rq2);

        // Status
        //0 : pending
        //16 : running
        //32 : shutting - down
        //48 : terminated
        //64 : stopping
        //80 : stopped

        AWSInstance ModelData = SetViewData(r2.Reservations[0].Instances[0].State);

        lbStato.Text = ModelData.StatusDescription;

        switch (ModelData.StatusCode)
        {

            case 16: // running
                lbStato.ForeColor = System.Drawing.ColorTranslator.FromHtml("#008000"); // green
                InsertButton.Visible = false;
                break;

            case 80: // stopperd
                lbStato.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FF0000"); // red
                InsertButton.Visible = true;
                break;

            default:
                lbStato.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFA500"); // orange
                InsertButton.Visible = false;
                break;
        }

        // se mancano le autorizzazioni spegne comunque il tasto
        if (!Auth.ReturnPermission("STARTAWS", "START"))
            InsertButton.Visible = false;

    }

    // mappa risultati della API
    private static AWSInstance SetViewData(InstanceState instanceStatus)
    {

        AWSInstance ret = new AWSInstance();

        ret.StatusCode = instanceStatus.Code;

        switch (ret.StatusCode)
        {
            case 16:
                ret.DivClass = "alert alert-success";
                ret.ButtonState = "disabled";
                break;

            case 0:
                ret.DivClass = "alert alert-warning";
                ret.ButtonState = "disabled";
                break;

            case 80:
                ret.DivClass = "alert alert-danger";
                ret.ButtonState = "enabled";
                break;

            default:
                ret.DivClass = "alert alert-danger";
                ret.ButtonState = "disabled";
                break;
        }

        ret.StatusDescription = instanceStatus.Name;

        return (ret);
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {

        Auth.CheckPermission("STARTAWS", "START");

        // Crea i parametri di lancio
        var myRegion = RegionEndpoint.GetBySystemName(ConfigurationManager.AppSettings["AWS_REGION"]); // non funziona in appsettings.json... 
        var ec2Client = new AmazonEC2Client(new BasicAWSCredentials(ConfigurationManager.AppSettings["AWS_ACCESSKEY"], ConfigurationManager.AppSettings["AWS_SECRETKEY"]), myRegion);
        var req = new DescribeInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };

        // Recupera lo stato dell'instanza
        DescribeInstancesResponse res = ec2Client.DescribeInstances(req);

        if (res.Reservations[0].Instances[0].State.Code != 80)
        {
            return; // non fa niente
        }

        StartInstancesRequest launchRequest = new StartInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };
        StartInstancesResponse launchResponse = ec2Client.StartInstances(launchRequest);

        SetPageData(); // refresh pagina

    }
}