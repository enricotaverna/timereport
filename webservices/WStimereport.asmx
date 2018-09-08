<%@ WebService Language="C#" Class="WStimereport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Linq;

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WStimereport : System.Web.Services.WebService {

    public WStimereport () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //  **** CANCELLA FILE ***** 
    // Riceve in input il nome file in format Web e cancella fisicamente il file dalla directory   
    [WebMethod(EnableSession = true)]
    public string cancella_file(string sfilename) {
                
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

    //  **** CANCELLA SPESA ***** 
    // Riceve in input l'id univoco e la data (YYYYMMGG) della spesa e cancella record e ricevute relative
    // abilita la gestione delle sessioni per poter forzare il refresh del buffer delle ricevute
    [WebMethod(EnableSession = true)]
    public string CancellaSpesaERicevuta(int iIdSpesa, string sUsername,  string sDataSpesa )
    {

        // cancella record da DB
        try
        {
            Database.ExecuteSQL("DELETE FROM expenses WHERE expenses_id=" + iIdSpesa.ToString(), null);
        
            // estrae file associati all'id della spesa, data formato YYYYMMGG
            string[] filePaths = TrovaRicevuteLocale(iIdSpesa, sUsername, sDataSpesa);

            if (filePaths == null)
                return "OK";
        
            // se ci sono li cancella
                for (int i = 0; i < filePaths.Length; i++)
                    File.Delete(filePaths[i]);
        }
        
        catch (IOException copyError)
        {
            // error
            return "ERRORE";
        }
                
        return "OK";        
    }

    // riceve in input id spesa, nome user, data spesa (YYYYMMGG) e restutuisce array con nome file
    // Se id spesa = -1 allora estrae tutte le spese del mese per l'utente
    public static string[] TrovaRicevuteLocale(int iId, string sUserName, string sData)
    {

        string[] filePaths = null;

        try
        {
            // costruisci il pach di ricerca: public + anno + mese + nome persona 
            string TargetLocation = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sData.Substring(0, 4) + "\\" + sData.Substring(4, 2) + "\\" + sUserName + "\\";
            // carica immagini
            filePaths = Directory
                        .GetFiles(TargetLocation, "fid-" + (iId == -1 ? "" : iId.ToString()) + "*.*")
                        .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                        .ToArray();
            return (filePaths);
        }
        catch (Exception e)
        {
            //non fa niente ma evita il dump
            return (null);
        }

    }
    
}