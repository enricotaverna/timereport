using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using Newtonsoft.Json;
using RestSharp;
using Xceed.Words.NET;
 

// ** Basic Class ***
public class EducationSet
{
    //public string EducationId { get; set; }
    public string SortString { get; set; }
    public string Title { get; set; }
    public string Year { get; set; }
    public string School { get; set; }
    //public string Comment { get; set; }
}

public class LanguageSet
{
    public string LanguageName { get; set; }
    public string LanguageLevel { get; set; }
    //public string Comment { get; set; }
}

public class SkillSet
{
    public string Area { get; set; }
    public string SkillDescription { get; set; }
    //public string Comment { get; set; }
}

public class CertificateSet
{
    //public string CertificateId { get; set; }
    public string SortString { get; set; }
    public string Certificate { get; set; }
    public string Institute { get; set; }
    public string Year { get; set; }
    //public string Comment { get; set; }
}

public class ProjectSet
{
    //    public string ProjectId { get; set; }
    public string SortString { get; set; }
    public string Client { get; set; }
    public string Industry { get; set; }
    public string Year { get; set; }
    public string ProjectName { get; set; }
    public string ProjectDescription { get; set; }
    public string Role { get; set; }
    public string JobDescription { get; set; }
}

// ** Classe Curriculum ***
public class Curriculum
{
    // ** header info **
    public string Name { get; set; }
    public string Surname { get; set; }
    public string Level { get; set; }
    public string HireDate { get; set; }
    public string Summary { get; set; }
    public string LastUpdated { get; set; }
    public List<EducationSet> EducationList = new List<EducationSet>();
    public List<LanguageSet> LanguageList = new List<LanguageSet>();
    public List<ProjectSet> ProjectList = new List<ProjectSet>();
    public List<CertificateSet> CertificateList = new List<CertificateSet>();
    public List<SkillSet> SkillList = new List<SkillSet>();

    public const int EducationTableIndex = 1;
    public const int CertificateTableIndex = 2;
    public const int LanguageTableIndex = 3;
    public const int SkillTableIndex = 4;
    public const int ProjectTableIndex = 5;

    public string WordSaved;
    public string CVLanguage;

    public Curriculum()
    {
    }

    // Popola l'oggetto Curriculum dal modello dati tornato dalla API RAGIC (www.ragic.com)
    private bool MapRagiIntoObject(RagicModel model)
    {
        The0 rec = new The0(); // The0 rappresenta la struttura del record tornato dalla API

        try
        {
            // valorizza rec 
            foreach (KeyValuePair<string, The0> pair in model)
                rec = pair.Value;

            // Header
            Name = rec.Name;
            Surname = rec.Surname;
            Level = rec.Level;
            // formatta HireData
            HireDate = (rec.HireDate != null && rec.HireDate != "" ) ? HireDate = rec.HireDate.Substring(8, 2) + "/" + rec.HireDate.Substring(5, 2) + "/" + rec.HireDate.Substring(0, 4) : "";
            Summary = rec.Summary;
            LastUpdated = rec.LastUpdated;

            // Education
            if (rec.Subtable1000040 != null)
                foreach (KeyValuePair<string, Subtable1000040> EduRecord in rec.Subtable1000040)
                EducationList.Add(new EducationSet()
                {
                    //EducationId = FormatField(EduRecord.Value.EducationId),
                    SortString = FormatField(EduRecord.Value.Year).ToString(),
                    Title = EduRecord.Value.Title ?? "",
                    Year = EduRecord.Value.Year ?? "",
                    School = EduRecord.Value.School ?? ""
                    //Comment = EduRecord.Value.Comment ?? ""
                });

            // Certificate
            if (rec.Subtable1000041 != null)
                foreach (KeyValuePair<string, Subtable1000041> CertRecord in rec.Subtable1000041)
                CertificateList.Add(new CertificateSet()
                {
                    //CertificateId = FormatField(CertRecord.Value.CertificateId),
                    SortString = FormatField(CertRecord.Value.Year).ToString(),
                    Certificate = FormatField(CertRecord.Value.Certificate),
                    Institute = FormatField(CertRecord.Value.Institute),
                    Year = FormatField(CertRecord.Value.Year)
                    //Comment = FormatField(CertRecord.Value.Comment)
                });

            // Language
            if (rec.Subtable1000027 != null)
                foreach (KeyValuePair<string, Subtable1000027> LangRecord in rec.Subtable1000027)
                LanguageList.Add(new LanguageSet()
                {
                    LanguageName = LangRecord.Value.LanguageName ?? "",
                    LanguageLevel = LangRecord.Value.LanguageLevel ?? ""
                    //Comment = LangRecord.Value.Comment ?? ""
                });

            // Skill
            if (rec.Subtable1000042 != null)
                foreach (KeyValuePair<string, Subtable1000042> SkillRecord in rec.Subtable1000042)
                SkillList.Add(new SkillSet()
                {
                    Area = FormatField(SkillRecord.Value.Area),
                    SkillDescription = FormatField(SkillRecord.Value.SkillDescription)
                    //Comment = FormatField(SkillRecord.Value.Comment)
                });

            // Project
            if (rec.Subtable1000061 != null)
                foreach (KeyValuePair<string, Subtable1000061> PrjRecord in rec.Subtable1000061)
                    ProjectList.Add(new ProjectSet()
                    {
                        //ProjectId = FormatField(PrjRecord.Value.ProjectId).ToString().PadLeft(6,'0'),
                        SortString = FormatField(PrjRecord.Value.Year).ToString(),
                        Client = FormatField(PrjRecord.Value.Client),
                        Industry = FormatField(PrjRecord.Value.Industry),
                        Year = FormatField(PrjRecord.Value.Year),
                        ProjectName = FormatField(PrjRecord.Value.ProjectName),
                        ProjectDescription = FormatField(PrjRecord.Value.ProjectDescription),
                        Role = FormatField(PrjRecord.Value.Role),
                        JobDescription = FormatField(PrjRecord.Value.JobDescription)
                    });

            return true;
        }
        catch
        {
            return false;
        }
    }

