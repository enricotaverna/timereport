using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class MyConstants
{
    private DateTime time = DateTime.Now;

    public static int Last_year = DateTime.Now.Year;
    public static int First_year = Last_year - 4;

    // ------ Auth level --------
    public static int AUTH_ADMIN = 5; // aggiornamenti massivi
    public static int AUTH_MANAGER = 4; // Manager
    public static int AUTH_TEAMLEADER = 3; // vede solo sè stesso
    public static int AUTH_EXTERNAL = 1; // vede solo sè stesso
    public static int AUTH_EMPLOYEE = 2; // vede solo sè stesso

    public static string[] aDaysName = new[] { "Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato" };

    public static System.Data.DataTable DTHoliday = new System.Data.DataTable();
}
