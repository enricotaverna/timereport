/// <reference path="../../m_gestione/AuthPermission/AuthPermission.aspx" />
//The following line is critical for menu operation, and MUST APPEAR ONLY ONCE. If you have more than one menu_array.js file rem out this line in subsequent files
menunum=0;menus=new Array();_d=document;function addmenu(){menunum++;menus[menunum]=menu;}function dumpmenus(){mt="<script language=javascript>";for(a=1;a<menus.length;a++){mt+=" menu"+a+"=menus["+a+"];"}mt+="<\/script>";_d.write(mt)}
//Please leave the above line intact. The above also needs to be enabled if it not already enabled unless this file is part of a multi pack.

////////////////////////////////////
// Editable properties START here //
////////////////////////////////////

// Gestione Autorizzazioni
const AUTH_EXTERNAL = 1;
const AUTH_EMPLOYEE = 2;
const AUTH_TEAMLEADER = 3;
const AUTH_MANAGER = 4;
const AUTH_ADMIN = 5;
const AUTH_TRAINER = 6;

// Legge livello autorizzazioni da file chiamante
var sUserLevel = AUTH_EXTERNAL;
if (document.getElementById("IncludeMenu") != null) {
    sUserLevel = document.getElementById("IncludeMenu").getAttribute("UserLevel");
	sLingua = document.getElementById("IncludeMenu").getAttribute("lingua");
    sNoExpenses = document.getElementById("IncludeMenu").getAttribute("NoExpenses");

	if (sLingua == null)
		sLingua = "it";
}

if(navigator.appVersion.indexOf("MSIE 6.0")>0)
{
	effect = "Fade(duration=0.2);Alpha(style=0,opacity=88);Shadow(color='#777777', Direction=135, Strength=5)"
}
else
{
	effect = "Shadow(color='#777777', Direction=135, Strength=5)" // Stop IE5.5 bug when using more than one filter
}


timegap=500				// The time delay for menus to remain visible
followspeed=5			// Follow Scrolling speed
followrate=40			// Follow Scrolling Rate
suboffset_top=10;		// Sub menu offset Top position 
suboffset_left=10;		// Sub menu offset Left position

style1=[				// style1 is an array of properties. You can have as many property arrays as you need. This means that menus can have their own style.
"navy",					// Mouse Off Font Color
"ccccff",				// Mouse Off Background Color
"ffebdc",				// Mouse On Font Color
"4b0082",				// Mouse On Background Color
"000000",				// Menu Border Color 
11,						// Font Size in pixels
"normal",				// Font Style (italic or normal)
"bold",					// Font Weight (bold or normal)
"Verdana, Arial",		// Font Name
4,						// Menu Item Padding
"/timereport/images/arrow.gif",				// Sub Menu Image (Leave this blank if not needed)
,						// 3D Border & Separator bar
"66ffff",				// 3D High Color
"000099",				// 3D Low Color
"",				// Current Page Item Font Color (leave this blank to disable)
"",					// Current Page Item Background Color (leave this blank to disable)
"/timereport/images/arrowdn.gif",			// Top Bar image (Leave this blank to disable)
"ffffff",				// Menu Header Font Color (Leave blank if headers are not needed)
"000099",				// Menu Header Background Color (Leave blank if headers are not needed)
]

XPMainStyle=[                 // XPMainStyle is an array of properties. You can have as many property arrays as you need
"FFFFFF",                     // Mouse Off Font Color
// "C5BA99",                  // Mouse Off Background Color (use zero for transparent in Netscape 6)
"000000",                           // Mouse Off Background Color (use zero for transparent in Netscape 6)
"000000",                     // Mouse On Font Color
"C1D2EE",                     // Mouse On Background Color
"",                          // Menu Border Color
"12",                         // Font Size (default is px but you can specify mm, pt or a percentage)
"normal",                     // Font Style (italic or normal)
"normal",                     // Font Weight (bold or normal)
"Tahoma,Helvetica,Verdana",   // Font Name
5,                            // Menu Item Padding or spacing
,                             // Sub Menu Image (Leave this blank if not needed)
0,                            // 3D Border & Separator bar
,                             // 3D High Color
,                             // 3D Low Color
,                             // Current Page Item Font Color (leave this blank to disable)
,                             // Current Page Item Background Color (leave this blank to disable)
,                             // Top Bar image (Leave this blank to disable)
,                             // Menu Header Font Color (Leave blank if headers are not needed)
,                             // Menu Header Background Color (Leave blank if headers are not needed)
,                             // Menu Item Separator Color
]