    // formatta campo
    public string FormatField(string input)
    {

        string formattedValue = input ?? "";
        return formattedValue;
    }

    // Chiama API RAGIC e popola gli attributi del modello Curriculum
    public bool BuildFromRagicAPI(string RagidId, string Language)
    {
        bool ret;

        // imposta la lingua del CV, gestito Inglese ed Italiano
        if (Language == "EN" || Language == "IT")
            CVLanguage = Language;
        else
            CVLanguage = "EN";

        // ** RestClient da pacchetto nuget RestSharp
        var client = new RestClient(ConfigurationManager.AppSettings["RAGICURL"]);

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        var request = new RestRequest(ConfigurationManager.AppSettings["APIURL"] + RagidId, Method.GET);
        //request.AddParameter("subtables", "0");
        request.AddParameter("api", "1");
        request.AddParameter("Authorization", ConfigurationManager.AppSettings["APIKEY"], ParameterType.HttpHeader);

        var response = client.Execute(request);

        // converte la stringa nel modello dati    
        RagicModel model = JsonConvert.DeserializeObject<RagicModel>(response.Content);

        // popola i valori dal modello dati Ragic
        ret = MapRagiIntoObject(model);
        return ret;
    }

    // Legge template, sostituisce i valori e salva file finale
    public bool SaveTemplateAs(string templateFile, string targetFile)
    {
        int loopIndex = 0;
        WordSaved = targetFile;

        // utilizzo pacchetto nuget DOCX - https://github.com/xceedsoftware/DocX
        // https://xceed.com/documentation-center/

        // costruisce il nome del file "template" + "-" + EN/IT + ".docx"
        string WordTemplate = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["CURRICULA_PATH"]) + templateFile + "-" + CVLanguage + ".docx";
        using (var document = DocX.Load(WordTemplate))
        {
            document.ReplaceText("<Name>", Name);
            document.ReplaceText("<Surname>", Surname);
            document.ReplaceText("<Level>", Level);
            document.ReplaceText("<HireDate>", HireDate);
            document.ReplaceText("<Summary>", Summary);

            // *** Education ***
            var EducationTable = document.Tables[EducationTableIndex];
            //if (EducationList.Count == 0)  // cancella tabella
            //    EducationTable.Remove();

            for (int i = 1; i < EducationList.Count; i++) // compia la prima riga per N-1 volte
                EducationTable.InsertRow(EducationTable.Rows[0], i, true);

            loopIndex = 0;
            EducationList.Sort((x, y) => y.SortString.CompareTo(x.SortString));
            foreach (EducationSet edu in EducationList)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                EducationTable.Rows[loopIndex].ReplaceText("<Year>", edu.Year);
                EducationTable.Rows[loopIndex].ReplaceText("<Title>", edu.Title);
                EducationTable.Rows[loopIndex].ReplaceText("<School>", edu.School);
                //EducationTable.Rows[loopIndex].ReplaceText("<Comment>", edu.Comment);
                loopIndex++;
            }

