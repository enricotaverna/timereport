using System;
using System.Collections.Generic;
using System.Data;

/// <summary>
/// Descrizione di riepilogo per TRSession
/// Richiamare con CurrentSession = (TRSession)Session["CurrentSession"]; 
/// </summary>
/// 

public class LocationRecord
{
    public string ParentKey { get; set; }
    public string LocationKey { get; set; }
    public string LocationType { get; set; } // P = Project C = Client
    public string LocationDescription { get; set; }
}

public class TRSession
{
    // bufferizza la lista delle location selezionabili in input_spese.aspx
    public List<LocationRecord> LocationList = new List<LocationRecord>();
    // personal setting
    public int Persons_id;
    public int ContractHours;

    public TRSession(int inputPersons_id)
    {
        //
        // TODO: aggiungere qui la logica del costruttore
        //
        Persons_id = inputPersons_id;

        LoadLocationList();
        LoadPersonalSetting();

    }

    public void LoadLocationList() {

        DataTable dt = new DataTable();

        // Carica Location
        dt = Database.GetData("select * from LOC_ClientLocation", null);
        
        // carica Dictionary
        foreach ( DataRow dr in dt.Rows )
        {
            LocationRecord item = new LocationRecord();
            item.ParentKey = dr["CodiceCliente"].ToString().TrimEnd();
            item.LocationKey = dr["ClientLocation_id"].ToString().TrimEnd();
            item.LocationDescription = dr["LocationDescription"].ToString();
            item.LocationType = "C"; // customer, usato su input.aspx.cs
            LocationList.Add(item);
        }

        // Carica Location
        dt = Database.GetData("select * from LOC_ProjectLocation", null);

        // carica Dictionary
        foreach (DataRow dr in dt.Rows)
        {
            LocationRecord item = new LocationRecord();
            item.ParentKey = dr["Projects_id"].ToString();
            item.LocationKey = dr["ProjectLocation_id"].ToString().TrimEnd();
            item.LocationDescription = dr["LocationDescription"].ToString();
            item.LocationType = "P"; // Project, usato su input.aspx.cs
            LocationList.Add(item);
        }

    }

    public void LoadPersonalSetting() {
        DataRow rdr = Database.GetRow("SELECT * from Persons WHERE persons_id= " + ASPcompatility.FormatNumberDB(Persons_id), null);
        ContractHours = Convert.ToInt16(rdr["ContractHours"].ToString());
    }
}