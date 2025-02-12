<%@ WebService Language="C#" Class="WStimereport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WStimereport : System.Web.Services.WebService
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    public WStimereport()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //  **** CANCELLA FILE ***** 
    // Riceve in input il nome file in format Web e cancella fisicamente il file dalla directory   
    [WebMethod(EnableSession = true)]
    public string cancella_file(string sfilename)
    {

        try
        {
            File.Delete(Server.MapPath(sfilename));
        }
        catch (IOException copyError)
        {
            // error
            return ("1");
        }


        // dopo aver cancellato forza il refresh del buffer usato per stampare l'icona della ricevuta su input.aspx
        Session["RefreshRicevuteBuffer"] = "refresh";
        return ("0");

    }

    // Crea CostRateAnno
    // Richiamata da finestra modale su lista CostRateAnno_list
    [WebMethod(EnableSession = true)]
    public void CreaCostRateAnno(string sPersonsId, string sAnno, float fCostRate, string sComment)
    {

        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        // se presente un record per la stessa chiave lo cancella       
        string cmdText = "DELETE FROM PersonsCostRate WHERE " +
                  " Persons_id = '" + sPersonsId + "' AND " +
                  " Anno = '" + sAnno + "'; ";

        // crea nuovo record
        cmdText = cmdText + "INSERT INTO PersonsCostRate (Persons_id, Anno, CostRate, Comment) " +
                  "values ( '" + sPersonsId + "' ," +
                            "'" + sAnno + "' ," +
                            "'" + fCostRate + "' ," +
                            "'" + sComment + "' )";
        Database.ExecuteSQL(cmdText, null);

        return;
    }

    [WebMethod(EnableSession = true)]
    public string CheckPassword(string sUserName, string sPassword)
    {
        if (Database.RecordEsiste("SELECT * FROM Persons WHERE Persons_id = " + sUserName + " AND password='" + sPassword + "'"))
            return ("true");
        else
            return ("false");
    }

    [WebMethod(EnableSession = true)]
    public bool CheckExistence(string sKey, string sValkey, string sTable)
    {
        bool bRet = false;
        DataRow drRow = Database.GetRow("SELECT * FROM " + sTable + " WHERE " + sKey + "='" + sValkey + "'", null);

        if (drRow != null)
            bRet = true;
        else
            bRet = false;

        return (bRet);
    }

    [WebMethod(EnableSession = true)]
    public string CheckCaricoSpesa(int projects_id, int persons_id, string date)
    {
        string retMessage = "";
        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        // se torna una stringa diversa da "" emette un messaggio di avvertimento sul form inputspese.aspx
        if (!Database.RecordEsiste("Select hours_id , projects_id from Hours where projects_id= " + ASPcompatility.FormatNumberDB(projects_id) +
                                    " AND date = " + ASPcompatility.FormatDateDb(date) +
                                    " AND persons_id = " + ASPcompatility.FormatNumberDB(persons_id)
                                    ))
            retMessage = CurrentSession.Language == "en" ? "Check: For the date no corresponding hours exists for this project" : "Attenzione: In questa data non è presente nessun carico ore per questo progetto";

        if (!Database.RecordEsiste("Select hours_id , projects_id from Hours where date = " + ASPcompatility.FormatDateDb(date) + " AND persons_id = " + ASPcompatility.FormatNumberDB(persons_id) ) )
            retMessage = CurrentSession.Language == "en" ? "Check: Hour record does not exist for this date" : "Non esiste un carico ore in questa data";

        return retMessage;

    }    
}
    