            // *** Language ***
            var LanguageTable = document.Tables[LanguageTableIndex];
            //if (LanguageList.Count == 0)  // cancella tabella
            //    LanguageTable.Remove();

            for (int i = 1; i < LanguageList.Count; i++) // compia la prima riga per N-1 volte
                LanguageTable.InsertRow(LanguageTable.Rows[0], i, true);

            loopIndex = 0;
            foreach (LanguageSet lang in LanguageList)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                LanguageTable.Rows[loopIndex].ReplaceText("<LanguageName>", lang.LanguageName);
                LanguageTable.Rows[loopIndex].ReplaceText("<LanguageLevel>", lang.LanguageLevel);
                //LanguageTable.Rows[loopIndex].ReplaceText("<Comment>", lang.Comment);
                loopIndex++;
            }

            // *** Certificate ***
            var CertificateTable = document.Tables[CertificateTableIndex];
            //if (CertificateList.Count == 0)  // cancella tabella
            //    CertificateTable.Remove();

            for (int i = 1; i < CertificateList.Count; i++) // compia la prima riga per N-1 volte
                CertificateTable.InsertRow(CertificateTable.Rows[0], i, true);

            loopIndex = 0;
            CertificateList.Sort((x, y) => y.SortString.CompareTo(x.SortString));
            foreach (CertificateSet cert in CertificateList)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                CertificateTable.Rows[loopIndex].ReplaceText("<Year>", cert.Year);
                CertificateTable.Rows[loopIndex].ReplaceText("<Institute>", cert.Institute);
                CertificateTable.Rows[loopIndex].ReplaceText("<Certificate>", cert.Certificate);
                //CertificateTable.Rows[loopIndex].ReplaceText("<Comment>", cert.Comment);
                loopIndex++;
            }

            // *** Skill ***
            var SkillTable = document.Tables[SkillTableIndex];
            //if (SkillList.Count == 0)  // cancella tabella
            //    SkillTable.Remove();

            for (int i = 1; i < SkillList.Count; i++) // compia la prima riga per N-1 volte
                SkillTable.InsertRow(SkillTable.Rows[0], i, true);

            loopIndex = 0;
            foreach (SkillSet skill in SkillList)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                SkillTable.Rows[loopIndex].ReplaceText("<Area>", skill.Area);
                SkillTable.Rows[loopIndex].ReplaceText("<SkillDescription>", skill.SkillDescription);
                //SkillTable.Rows[loopIndex].ReplaceText("<Comment>", skill.Comment);
                loopIndex++;
            }

            // *** Project ***
            var ProjectTable = document.Tables[ProjectTableIndex];
            //if (ProjectList.Count == 0)  // cancella tabella
            //    ProjectTable.Remove();

            for (int i = 1; i < ProjectList.Count; i++) // compia la prima riga per N-1 volte
                ProjectTable.InsertRow(ProjectTable.Rows[0], i, true);

            loopIndex = 0;
            ProjectList.Sort((x, y) => y.SortString.CompareTo(x.SortString));

            foreach (ProjectSet prj in ProjectList)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                ProjectTable.Rows[loopIndex].ReplaceText("<Year>", prj.Year);
                ProjectTable.Rows[loopIndex].ReplaceText("<Client>", prj.Client);
                ProjectTable.Rows[loopIndex].ReplaceText("<Industry>", prj.Industry);
                ProjectTable.Rows[loopIndex].ReplaceText("<ProjectName>", prj.ProjectName);
                ProjectTable.Rows[loopIndex].ReplaceText("<ProjectDescription>", prj.ProjectDescription);
                ProjectTable.Rows[loopIndex].ReplaceText("<Role>", prj.Role);
                ProjectTable.Rows[loopIndex].ReplaceText("<JobDescription>", prj.JobDescription);
                loopIndex++;
            }

            // Save this document to disk.
            string UrlWordSaved = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["CURRICULA_PATH"]) + targetFile;
            document.SaveAs(UrlWordSaved);
            return true;
        }

    }

    public bool DownloadFile() {

        string UrlWordSaved = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["CURRICULA_PATH"]) + WordSaved;

        using (WebClient wc = new WebClient())
        {
            var desktop = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);

            wc.DownloadFileAsync(
                // Param1 = Link of file
                new System.Uri("http://localhost/" + ConfigurationManager.AppSettings["CURRICULA_PATH"] + WordSaved),
                // Param2 = Path to save
                desktop + WordSaved
            );
        }

        return true;

    }

}

