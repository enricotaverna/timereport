using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Net;
using System.Reflection;


// ** Classe List Personale da Ragic ***
public class PersonaleList
{

    public DataTable BuildListFromRagicAPI()
    {
        // dichiarazioni            
        List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
        Dictionary<string, string> row; // nome colonna, valore 

        // contiene la lista dei record che vengono visualizzati in tabella
        DataTable dtPersonale = new DataTable();

        // Usa la riflessione per ottenere tutte le proprietà della classe The1
        PropertyInfo[] properties = typeof(The1).GetProperties();

        // Filtra le proprietà che non iniziano con un underscore e aggiungile come colonne
        foreach (var prop in properties)
        {
            if (!prop.Name.StartsWith("_"))
            {
                dtPersonale.Columns.Add(prop.Name, typeof(string));
            }
        }

        // chiama API ** RestClient da pacchetto nuget  
        var client = new RestClient(ConfigurationManager.AppSettings["RAGICURL"]);

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

        var request = new RestRequest(ConfigurationManager.AppSettings["APIURLPERSONALE"], Method.GET);
        request.AddParameter("subtables", "0");
        request.AddParameter("api", "true");
        request.AddParameter("listing", "true");  // GET pagina lista
        request.AddParameter("where", "1000697,eq,MATERNITA");  // GET filtro
        request.AddParameter("where", "1000697,eq,ASPETTATIVA");  // GET filtro
        request.AddParameter("where", "1000697,eq,ATTIVO");  // GET filtro
        request.AddParameter("Authorization", ConfigurationManager.AppSettings["APIKEY"], ParameterType.HttpHeader);

        var response = client.Execute(request); // risposta in response.Content

        if (response == null) // nessuna risposta
            return null;

        // converte la stringa nel modello dati 
        RagicPersonaleModel model = JsonConvert.DeserializeObject<RagicPersonaleModel>(response.Content);
        foreach (var item in model)
        {
            The1 rec = item.Value;
            DataRow dataRow = dtPersonale.NewRow();

            // Imposta i valori di dataRow utilizzando i nomi delle colonne di dtPersonale
            foreach (DataColumn column in dtPersonale.Columns)
            {
                PropertyInfo prop = typeof(The1).GetProperty(column.ColumnName);
                if (prop != null)
                {
                    dataRow[column.ColumnName] = prop.GetValue(rec) != null ? prop.GetValue(rec).ToString() : null;
                }
            }
            dtPersonale.Rows.Add(dataRow);
        }

        return dtPersonale;
    }
}

//      RAGIC API Data Model
//      04.2020
//  *** Generato da https://app.quicktype.io/ ***
//

public class RagicPersonaleModel : Dictionary<string, The1> { }

public partial class The1
{
    [JsonProperty("_ragicId")]
    public long RagicId { get; set; }

    [JsonProperty("_star")]
    public bool Star { get; set; }

    [JsonProperty("_dataTimestamp")]
    public long DataTimestamp { get; set; }

    [JsonProperty("EMPLOYEE NUMBER")]
    public string EmployeeNumber { get; set; }

    [JsonProperty("CONSULENTE")]
    public string Consulente { get; set; }

    [JsonProperty("IMPEGNO")]
    public string Impegno { get; set; }

    [JsonProperty("ORE GIORNALIERE")]
    public string OreGiornaliere { get; set; }

    [JsonProperty("MAIL AZIENDALE")]
    public string MailAziendale { get; set; }

    [JsonProperty("SEDE")]
    public string Sede { get; set; }

    [JsonProperty("UNITA' ORG.")]
    public string[] UnitaOrg { get; set; }

    [JsonProperty("RUOLO")]
    public string Ruolo { get; set; }

    [JsonProperty("DATA ASSUNZIONE")]
    public string DataAssunzione { get; set; }

    [JsonProperty("DATA CESSAZIONE")]
    public string DataCessazione { get; set; }

    [JsonProperty("_index_calDates_")]
    public string IndexCalDates { get; set; }

    [JsonProperty("_index_")]
    public string Index { get; set; }

    [JsonProperty("_seq")]
    public long Seq { get; set; }
}

