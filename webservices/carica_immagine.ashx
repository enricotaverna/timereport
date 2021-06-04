<%@ WebHandler Language="C#" Class="carica_immagine" %>

using System;
using System.Web;
using System.IO;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Web.SessionState;

public class carica_immagine : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        // contenuto del file
        HttpPostedFile file = context.Request.Files[0];

        // estrae il file e i suoi dati
        HttpPostedFile fileupload = context.Request.Files[0];
        string strFileName = Path.GetFileName(fileupload.FileName);
        //string strExtension = Path.GetExtension(fileupload.FileName).ToLower();

        if (file.ContentLength > 0)
        {

            // *** SALVA FILE  ***
            try
            {
                // costruisce il nome directory, formato data da chiamata WS AAAA-MM-GG    
                string TargetLocation = context.Server.MapPath(ConfigurationManager.AppSettings["PATH_IMMAGINI"]);

                // costruisce il nome file     
                string ext = Path.GetExtension(strFileName);
                string filename = "PersonalBkgrImg" + ext;
                //string filename = Path.GetFileName(strFileName);
                string FilePath = TargetLocation + filename;
                string WebPath = ConfigurationManager.AppSettings["PATH_IMMAGINI"] +  filename;

                // salva il file
                context.Request.Files[0].SaveAs(FilePath);

                // costruisce la risposta in formato HTML da passare alla pagina chiamante
                context.Response.ContentType = "application/json";
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();

                string result = WebPath;

                // string imgpath = ext == ".pdf" ? "/timereport/images/icons/other/pdf.png" : WebPath;

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

        return;
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}

