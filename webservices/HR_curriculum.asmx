<%@ WebService Language="C#" Class="HR_curriculum" %>

using System.Web.Services;
using System.Web.Script.Serialization;

// definisce la struttura  da ritornare con GetCVList
//public class CVrecord
//{
//    public string Cv_id { get; set; }
//    public string LastUpdated { get; set; }
//    public string AuthorLastUpdate { get; set; }
//    public string CVStatus { get; set; }
//    public string Name { get; set; }
//    public string Surname { get; set; }
//    public string Level { get; set; }
//}

//
// *** INIZIO WEB SERVICE
//
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class HR_curriculum : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]
    public string GetCVList()
    {
        string ret;

        // Oggetto CurriculumList contiene la lista dei CV
        CurriculumList CVList = new CurriculumList();

        // Chiama API e popola la struttura Data
        CVList.BuildListFromRagicAPI();

        // carica struttura List<> di ritorno
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        ret = serializer.Serialize(CVList.Data);
        return ret;
    }

    public class CVreturn {
        public bool Result { set; get; }
        public string Filename { set; get; }

    }

    [WebMethod(EnableSession = true)]
    public CVreturn CreateCV(string RagicId, string Language)
    {

        // Oggetto Curriculum contiene i dati del singolo CV
        Curriculum WordCV = new Curriculum();
        CVreturn rc = new CVreturn();

        if (WordCV.BuildFromRagicAPI(RagicId, Language)) // torna true se ha caricato correttamente i dati 
        {
            rc.Filename = "CV-" + WordCV.Surname + "-" + Language + "-" + WordCV.LastUpdated.Replace("/", "") + ".docx";
            WordCV.SaveTemplateAs("TemplateCurriculum", rc.Filename);
            WordCV.DownloadFile();
            rc.Result = true;
        }
        else
            rc.Result = false;

        return rc;
    }

}    