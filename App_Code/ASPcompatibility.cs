using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

public class ASPcompatility
{
    public static string FormatNumberDB(double InputNumber)
    {
        string sRet = "'" + InputNumber.ToString().Replace(",", ".") + "'";
        return sRet;
    }

    public static string FormatStringDb(string InputString)
    {
        string sRet = "'" + InputString.Replace("'", "''") + "'";
        return sRet;
    }

    public static void SelectAnnoMese(ref DropDownList DDL, int MenoMesi, int PiuMesi)
    {
        ListItem lItem;

        // al massimo indietro di 12 mesi    
        if (MenoMesi > 12)
            MenoMesi = 12;

        int MeseCorrente = DateTime.Now.Month;
        int AnnoCorrente = DateTime.Now.Year;

        // MeseCorrente = 3 (Marzo) MenoMesi = 5 => Meseda = 11 / Annoda = AnnoCorrente - 1
        int MeseDa = MeseCorrente - MenoMesi < 0 ? 13 - (MenoMesi - MeseCorrente) : MeseCorrente - MenoMesi;
        int Annoda = MeseCorrente - MenoMesi < 0 ? (AnnoCorrente - 1) : AnnoCorrente;
        int MeseA = MeseCorrente + PiuMesi < 13 ? MeseCorrente + PiuMesi : (MeseCorrente + PiuMesi) - 12;

        int MenoAnno = 0;
        for (int i = MeseDa; i < MeseDa + (MenoMesi + PiuMesi); i++)
        {

            // costruisce anno-mese    

            lItem = new ListItem(Annoda.ToString() + "-" + (i - MenoAnno).ToString("D2"), Annoda.ToString() + "-" + (i - MenoAnno).ToString("D2"));
            if (i == MeseDa + (MenoMesi + PiuMesi) - 1)
                lItem.Selected = true; // l'ultimo è selezionato per default

            DDL.Items.Add(lItem);

            if (i == 12)
            {
                MenoAnno = 12;
                Annoda = Annoda + 1;
            }
        }
    }

    public static void SelectMonths(ref DropDownList DDL, string sLingua = "it")
    {
        int i;
        ListItem lItem;
        CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(sLingua);
        DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

        // elenco dei mesi con default il corrente
        for (i = 1; i <= 12; i++)
        {
            lItem = new ListItem(mfi.MonthNames[i - 1], i.ToString("D2"));
            DDL.Items.Add(lItem);

            if (DateTime.Now.Month == i)
                DDL.SelectedIndex = i - 1;
        }
    }

    public static void SelectYears(ref DropDownList DDL)
    {
        int i;
        ListItem lItem;

        for (i = MyConstants.First_year; i <= MyConstants.Last_year; i++)
        {

            // elenco di anni con default quello corrente
            lItem = new ListItem(i.ToString(), i.ToString());
            DDL.Items.Add(lItem);

            if (DateTime.Now.Year == i)
                DDL.SelectedIndex = i - MyConstants.First_year;
        }
    }

    public static string LastDay(int Month, int Year)
    {
        /* refactoring 2/1/22 */
        string sRet;
        string sDay = DateTime.DaysInMonth(Convert.ToInt32(Year), Convert.ToInt32(Month)).ToString();

        if (Month > 9)
            sRet = sDay + "/" + Month + "/" + Year;
        else
            sRet = sDay + "/" + "0" + Month + "/" + Year;

        return sRet;
    }

    public static int DaysInMonth(int Month, int Year)
    {
        int sRet = DateTime.DaysInMonth(Convert.ToInt32(Year), Convert.ToInt32(Month));
        return sRet;
    }

    public static string FirstDay(int Month, int Year)
    {
        string sRet;

        if (Month > 9)
            sRet = "01" + "/" + Month + "/" + Year;
        else
            sRet = "01" + "/" + "0" + Month + "/" + Year;

        return sRet;
    }

    public static string FormatDatetimeDb(DateTime DateToConvert, bool timestamp = false) {

        string sRet = "";
        CultureInfo cultureIT = CultureInfo.GetCultureInfo("it-IT");

        string server = ConfigurationManager.AppSettings["FORMATODATA"];

        string shortUS = "MM-dd-yyyy";
        string longUS = "MM-dd-yyyy HH:mm:ss";
        string shortIT = "dd-MM-yyyy";
        string longIT = "dd-MM-yyyy HH:mm:ss";
        string dateFormat;

        if (server == "US")
        {
            if (timestamp)
                dateFormat = longUS;
            else
                dateFormat = shortUS;
        }
        else {
            if (timestamp)
                dateFormat = longIT;
            else
                dateFormat = shortIT;
        }

        sRet = "'" + DateToConvert.ToString(dateFormat) + "'";
        return sRet;
    }

    public static string FormatDateDb(string sDateToConvert, bool timestamp = false)
    {
        int aDay;
        int aMonth;
        int aYear;
        string sRet = "";

        DateTime DateToConvert;

        if (sDateToConvert == "")
        {
            sRet = "NULL";
            return sRet;
        } //  init

        if (timestamp)
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy HH.mm.ss", System.Globalization.CultureInfo.InvariantCulture);
        else
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy", System.Globalization.CultureInfo.InvariantCulture);

        aDay = DateToConvert.Day;
        aMonth = DateToConvert.Month;
        aYear = DateToConvert.Year;

        string server = ConfigurationManager.AppSettings["FORMATODATA"];

        switch (server)
        {
            case "US":
                {
                    sRet = "'" + aMonth + "-" + aDay + "-" + aYear;
                    break;
                }

            case "IT":
                {
                    sRet = "'" + aDay + "-" + aMonth + "-" + aYear;
                    break;
                }
        }

        // se richiamato con parametro opzionale timestamp aggiunge ore:min:sec
        if (timestamp)
            sRet = sRet + " " + DateToConvert.Hour + ":" + DateToConvert.Minute + ":" + DateToConvert.Second + "'";
        else
            sRet = sRet + "'";

        return sRet;
    }

    public static DataRowCollection GetRows(string sSQLstring)
    {
        DataSet ds;
        DataRowCollection drRet;

        var connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlDataAdapter Adapter = new SqlDataAdapter(sSQLstring, connection))
            {
                try
                {
                    ds = new DataSet();
                    Adapter.Fill(ds);

                    if (ds.Tables[0].Rows.Count == 0)
                        drRet = null;
                    else
                        drRet = ds.Tables[0].Rows;
                }
                catch (Exception ex)
                {
                    drRet = null;
                }
            }
        }
        return drRet;
    }
}