XPMenuStyle=[                 // XPMenuStyle is an array of properties. You can have as many property arrays as you need
"000000",                     // Mouse Off Font Color
"transparent",                // Mouse Off Background Color (use zero for transparent in Netscape 6)
"000000",                     // Mouse On Font Color
"C1D2EE",                     // Mouse On Background Color
"8A867A",                     // Menu Border Color
"12",                         // Font Size (default is px but you can specify mm, pt or a percentage)
"normal",                     // Font Style (italic or normal)
"normal",                     // Font Weight (bold or normal)
"Tahoma,Helvetica,Verdana",   // Font Name
2,                            // Menu Item Padding or spacing
,     // Sub Menu Image (Leave this blank if not needed)
0,                            // 3D Border & Separator bar
,                             // 3D High Color
,                             // 3D Low Color
,                             // Current Page Item Font Color (leave this blank to disable)
,                             // Current Page Item Background Color (leave this blank to disable)
,                             // Top Bar image (Leave this blank to disable)
,                             // Menu Header Font Color (Leave blank if headers are not needed)
,                             // Menu Header Background Color (Leave blank if headers are not needed)
,                             // Menu Item Separator Color
]

addmenu(menu=[		// This is the array that contains your menu properties and details
"mainmenu",			// Menu Name - This is needed in order for the menu to be called
10,					// Menu Top - The Top position of the menu in pixels
12,				// Menu Left - The Left position of the menu in pixels
,					// Menu Width - Menus width in pixels
0,					// Menu Border Width 
,					// Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
XPMainStyle,				// Properties Array - this is set higher up, as above
1,					// Always Visible - allows the menu item to be visible at all time (1=on/0=off)
"left",				// Alignment - sets the menu elements text alignment, values valid here are: left, right or center
effect,				// Filter - Text variable for setting transitional effects on menu activation - see above for more info
,					// Follow Scrolling - Tells the menu item to follow the user down the screen (visible at all times) (1=on/0=off)
1, 					// Horizontal Menu - Tells the menu to become horizontal instead of top to bottom style (1=on/0=off)
,					// Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on/0=off)
,					// Position of TOP sub image left:center:right
,					// Set the Overall Width of Horizontal Menu to 100% and height to the specified amount (Leave blank to disable)
,					// Right To Left - Used in Hebrew for example. (1=on/0=off)
,					// Open the Menus OnClick - leave blank for OnMouseover (1=on/0=off)
,					// ID of the div you want to hide on MouseOver (useful for hiding form elements)
,					// Reserved for future use
,					// Reserved for future use
,					// Reserved for future use
,"Home","/timereport/menu.aspx",,"Back to the home page",1 // "Description Text", "URL", "Alternate URL", "Status", "Separator Bar"
, (sLingua =='it') ? "Inserisci&nbsp;Dati&nbsp;&nbsp;" : "Input&nbsp;Data&nbsp;&nbsp;","show-menu=Inserisci",,"",1
,"Report&nbsp;&nbsp;","show-menu=Report",,"",1
, (sLingua == 'it') ? "Utilita'&nbsp;&nbsp;" : "Utility&nbsp;&nbsp;", "show-menu=Utilita", , "", 1
, (sLingua == 'it') ?  "Progetti&nbsp;&nbsp;" : "Projects&nbsp;&nbsp;", "show-menu=Progetti", , "", 1
, (sLingua == 'it') ? "Amministrazione&nbsp;&nbsp;" : "Administration&nbsp;&nbsp;", "show-menu=Amministrazione", , "", 1
, (sLingua == 'it') ? "HR&nbsp;&nbsp;" : "HR&nbsp;&nbsp;", "show-menu=HR", , "", 1
,"Logout&nbsp;&nbsp;","/timereport/logout.aspx",,"",1
])

// cancella menu progetti (Manager)
if (sUserLevel == AUTH_EXTERNAL )
		menu.splice(42, 15);

// cancella menu Amministrazione
if (sUserLevel == AUTH_TRAINER | sUserLevel == AUTH_MANAGER)
		menu.splice(47, 5);

