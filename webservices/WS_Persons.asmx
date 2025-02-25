<%@ WebService Language="C#" Class="WS_Persons" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.IO;

/// <summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_Persons : System.Web.Services.WebService
{

    public TRSession CurrentSession;

    public WS_Persons()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    public class PersonData
    {
        public string EmployeeNumber { get; set; }
        public string Consulente { get; set; }
        public string OreGiornaliere { get; set; }
        public string MailAziendale { get; set; }
        public string Sede { get; set; }
        // public string[] UnitaOrg { get; set; }
        public string Ruolo { get; set; }
        public string DataAssunzione { get; set; }
        public string DataCessazione { get; set; }
    }

    //  **** COPIA PROGETTO ***** 
    [WebMethod(EnableSession = true)]
    public PersonData GetPersonData(string EmployeeNumber)
    {
        CurrentSession = (TRSession)Session["CurrentSession"];

        PersonData data = new PersonData();
        DataTable dtPersonale = CurrentSession.dtPersonale;
        // Load Calendar records
        DataTable dtCalendar = Database.GetData("SELECT Calendar_id, UPPER(CalName) AS CalName FROM Calendar");
        DataTable dtRoles = Database.GetData("SELECT Roles_id, UPPER(Name) AS Name FROM Roles");

        if (dtPersonale != null)
        {
            DataRow[] foundRows = dtPersonale.Select(string.Format("EmployeeNumber = '{0}'", EmployeeNumber));

            if (foundRows.Length > 0)
            {
                DataRow row = foundRows[0];

                data.EmployeeNumber = row["EmployeeNumber"].ToString();
                data.Consulente = row["Consulente"].ToString();
                data.OreGiornaliere = row["OreGiornaliere"].ToString();
                data.MailAziendale = row["MailAziendale"].ToString();
                data.OreGiornaliere = row["OreGiornaliere"].ToString();

                // valorizza chiave sede   
                string sede = row["Sede"].ToString().ToUpper();
                DataRow[] calendarRows = dtCalendar.Select(string.Format("CalName = '{0}'", sede));
                data.Sede = calendarRows.Length > 0 ? calendarRows[0]["Calendar_id"].ToString() : "";

                // valorizza chiave ruolo, i ruolo sono in formato es. 01 - CONSULTANT  
                string ruolo = row["Ruolo"].ToString().ToUpper().Substring(5);
                DataRow[] rolesRows = dtRoles.Select(string.Format("Name = '{0}'", ruolo));
                data.Ruolo = rolesRows.Length > 0 ? rolesRows[0]["Roles_id"].ToString() : "";

                data.DataAssunzione = FormatDate(row["DataAssunzione"].ToString());
                if (dtPersonale.Columns.Contains("DataCessazione") && row["DataCessazione"] != DBNull.Value)
                    data.DataCessazione = FormatDate(row["DataCessazione"].ToString());
            }
        }

        return data;
    }

    private string FormatDate(string date)
    {
        var parts = date.Split('/');
        if (parts.Length == 3)
        {
            return String.Format("{0}/{1}/{2}", parts[2], parts[1], parts[0]);
        }
        return date;
    }
}