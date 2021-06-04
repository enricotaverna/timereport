<%@ WebHandler Language="C#" Class="carica_file" %>

using System;
using System.Web;
using System.IO;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class carica_file : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest(HttpContext context)
    {
        // contenuto del file
        HttpPostedFile file = context.Request.Files[0];
        
        // recupera valori dei parametri in querystring      
        var Tbdate = context.Request["TbDate"];
        var UserName = context.Request["UserName"];
        var expenses_id = context.Request["expenses_id"];
        
        // estrae il file e i suoi dati
        HttpPostedFile fileupload = context.Request.Files[0];
        string strFileName = Path.GetFileName(fileupload.FileName);
        string strExtension = Path.GetExtension(fileupload.FileName).ToLower();
        
        if (file.ContentLength > 0)
        {
            
            // *** SALVA FILE  ***
            try
            {
                // costruisce il nome directory, formato data da chiamata WS AAAA-MM-GG    
                string TargetLocation = context.Server.MapPath(ConfigurationManager.AppSettings["PATH_RICEVUTE"]) + Tbdate.Substring(6, 4) + "\\" + Tbdate.Substring(3, 2) + "\\" + UserName.Trim() + "\\";

                // se non esiste la directory la crea
                DirectoryInfo DITargetLocation = new DirectoryInfo(TargetLocation);
                if (!DITargetLocation.Exists)
                    DITargetLocation.Create();

                // costruisce il nome file     
                string ext = Path.GetExtension(strFileName);
                string filename = "fid-" + expenses_id + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ext;
                string FilePath = TargetLocation + filename;
                string WebPath = ConfigurationManager.AppSettings["PATH_RICEVUTE"] + Tbdate.Substring(6, 4) + "\\" + Tbdate.Substring(3, 2) + "\\" + UserName.Trim() + "\\" + filename;
                
                // salva il file
                context.Request.Files[0].SaveAs(FilePath); 
                
                // costruisce la risposta in formato HTML da passare alla pagina chiamante
                context.Response.ContentType = "application/json";
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();

                string result = "";

                string imgpath = ext == ".pdf" ? "/timereport/images/icons/other/pdf.png" : WebPath;

                result = "<tr id='" + WebPath.Replace("\\", "/") + "'><td widht=50px align=center ><a  href='" + WebPath + "' download='" + filename + "'><img height=45 src='" + imgpath + "' /></a></td>" +
                        "<td widht=50px ><a href='" + WebPath + "' download='" + filename + "'><img height=20 src='/timereport/images/icons/other/download-50.png' /></a></td>" +
                        "<td widht=40px ><a href='#' onclick=\"cancella_ricevuta('" + WebPath.Replace("\\", "/") + "');\"><img height=20 src='/timereport/images/icons/other/empty_trash-50.png' /></a></td></tr>";

               string jsondata = javaScriptSerializer.Serialize(result);

                context.Response.Write(jsondata);                    
                            
            }
            catch (Exception exp)
            {
                //    Console.WriteLine("Error: " + exp);
            }
            finally
            {
            }

        }

        // forza il refresh del buffer ricevute usato per stampare icona nello screen di riepilogo
        HttpContext.Current.Session["RefreshRicevuteBuffer"] = "refresh";       

        return;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}

