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
using Amazon.Runtime.CredentialManagement;

public partial class m_utilita_AWSClient_AWSClient : System.Web.UI.Page
{

    public TRSession CurrentSession;
    public AmazonEC2Client ec2Client; // creato da InitAWSClient

    public class MyAWSInstance
    {
        public int StatusCode { get; set; }
        public string StatusDescription { get; set; }
        public Boolean ButtonVisible { get; set; }
        public string ForeColor { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("STARTAWS", "DISPLAY");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        InitAWSClient(); // se fallisce ec2Client è null

        SetPageData();
    }

    // true se autenticazione è riuscita
    protected bool InitAWSClient() {    

        // parametri di autenticazione
        var myRegion = RegionEndpoint.GetBySystemName(ConfigurationManager.AppSettings["AWS_REGION"]); // non funziona in appsettings.json... 
        var chain = new CredentialProfileStoreChain();
        AWSCredentials awsCredentials;

        // recupera credenziali da file nel folder timereport, vedi web.config
        if (chain.TryGetAWSCredentials("production", out awsCredentials)) { 
            // crea istanza cliente
            ec2Client = new AmazonEC2Client(awsCredentials, myRegion);
            return true;
        }
        else { 
        ec2Client = null;
        return false;
        }
    }

    // chiama API e valorizza stato dell'istanza
    protected  void SetPageData() {

        // oggetto custom per memorizzare lo stato dell'istanza
        MyAWSInstance AWSInstanceStatus = new MyAWSInstance();

        // se ec2Client == null msg di errore altrimenti cerca di recuperare lo stato dell'istanza
        if (ec2Client == null) {
            AWSInstanceStatus.StatusCode = 99;
            AWSInstanceStatus.StatusDescription = "Errore in determinazione credenziali";
            AWSInstanceStatus.ForeColor = "#FF0000"; // red
            AWSInstanceStatus.ButtonVisible = false;
        }
        else
        {
            try {
                // Recupera lo stato dell'instanza
                var rq2 = new DescribeInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };
                DescribeInstancesResponse r2 = ec2Client.DescribeInstances(rq2); 
                // Status
                //0 : pending
                //16 : running
                //32 : shutting - down
                //48 : terminated
                //64 : stopping
                //80 : stopped
                AWSInstanceStatus = SetViewData(r2.Reservations[0].Instances[0].State);
            }
            catch
            {
                // autenticazione fallita
                AWSInstanceStatus.StatusCode = 99;
                AWSInstanceStatus.StatusDescription = "Errore di autenticazione";
                AWSInstanceStatus.ForeColor = "#FF0000"; // red
                AWSInstanceStatus.ButtonVisible = false;
            }

        }

        // setta colore messaggio e stato del bottone di avvio istanza
        lbStato.ForeColor = System.Drawing.ColorTranslator.FromHtml(AWSInstanceStatus.ForeColor);
        InsertButton.Visible = AWSInstanceStatus.ButtonVisible;
        lbStartupMessage.Visible = AWSInstanceStatus.ButtonVisible;
        lbStato.Text = AWSInstanceStatus.StatusDescription;

        // se mancano le autorizzazioni spegne comunque il tasto
        if (!Auth.ReturnPermission("STARTAWS", "START"))
            InsertButton.Visible = false;

    }

    // mappa risultati della API
    private static MyAWSInstance SetViewData(InstanceState instanceStatus)
    {

        MyAWSInstance ret = new MyAWSInstance();

        ret.StatusCode = instanceStatus.Code;

        switch (ret.StatusCode)
        {
            case 16:
                ret.ForeColor = "#008000"; // green
                ret.ButtonVisible = false;
                break;

            case 0:
                ret.ForeColor = "#FFA500"; // orange
                ret.ButtonVisible = false;
                break;

            case 80:
                ret.ForeColor = "#FF0000"; // red
                ret.ButtonVisible = true;
                break;

            default:
                ret.ForeColor = "#FF0000"; // red
                ret.ButtonVisible = false;
                break;
        }

        ret.StatusDescription = instanceStatus.Name;

        return (ret);
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {

        Auth.CheckPermission("STARTAWS", "START");

        // Recupera lo stato dell'instanza
        var req = new DescribeInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };
        DescribeInstancesResponse res = ec2Client.DescribeInstances(req);

        if (res.Reservations[0].Instances[0].State.Code != 80)
        {
            return; // non fa niente
        }

        StartInstancesRequest launchRequest = new StartInstancesRequest { InstanceIds = { ConfigurationManager.AppSettings["AWS_INSTANCEID"] } };

        try
        {
            // avvia l'istanza      
            StartInstancesResponse launchResponse = ec2Client.StartInstances(launchRequest);
        }
        catch (Exception err)
        {
            var thisPage = this.Page;
            Utilities.CreateMessageAlert(ref thisPage, "Errore in avvio istanza Demo", "null");
        }

        // wait 1 sec   
        System.Threading.Thread.Sleep(1000);

        SetPageData(); // refresh pagina

    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

}