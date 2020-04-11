using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class MyConstants
{
    private DateTime time = DateTime.Now;

    public static int Last_year = DateTime.Now.Year;
    public static int First_year = Last_year - 5;

    // ------ Auth level --------
    public static int AUTH_ADMIN = 5; // aggiornamenti massivi
    public static int AUTH_MANAGER = 4; // Manager
    public static int AUTH_TEAMLEADER = 3; // vede solo sè stesso
    public static int AUTH_EXTERNAL = 1; // vede solo sè stesso
    public static int AUTH_EMPLOYEE = 2; // vede solo sè stesso

    public static int TRAINIG_ATTENDED = 4; // corso eseguito

    public static string MAIL_FROM = "enrico.taverna@aeonvis.com"; // mail da cui si spedisce
    public static string MAIL_TEMPLATE_PATH = "/timereport/Templates/";
    //    Stati del WF Approvativo
    public static string WF_REQUEST = "REQU";
    public static string WF_APPROVED = "APPR";
    public static string WF_NOTIFIED = "NOTF";
    public static string WF_REJECTED = "REJE";
    public static string WF_DELETED = "DELE";
    //    Parametri per invio mail
    public static string SMTP_HOST = "smtp.office365.com";
    public static int SMTP_PORT = 587;
    public static bool SMTP_SSL = true;
    public static string SMTP_USER = "enrico.taverna@aeonvis.com";
    public static string SMTP_PWD = "Vcdpsv0c";
    public static string SMTP_TEMPLATE = "WF_Mail.html";

    public static string[] aDaysName = new[] { "Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato" };

    public static System.Data.DataTable DTHoliday = new System.Data.DataTable();

    // 
    public static int DAYS_TO_EVALUATE = 60; // da quanti giorni max è scaduto il training da valutare
}

// usata per passare i parametri variabili come lista tra procedure
public class TipoParametri
{
    public string pKey { get; set; }
    public string pValue { get; set; }

    public TipoParametri(string key, string value) {
        pKey = key;
        pValue = value;
    }
}

// caricata da default.apsx con i dati del manager approvatore
public class ApprovalManager
{
    public int persons_id;
    public string name;
    public string mail;
}
