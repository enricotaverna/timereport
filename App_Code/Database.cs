﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public class Database
{

    // 02-09-2018 FUNZIONE MIGRATA
    public static object ExecuteScalar(string cmdText, Page mypage)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        object oRet;

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            DataTable dtRecord = new DataTable();
            using (SqlCommand cmd = new SqlCommand(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    oRet = cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteScalar: " + ex.Message + "');", true);
                    oRet = 0;
                }
            }
        }

        return oRet;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool ExecuteSQL(string cmdText, Page mypage)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteSQL: " + ex.Message + "');", true);
                    return false;
                }
            }
        }
        return true;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool RecordEsiste(string cmdText)
    {
        return RecordEsiste(cmdText, null/* TODO Change to default(_) if this is not a reference type */);
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool RecordEsiste(string cmdText, Page mypage)
    {
        // 02-09-2018 FUNZIONE MIGRATA
        bool result = false;

        var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            DataTable dtRecord = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    da.Fill(dtRecord);

                    if (dtRecord.Rows.Count >= 1)
                        result = true;
                    else
                        result = false;
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE RecordEsiste: " + ex.Message + "');", true);
                    result = false;
                }
            }
        }

        return result;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static DataTable GetData(string cmdText, Page mypage)
    {
        DataTable dt = new DataTable();

        using (SqlConnection lCon = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = lCon.CreateCommand())
            {
                lCon.Open();
                using (var sda = new SqlDataAdapter(cmd))
                {
                    try
                    {
                        cmd.CommandText = cmdText;
                        cmd.CommandType = CommandType.Text;
                        sda.Fill(dt);
                    }
                    catch (Exception ex)
                    {
                        if (!(mypage == null))
                            mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE GetData: " + ex.Message + "');", true);
                    }
                }
            }
        }

        return dt;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static DataRow GetRow(string cmdText, Page mypage)
    {
        DataTable dtTable = Database.GetData(cmdText, mypage);
        DataRow drRet;

        if ((dtTable.Rows.Count > 0))
            drRet = dtTable.Rows[0];
        else
            drRet = null/* TODO Change to default(_) if this is not a reference type */;

        return drRet;
    }

    // 30-10-2018: Ritorna ultimo Id Creato
    public static int GetLastIdInserted(string cmd)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        int iNewId = 0;

        try
        {

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // recupera nuovo inserimento
                using (SqlCommand cmdId = new SqlCommand(cmd, connection))
                {
                    connection.Open();
                    iNewId = (int)cmdId.ExecuteScalar(); // ultimo id inserito
                }
            }
        }
        catch (Exception e)
        {
        }

        return iNewId;

    }

    // 04.2020 : converte datatable a Json
    public static string FromDatatableToJson(DataTable dt)
    {

        string sret;

        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;
        foreach (DataRow dr in dt.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        sret = serializer.Serialize(rows);

        return sret;

    }

    // 01.2023 : torna query in formato Json
    public static string FromSQLSelectToJson(string query) {
        string JsonString;

        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                JsonString = serializer.Serialize(rows);
                return JsonString;
            }
        }

    }
}