// cancella menu progetti e amministrazione
if (sUserLevel == AUTH_EMPLOYEE | sUserLevel == AUTH_TEAMLEADER )
    menu.splice(42, 15); // da mettere 10 per avere il menu HR

	if (sUserLevel == AUTH_EXTERNAL)
		addmenu(menu = ["Report",
		, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
		, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Report Ore e Spese" : "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Hours and Expenses", "/timereport/esporta.aspx", , , 1
		, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/giustificativi.gif border=0>&nbsp;Report giustificativi" :"<img src=/timereport/images/icons/16x16/giustificativi.gif border=0>&nbsp;Tickets" , "/timereport/report/ricevute/ricevute_select_user.aspx", , , 1
		])
	else
		addmenu(menu=["Report",
		,,180,1,"",style1,,"",effect,,,,,,,,,,,,
        , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Report Ore e Spese", "/timereport/esporta.aspx", , , 1
		, "<img src=/timereport/images/icons/16x16/giustificativi.gif border=0>&nbsp;Report giustificativi", "/timereport/report/ricevute/ricevute_select_user.aspx", , , 1
        ])	

if (sUserLevel == AUTH_EXTERNAL)
    if (sNoExpenses == "false")
		addmenu(menu=["Inserisci",
		,,180,1,"",style1,,"",effect,,,,,,,,,,,,
		, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Ore" : "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Hours", "/timereport/input.aspx?type=hours", , , 1
		, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Spese" : "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Expenses", "/timereport/input.aspx?type=expenses", , , 1
		, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbspUpload spese" : "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbspUpload expenses", "/timereport/m_utilita/upload-expenses-xls.aspx", , , 1
        ])
    else
        addmenu(menu = ["Inserisci",
            , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
            , (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Ore" : "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Hours", "/timereport/input.aspx?type=hours", , , 1
        ])

if (sUserLevel != AUTH_EXTERNAL)
		addmenu(menu = ["Inserisci",
		, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
		, "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Ore", "/timereport/input.aspx?type=hours", , , 1
		, "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Spese", "/timereport/input.aspx?type=expenses", , , 1
		, "<img src=/timereport/images/icons/16x16/restaurant.png border=0>&nbsp;Ticket", "/timereport/input.aspx?type=bonus", , , 1
		, "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbsp;Upload spese", "/timereport/m_utilita/upload-expenses-xls.aspx", , , 1
		])

	addmenu(menu=["Utilita",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	, (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/password.gif border=0>&nbsp;Cambia password" : "<img src=/timereport/images/icons/16x16/password.gif border=0>&nbsp;Change password", "/timereport/m_utilita/change-password.aspx", , , 1])
	
	addmenu(menu=["Amministrazione",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "Gestione Chiusura", "show-menu=Amm_CutOff", , , 1
	, "<img src=/timereport/images/icons/16x16/persone.gif border=0>&nbsp;Anagrafica Clienti", "/timereport/m_gestione/customer/customer_lookup_list.aspx", , , 1
	, "Modifiche massive", "show-menu=Amm_MassChange", , , 1
	, "Persone", "show-menu=Persone", , , 1
	, "Gestione Economics", "show-menu=Amm_Economics", , , 1
	, "Tabelle valori", "show-menu=Tabelle", , , 1
	, "Report", "show-menu=Amm_Export", , , 1
])


addmenu(menu = ["HR",
    , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "Training", "show-menu=Training", , , 1
])


// solo admin e trainer hanno il menu completo
if (sUserLevel == AUTH_ADMIN || sUserLevel == AUTH_TRAINER) {

    addmenu(menu = ["Training",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "Catalogo", "show-menu=Catalogo", , , 1
        , "Training plan", "show-menu=Training plan", , , 1
        , "Report&Download", "show-menu=Training report", , , 1
    ])

    addmenu(menu = ["Catalogo",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Corso", "/timereport/lookup_list.aspx?TableName=HR_CourseType&SortField=CourseTypeName&FieldNumber=1&init=true&CheckTable=HR_Course", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Prodotti", "/timereport/lookup_list.aspx?TableName=HR_Product&SortField=ProductName&FieldNumber=1&init=true&CheckTable=HR_Course", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Vendor Corso", "/timereport/lookup_list.aspx?TableName=HR_CourseVendor&SortField=VendorName&FieldNumber=1&init=true&CheckTable=HR_Course", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Catalogo corsi", "/timereport/m_gestione/training/CourseCatalog.aspx", , , 1
    ])

    addmenu(menu = ["Training plan",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Crea", "/timereport/m_gestione/training/trainingplan_create.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Schedula", "/timereport/m_gestione/training/trainingplan_schedule.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Valuta corsi", "/timereport/m_gestione/training/TrainingPlan_evaluate.aspx", , , 1

    ])

}

// solo admin e trainer hanno il menu completo
if (sUserLevel == AUTH_MANAGER ) {

    addmenu(menu = ["Training",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "Training plan", "show-menu=Training plan", , , 1
        , "Report&Download", "show-menu=Training report", , , 1
    ])

    addmenu(menu = ["Training plan",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Schedula", "/timereport/m_gestione/training/trainingplan_schedule.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Valuta corsi", "/timereport/m_gestione/training/TrainingPlan_evaluate.aspx", , , 1

    ])

    addmenu(menu = ["Amm_Economics",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/expenses.gif  border=0>&nbsp;Lista Cost Rate", "/timereport/report/rdlc/BillCostRateReport.aspx?ReportType=CR", , , 1
        , "<img src=/timereport/images/icons/16x16/expenses.gif  border=0>&nbsp;Lista Bill Rate", "/timereport/report/rdlc/BillCostRateReport.aspx?ReportType=BR", , , 1
        , "<img src=/timereport/images/icons/16x16/report.gif border=0>&nbsp;Report Revenue", "/timereport/report/EstraiRevenue/ReportRevenue.aspx", , , 1
    ])

}

addmenu(menu = ["Training report",
    , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Catalogo Corsi", "/timereport/report/Rdlc/ReportExecute.aspx?ReportName=HR_CourseCatalog", , , 1
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Training Plan", "/timereport/m_gestione/training/TrainingPlan_report.aspx", , , 1
])

	addmenu(menu = ["Amm_CutOff",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "<img src=/timereport/images/icons/16x16/cutoff.gif border=0>&nbsp;CutOff", "/timereport/m_gestione/Cutoff/cutoff.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/S_B_ACTY.gif border=0>&nbsp;Check inserimenti", "/timereport/report/checkInput/check-input-select.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/unlock.gif order=0>&nbsp;Riapri Timereport", "/timereport/report/chiusura/Amm_chiusureTR.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/giustificativi.gif border=0>&nbsp;Report giustificativi", "/timereport/report/ricevute/ricevute_select.aspx?mode=admin", , , 1
	])


if (sUserLevel == AUTH_ADMIN) {
    addmenu(menu = ["Amm_Economics",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "Master data", "show-menu=Amm_economics_masterdata", , , 1
        , "Import data", "show-menu=Amm_economics_import", , , 1
        , "<img src=/timereport/images/icons/16x16/utilita.gif border=0>&nbsp;Aggiornameni manuali", "/timereport/report/EstraiRevenue/RevenuManualAdj.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/S_B_ACTY.gif border=0>&nbsp;Calcolo Revenue", "/timereport/report/EstraiRevenue/CalcolaRevenue.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/report.gif border=0>&nbsp;Report Revenue", "/timereport/report/EstraiRevenue/ReportRevenue.aspx", , , 1
    ])
}
    

    addmenu(menu = ["Amm_economics_masterdata",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;FLC per anno", "/timereport/m_gestione/CostRateAnno/CostRateAnno_list.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Bill Rate per progetto", "/timereport/m_gestione/CostRateProgetto/CostRate_list.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/progetto.gif border=0>&nbsp;Dati progetto", "/timereport/report/EstraiRevenue/ProjectRevenueData.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/report.gif  border=0>&nbsp;Scarica FLC", "/timereport/report/rdlc/CostRateReport.aspx", , , 1
    ])

    addmenu(menu = ["Amm_economics_import",
        , , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
        , "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbsp;Import Sales Force", "/timereport/report/EstraiRevenue/SFimport_select.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbsp;Import Revenue Spese", "/timereport/report/EstraiRevenue/SpeseImport_select.aspx", , , 1
    ])

	addmenu(menu = ["Amm_MassChange",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Aggiornamento ore", "/timereport/m_gestione/mass_insert_hours.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Aggiornamento spese", "/timereport/m_gestione/mass_insert_expenses.aspx", , , 1
	])

	addmenu(menu = ["Amm_Export",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Report Straordinari", "/timereport/report/straordinari/Straordinari-select.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbsp;Progetti e risorse attive", "/timereport/report/general-download.aspx?query=SELECT+Persons.Name+AS+NomePersona,+AuthUserLevel.name,+Persons.Attivo_da,+Persons.Attivo_fino,+Projects.ProjectCode,+Projects.Name+AS+NomeProgetto,+Projects.active+FROM+ForcedAccounts+INNER+JOIN+Persons+ON+Persons.Persons_id+=+ForcedAccounts.Persons_id+INNER+JOIN+AuthUserLevel+ON+AuthUserLevel.UserLevel_id+=+persons.UserLevel_id+INNER+JOIN+Projects+ON+Projects.Projects_id=ForcedAccounts.Projects_id+WHERE+Projects.active=1+and+Persons.active=1", , , 1
	])

	addmenu(menu = ["Progetti",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	 , "Anagrafiche", "show-menu=Anagrafica_Progetti", , , 1
	, "Economics", "show-menu=Amm_Economics", , , 1
	, "Reporting", "show-menu=Report_manager", , , 1
	])

	addmenu(menu = ["Anagrafica_Progetti",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "<img src=/timereport/images/icons/16x16/progetto.jpeg border=0>&nbsp;Progetti", "/timereport/m_gestione/Project/projects_lookup_list.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/fasi.png border=0>&nbsp;Fasi", "/timereport/m_gestione/Phase/Phase_lookup_list.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/attivita.png border=0>&nbsp;Attivita", "/timereport/m_gestione/activity/activity_lookup_list.aspx", , , 1])

	addmenu(menu = ["Report_manager",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Controllo progetto (old)", "/timereport/report/controllo_progetto/ControlloProgetto-select.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Report Attivita'", "/timereport//report/attivita/ReportAttivita-select.aspx", , , 1
    ])

	addmenu(menu=["Persone",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	,"<img src=/timereport/images/icons/16x16/persone.gif border=0>&nbsp;Persone", "/timereport/m_gestione/Persone/persons_lookup_list.aspx",,,1
    , "<img src=/timereport/images/icons/16x16/lock.gif border=0>&nbsp;Forza progetti e spese", "/timereport/m_gestione/ForzaUtenti/selection-utenti.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/S_calendar.gif border=0>&nbsp;Calendari", "/timereport/m_gestione/Calendario/Calendario_list.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/S_B_ACTY.gif  border=0>&nbsp;Genera Festivi", "/timereport/m_gestione/Calendario/GeneraFestivi-select.aspx", , , 1
	])

	addmenu(menu=["Tabelle",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Autorizzazioni", "/timereport/m_gestione/AuthPermission/AuthPermission.aspx", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Contratto", "/timereport/lookup_list.aspx?TableName=TipoContratto&CheckTable=Projects&SortField=Descrizione&FieldNumber=1&init=true", , , 1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Metodo di Pagamento", "/timereport/lookup_list.aspx?TableName=MetodoPagamento&SortField=MetodoPagamento&FieldNumber=2&init=true",,,1	
    , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Termini di Pagamento", "/timereport/lookup_list.aspx?TableName=TerminiPagamento&SortField=TerminiPagamento&FieldNumber=2&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Spese", "/timereport/lookup_list.aspx?TableName=ExpenseType&SortField=ExpenseCode&FieldNumber=2&CheckTable=Expenses&init=true",,,1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Societ�", "/timereport/lookup_list.aspx?TableName=Company&SortField=Name&FieldNumber=1&CheckTable=Persons&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Ruoli", "/timereport/lookup_list.aspx?TableName=Roles&SortField=Name&FieldNumber=1&CheckTable=Persons&init=true",,,1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo progetti", "/timereport/lookup_list.aspx?TableName=ProjectType&SortField=Name&FieldNumber=1&CheckTable=Projects&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo ore", "/timereport/lookup_list.aspx?TableName=HourType&SortField=HourTypeCode&FieldNumber=2&CheckTable=Hours&init=true",,,1
	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Canali", "/timereport/lookup_list.aspx?TableName=Channels&SortField=Name&FieldNumber=1&CheckTable=Projects&init=true", , , 1
	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Messaggi", "/timereport/m_gestione/messaggi/messaggi_lookup_list.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Bonus", "/timereport/lookup_list.aspx?TableName=TipoBonus&SortField=Descrizione&FieldNumber=1&CheckTable=Expenses&init=true", , , 1
        , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Consulenza", "/timereport/lookup_list.aspx?TableName=ConsultantType&SortField=ConsultantTypeName&FieldNumber=1&CheckTable=Persons&init=true", , , 1
    ])



dumpmenus()