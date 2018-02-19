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

// Legge livello autorizzazioni da file chiamante
var sUserLevel = AUTH_EXTERNAL;
if (document.getElementById("IncludeMenu") != null) {
    sUserLevel = document.getElementById("IncludeMenu").getAttribute("UserLevel");
    sLingua = document.getElementById("IncludeMenu").getAttribute("lingua");

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
,"Logout&nbsp;&nbsp;","/timereport/logout.asp",,"",1
])

    // cancella menu progetti (Manager)
if (sUserLevel == AUTH_EMPLOYEE | sUserLevel == AUTH_EXTERNAL | sUserLevel == AUTH_TEAMLEADER)
        menu.splice(42, 10);

    // cancella menu Amministrazione
    if (sUserLevel == AUTH_MANAGER )
        menu.splice(47, 5);

	addmenu(menu=["Spese",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	,"<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Spese personali", "/timereport/report/report-spese-dettaglio.asp",,,1
	,"<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Riepilogo tipo spesa", "/timereport/report/report-spese-01.asp",,,1
	])	
    
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
        , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Controllo progetto", "/timereport/report/controllo_progetto/ControlloProgetto-select.aspx", , , 1
	    ])	

	if (sUserLevel == AUTH_EXTERNAL)
	    addmenu(menu=["Inserisci",
	    ,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	    , (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Ore" : "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Hours", "/timereport/input.aspx?type=hours", , , 1
	    , (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Spese" : "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Expenses", "/timereport/input.aspx?type=expenses", , , 1
        , (sLingua == 'it') ? "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbspUpload spese" : "<img src=/timereport/images/icons/16x16/export.gif border=0>&nbspUpload expenses", "/timereport/m_utilita/upload-expenses-xls.aspx", , , 1
	    ])
	else
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
	
	addmenu(menu = ["Amm_CutOff",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "<img src=/timereport/images/icons/16x16/cutoff.gif border=0>&nbsp;CutOff", "/timereport/cutoff.asp", , , 1
	, "<img src=/timereport/images/icons/16x16/S_B_ACTY.gif border=0>&nbsp;Check inserimenti", "/timereport/report/checkInput/check-input-select.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/unlock.gif order=0>&nbsp;Riapri Timereport", "/timereport/report/chiusura/Amm_chiusureTR.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/giustificativi.gif border=0>&nbsp;Report giustificativi", "/timereport/report/ricevute/ricevute_select.aspx?mode=admin", , , 1
	])

	addmenu(menu = ["Amm_Economics",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "<img src=/timereport/images/icons/16x16/S_calendar.gif border=0>&nbsp;Cost rate per anno", "/timereport/m_gestione/CostRateAnno/CostRateAnno_list.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/progetto.gif border=0>&nbsp;Cost rate per progetto", "/timereport/m_gestione/CostRateProgetto/CostRate_list.aspx", , , 1
	])

	addmenu(menu = ["Amm_MassChange",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
	, "<img src=/timereport/images/icons/16x16/hours.gif border=0>&nbsp;Aggiornamento ore", "/timereport/m_gestione/mass_insert_hours.aspx", , , 1
	, "<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Aggiornamento spese", "/timereport/m_gestione/mass_insert_expenses.aspx", , , 1
	])

	addmenu(menu = ["Amm_Export",
	, , 180, 1, "", style1, , "", effect, , , , , , , , , , , ,
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Report Revenue", "/timereport/report/EstraiRevenue/EstraiRevenue-select.aspx", , , 1
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
    , "<img src=/timereport/images/icons/16x16/S_PROTOK.gif border=0>&nbsp;Controllo progetto", "/timereport/report/controllo_progetto/ControlloProgetto-select.aspx", , , 1
	])

	addmenu(menu=["Persone",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
	,"<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Crea Profili Spese", "/timereport/lookup_list.asp?TableName=ExpensesProfile&SortField=Name&FieldNumber=1&CheckTable=ForcedExpensesProf&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/expenses.gif border=0>&nbsp;Associa spese a profili", "/timereport/m_gestione/selection-profilo.asp",,,1	
    ,"<img src=/timereport/images/icons/16x16/persone.gif border=0>&nbsp;Persone", "/timereport/m_gestione/Persone/persons_lookup_list.aspx",,,1
	,"<img src=/timereport/images/icons/16x16/lock.gif border=0>&nbsp;Forza progetti e spese", "/timereport/m_gestione/ForzaUtenti/selection-utenti.aspx",,,1
	])

	addmenu(menu=["Tabelle",
	,,180,1,"",style1,,"",effect,,,,,,,,,,,,
    , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Autorizzazioni", "/timereport/m_gestione/AuthPermission/AuthPermission.aspx", , , 1
    , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Contratto", "/timereport/lookup_list.asp?TableName=TipoContratto&SortField=Descrizione&FieldNumber=1&init=true", , , 1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Metodo di Pagamento", "/timereport/lookup_list.asp?TableName=MetodoPagamento&SortField=MetodoPagamento&FieldNumber=1&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Termini di Pagamento", "/timereport/lookup_list.asp?TableName=TerminiPagamento&SortField=TerminiPagamento&FieldNumber=1&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Spese", "/timereport/lookup_list.asp?TableName=ExpenseType&SortField=ExpenseCode&FieldNumber=2&CheckTable=Expenses&init=true",,,1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Giorni non lavorativi", "/timereport/lookup_list.asp?TableName=Holiday&SortField=Holiday_date&FieldNumber=1&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Società", "/timereport/lookup_list.asp?TableName=Company&SortField=Name&FieldNumber=1&CheckTable=Persons_Projects&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Ruoli", "/timereport/lookup_list.asp?TableName=Roles&SortField=Name&FieldNumber=1&CheckTable=Persons&init=true",,,1
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo progetti", "/timereport/lookup_list.asp?TableName=ProjectType&SortField=Name&FieldNumber=1&CheckTable=Projects&init=true",,,1	
	,"<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo ore", "/timereport/lookup_list.asp?TableName=HourType&SortField=HourTypeCode&FieldNumber=2&CheckTable=Hours&init=true",,,1
	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Canali", "/timereport/lookup_list.asp?TableName=Channels&SortField=Name&FieldNumber=1&CheckTable=Projects&init=true", , , 1
    , "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Messaggi", "/timereport/m_gestione/messaggi/messaggi_lookup_list.aspx", , , 1
   	, "<img src=/timereport/images/icons/16x16/modifica.gif border=0>&nbsp;Tipo Bonus", "/timereport/lookup_list.asp?TableName=TipoBonus&SortField=Descrizione&FieldNumber=1&CheckTable=Expenses&init=true", , , 1
])



dumpmenus()