// ** Classe List Curriculum ***
public class CurriculumList {

    // contiene la lista dei record che vengono visualizzati in tabella
    public List<Dictionary<string, string>> Data = new List<Dictionary<string, string>>();

    private void AddManager(Dictionary<string, string> row)
    {
        string userid = "";
        if (row.TryGetValue("TimereportUserId", out userid) && userid != "") // recupera il nome del manager associato alla persona
        {
            DataRow dr = Database.GetRow("Select * from v_Persons where userid = " + ASPcompatility.FormatStringDb(userid), null);
            if (dr != null)
            {
                row.Add("Manager_Id", dr["Manager_id"].ToString()); // arricchisce la tabella con il nome manager
                row.Add("ManagerName", dr["ManagerName"].ToString()); // arricchisce la tabella con il nome manager
            }
        }
        else
        {
            row.Add("Manager_Id", ""); // non trovato
            row.Add("ManagerName", ""); // 
        }
    }

    public void BuildListFromRagicAPI()
    {
        // dichiarazioni            
        List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
        Dictionary<string, string> row; // nome colonna, valore 

        // chiama API ** RestClient da pacchetto nuget  
        var client = new RestClient(ConfigurationManager.AppSettings["RAGICURL"]);

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        var request = new RestRequest(ConfigurationManager.AppSettings["APIURL"], Method.GET);
        request.AddParameter("subtables", "0");
        request.AddParameter("api", "true");
        request.AddParameter("Authorization", ConfigurationManager.AppSettings["APIKEY"], ParameterType.HttpHeader);

        var response = client.Execute(request); // risposta in response.Content

        if (response == null) // nessuna risposta
            return;

        // converte la stringa nel modello dati 
        Dictionary<string, Dictionary<string, string>> model = JsonConvert.DeserializeObject<Dictionary<string, Dictionary<string, string>>>(response.Content);
        foreach(var item in model) {
            row = item.Value;
            AddManager(row);
            Data.Add(row);
        }
    }
}

//      RAGIC API Data Model
//      04.2020
//  *** Generato da https://app.quicktype.io/ ***
//

public class RagicModel : Dictionary<string, The0> { }

public partial class The0
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_star")]
    public bool Star { get; set; }

    [JsonProperty("PersonId")]
    public string PersonId { get; set; }

    [JsonProperty("_index_title_")]
    public string IndexTitle { get; set; }

    [JsonProperty("Name")]
    public string Name { get; set; }

    [JsonProperty("Surname")]
    public string Surname { get; set; }

    [JsonProperty("BornDate")]
    public string BornDate { get; set; }

    [JsonProperty("HireDate")]
    public string HireDate { get; set; }

    [JsonProperty("_index_calDates_")]
    public string IndexCalDates { get; set; }

    [JsonProperty("EmployeeNumber")]
    public string EmployeeNumber { get; set; }

    [JsonProperty("Level")]
    public string Level { get; set; }

    [JsonProperty("CVStatus")]
    public string CvStatus { get; set; }

    [JsonProperty("LastUpdated")]
    public string LastUpdated { get; set; }

    [JsonProperty("AuthorLastUpdate")]
    public string AuthorLastUpdate { get; set; }

    [JsonProperty("Summary")]
    public string Summary { get; set; }

    [JsonProperty("_subtable_1000040")]
    public Dictionary<string, Subtable1000040> Subtable1000040 { get; set; }

    [JsonProperty("_subtable_1000041")]
    public Dictionary<string, Subtable1000041> Subtable1000041 { get; set; }

    [JsonProperty("_subtable_1000027")]
    public Dictionary<string, Subtable1000027> Subtable1000027 { get; set; }

    [JsonProperty("_subtable_1000042")]
    public Dictionary<string, Subtable1000042> Subtable1000042 { get; set; }

    [JsonProperty("_subtable_1000061")]
    public Dictionary<string, Subtable1000061> Subtable1000061 { get; set; }

    [JsonProperty("_index_")]
    public string Index { get; set; }

    [JsonProperty("_seq")]
    public long Seq { get; set; }
}

