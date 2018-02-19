<%@ LANGUAGE=VBSCRIPT %>
<%Option Explicit%>

<%
	Dim sColorMain, sColorBack

	 Select Case session("ColorScheme")
			case 1
				sColorMain = "#CCCC99"
				sColorBack = " #D4D4D4"
			case 2
				sColorMain = "#FF9900"
				sColorBack = " #D4D4D4"
			case 3
				sColorMain = "#CCCC33"
				sColorBack = "#E2FFC6"
			case 4
				sColorMain = "#66CCCC"
				sColorBack = " #CCFFCC"
			case 5
				sColorMain = "#CC99FF"
				sColorBack = " #F0F0F0"
		    case 6
				sColorMain = "#FFCC33"
				sColorBack = " #FFFF99"		
	end select

%>

BODY{
	font-family : Arial, Helvetica, sans-serif;
	background-color : White;
	color : Black;
	font-size : 11px;
	margin : 0px;
}

.ItemSelected {
	font-family : Arial, Helvetica, sans-serif;
	color : Black;
	background-color : <%= sColorMain %>;	
	font-size : 11px;
}

.FormButtont {
	background-color : Silver;
	border : 1px solid Black;
	color : #000000;
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;
	padding-left : 5px;
	padding-right : 5px;
	font-weight : bold;
}

.FormInput {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
	background-color : White;
	border : 1px solid Black;
	color : #000000;
	padding-left : 4px;
}

.FormInputDisabled {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
	background-color : #EFEDDE;
	border : 1px solid Black;
	color : #000000;
	padding-left : 4px;
}

.BoxDialogo {
	border : 1 solid Black;
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;
}

.BoxDialogo TD { /* used for input */
	background-color : <%= sColorBack %>;
	padding-left : 5px;
	padding-right : 5px;
}	

.BoxDialogo TH {
	font-weight : bold;
	background-color : <%= sColorMain %>;
	text-align : left;
	color : #666666;
	padding-bottom : 2px;
	padding-left : 5px;
	padding-right : 5px;
	padding-top : 2px;
	border-bottom : 1 solid Black;
}

.TabellaForm {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
	border : 1 solid Black;
}

.TabellaForm TD { /* used for input */
	background-color : <%= sColorBack %>;
	padding: 2px 5px 2px 5px;
}	

.TabellaForm TH {
	font-weight : bold;
	background-color : <%= sColorMain %>;
	color : #666666;
	padding-bottom : 2px;
	padding-left : 5px;
	padding-right : 20px;
	padding-top : 2px;
	text-align : left;
}

.BarraTop { /* used for input */
	background-color :<%= sColorMain %>;
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
	padding-right : 10px;
}	

.TabellaLista {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
}

.TabellaLista TD { /* used for input */
	background-color : <%= sColorBack %>;
	padding: 2px 5px 2px 5px;
}	

.TabellaLista TH {
	font-weight : bold;
	background-color : <%= sColorMain %>;
	color : #666666;
	padding-left : 5px;
	padding-right : 5px;
	text-align : left;
}

.TabellaReport{
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;
}

.TabellaReport TD {
	background-color : #FFFFFF;
	padding: 2px 5px 2px 5px;
	border: 1pt solid;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	vertical-align: top;
}	

.TabellaReport TH {
	font-weight : bold;
	color : #000000;
	padding-left : 5px;
	padding-right : 5px;
	border: medium solid;
}

.WorkDays {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;	
	background-color : <%= sColorBack %>;
	color : #666666;
	padding-left : 5px;
	padding-right : 5px;
	font-weight : bold;
}

.TabellaBianca {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;
}

.Riquadro{
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;	
	border : 1 solid Black;
	padding: 5px;
}

A {
	color : #666666;
}

A:visited {
	color : #666666;
}

.hours {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;	
	padding-left : 5px;
	padding-right : 5px;
	vertical-align : top;
}

.hours A {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;	
	padding-left : 5px;
	padding-right : 5px;
	font-weight : bold;
}

.HoliDays {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 11px;	
	background-color : <%= sColorMain %>;
	color : #666666;
	padding-left : 5px;
	padding-right : 5px;
	font-weight : bold;
}

B {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;	
	color : #666666;
	font-weight : bold;
}

.TabellaHome {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;
	background-color: <%= sColorBack %>;
	border: thin dashed #666666;
	height: 200px;
	padding: 10px;
	width: 300px;
	vertical-align: top;
}

.TabellaHome TH {
	font-family : Arial, Helvetica, sans-serif;
	font-size : 12px;
	font-weight: bold;
}