public partial class Subtable1000027
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_parentRagicId")]
    public long ParentRagicId { get; set; }

    [JsonProperty("_header_Y")]
    public long[] HeaderY { get; set; }

    //[JsonProperty("LanguageId")]
    //public string LanguageId { get; set; } // tolto

    [JsonProperty("LanguageName")]
    public string LanguageName { get; set; }

    [JsonProperty("LanguageLevel")]
    public string LanguageLevel { get; set; }

    //[JsonProperty("Comment")]
    //public string Comment { get; set; }
}

public partial class Subtable1000040
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_parentRagicId")]
    public long ParentRagicId { get; set; }

    [JsonProperty("_header_Y")]
    public long[] HeaderY { get; set; }

    [JsonProperty("EducationId")]
    public string EducationId { get; set; }

    [JsonProperty("Title")]
    public string Title { get; set; }

    [JsonProperty("School")]
    public string School { get; set; }

    [JsonProperty("Year")]
    public string Year { get; set; }

    //[JsonProperty("Comment")]
    //public string Comment { get; set; }
}

public partial class Subtable1000041
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_parentRagicId")]
    public long ParentRagicId { get; set; }

    [JsonProperty("_header_Y")]
    public long[] HeaderY { get; set; }

    [JsonProperty("CertificateId")]
    public string CertificateId { get; set; }

    [JsonProperty("Certificate")]
    public string Certificate { get; set; }

    [JsonProperty("Institute")]
    public string Institute { get; set; }

    [JsonProperty("Year")]
    public string Year { get; set; }

    //[JsonProperty("Comment")]
    //public string Comment { get; set; }
}

public partial class Subtable1000042
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_parentRagicId")]
    public long ParentRagicId { get; set; }

    [JsonProperty("_header_Y")]
    public long[] HeaderY { get; set; }

    //[JsonProperty("SkillId")]
    //public string SkillId { get; set; } // tolto

    [JsonProperty("Area")]
    public string Area { get; set; }

    [JsonProperty("SkillDescription")]
    public string SkillDescription { get; set; }

    //[JsonProperty("Comment")]
    //public string Comment { get; set; }
}

public partial class Subtable1000061
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_parentRagicId")]
    public long ParentRagicId { get; set; }

    [JsonProperty("_header_Y")]
    public long[] HeaderY { get; set; }

    [JsonProperty("ProjectId")]
    public string ProjectId { get; set; }

    [JsonProperty("Year")]
    public string Year { get; set; }

    [JsonProperty("Client")]
    public string Client { get; set; }

    [JsonProperty("Industry")]
    public string Industry { get; set; }

    [JsonProperty("ProjectName")]
    public string ProjectName { get; set; }

    [JsonProperty("ProjectDescription")]
    public string ProjectDescription { get; set; }

    [JsonProperty("Role")]
    public string Role { get; set; }

    [JsonProperty("JobDescription")]
    public string JobDescription { get; set; }
}

public partial class RagicModelList
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_star")]
    public bool Star { get; set; }

    [JsonProperty("PersonId")]
    public string PersonId { get; set; }

    [JsonProperty("_index_title_")]
    public string IndexTitle { get; set; }

    [JsonProperty("Name")]
    public string Name { get; set; }

    [JsonProperty("Surname")]
    public string Surname { get; set; }

    [JsonProperty("BornDate")]
    public string BornDate { get; set; }

    [JsonProperty("_index_calDates_", NullValueHandling = NullValueHandling.Ignore)]
    public string IndexCalDates { get; set; }

    [JsonProperty("HireDate")]
    public string HireDate { get; set; }

    [JsonProperty("EmployeeNumber")]
    public string EmployeeNumber { get; set; }

    [JsonProperty("Level")]
    public string Level { get; set; }

    [JsonProperty("CVStatus")]
    public string CvStatus { get; set; }

    [JsonProperty("Language")]
    public string Language { get; set; }

    [JsonProperty("Company")]
    public string Company { get; set; }

    [JsonProperty("TimereportUsedId")]
    public string TimereportUsedId { get; set; }

    [JsonProperty("LastUpdated")]
    public string LastUpdated { get; set; }

    [JsonProperty("AuthorLastUpdate")]
    public string AuthorLastUpdate { get; set; }

    [JsonProperty("Summary")]
    public string Summary { get; set; }

    [JsonProperty("_index_")]
    public string Index { get; set; }

    [JsonProperty("_seq")]
    public long Seq { get; set; }
}




