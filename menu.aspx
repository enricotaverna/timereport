<%@ Page Language="VB" AutoEventWireup="true" CodeFile="menu.aspx.vb" Inherits="menu" %>
<%@ Register TagPrefix="asp101" TagName="ProgressBar" Src="/timereport/include/progress.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script> 

<!-- INCLUDE JS TIMEREPORT   -->
<script src="/timereport/include/javascript/timereport.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Time Report</title>
 
		<style type="text/css">
		.style2
		{
			width: 200px;
		}
		.style4
		{
			text-align: center;
		}
			</style>

</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session("lingua")%>  UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

	<div id="TopStripe"></div> 

	<div id="MainWindow">

	<!--**** Riquadro navigazione ***-->  

	<form id="form1" runat="server">

	 <table  width="100%" style="font-size: 8pt;border-style:solid;border-size:1px" > <!--**** Tabella principale ***-->  
										
					<tr> <!--**** finestra principale ***-->  
					
						<td valign="top" class="style2"> <!--**** colonna dx ***-->  

							<%--  *** Messaggi *** --%>
							<table  class="BoxTable">
								<tr>
									<th><asp:Literal runat="server" Text="<%$ Resources:messaggi%>" /></th>
								</tr>
								<tr>
									<td class="BoxBody">
							 <table  >
								 <tr>
									 <td>
										 <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank" NavigateUrl="../public/Aeonvis  - nuove funzionalità TR - Tutti gli utilizzatori.pdf"><img alt="PPT file" src="images/icons/other/pdf.png" width="50px" /></asp:HyperLink>
										 </td>
									 <td><asp:Literal runat="server" Text="<%$ Resources:Msg_istruzioni%>" /></td>
								 </tr>
								 <tr>
									 <td>
										 <asp:ImageButton ID="BtnMobile" runat="server" ImageUrl="~/apple-touch-icon.png" Width="50px" /> 
										 </td>
									 <td><asp:Literal runat="server" Text="<%$ Resources:Msg_mobile%>" /><br />
									 </td>
								 </tr>
							</table>
										<br />
									</td>
								</tr>
							</table>
							<br />
							<%--  *** Report  *** --%>
							<table class="BoxTable">
								<tr>
									<th >Report
									</th>
								</tr>
							<tr>
							<td class="BoxBody">
								<asp:Literal runat="server" Text="<%$ Resources:mese%>" />
								 <%--<a href="menu.aspx?cursor=bk">&lt;prec</a>  --%>
									<asp:LinkButton ID="bk_button" runat="server" text ="<< " onclick="button_Click"></asp:LinkButton>
								<asp:Label ID="lMese" runat="server" Text=""></asp:Label>    
							   <%-- <a href="menu.aspx?cursor=fw">succ&gt;</a> --%>
									<asp:LinkButton ID="fw_button" runat="server" text =">> " onclick="button_Click"></asp:LinkButton><br />
								<br />
								<asp:Literal runat="server" Text="<%$ Resources:ore_lavorative%>" /><asp:Label ID="lOreLavorative" runat="server" Text=""></asp:Label><br />
								<asp:Literal runat="server" Text="<%$ Resources:ore_caricate%>" /><asp:Label ID="lContaOre" runat="server" Text=""></asp:Label>&nbsp;&nbsp;
								 <asp:Label ID="lPerc" runat="server" Text=""></asp:Label>% <br />
								<asp101:ProgressBar id="pbarIEesque" runat="server"
								Style = "IEesque"
								Width = 100 />
								<br />                                                         
								<br /><asp:Literal runat="server" Text="<%$ Resources:spese_carta_credito%>" /><asp:Label ID="lContaSpeseConCC" runat="server" Text=""></asp:Label>
								<br />
								<asp:Literal runat="server" Text="<%$ Resources:spese_da_rimborsare%>" /><asp:Label ID="lContaSpeseSenzaCC" runat="server" Text=""></asp:Label>
								<br />
								 <asp:Literal runat="server" Text="<%$ Resources:chilometri%>"></asp:Literal><asp:Label ID="lContaKm" runat="server" Text=""></asp:Label>
								<br />
								 <br />
							</td>                            
							</tr>                                                        
							</table>
							<br /> 
							<%--  *** Currency *** --%>
							<!-- Currency Converter script - fx-rate.net --> 
							<div style="width:200px; background-color:#FFFFFF;border:2px solid #888;text-align:center;margin:0px;padding:0px"> 
								<!-- EXCHANGERATES.ORG.UK EXCHANGE RATE CONVERTER START -->
								<script type="text/javascript">
									var dcf = 'EUR';
									var dct = 'USD';
									var mc = 'FFFFF';
									var mbg = 'FFFFFF';
									var f = 'arial';
									var fs = '12';
									var fc = '000000';
									var tf = 'arial';
									var ts = '14';
									var tc = '080203';
									var tz = 'userset';
								</script>
								<script type="text/javascript" src="https://www.currency.me.uk/remote/ER-ERC-1.php"></script>
								<small>Source: <a href="https://www.exchangerates.org.uk" target="_new">ExchangeRates.org.uk</a></small>
								<!-- EXCHANGERATES.ORG.UK  EXCHANGE RATE CONVERTER END -->
							</div> <!-- End of Currency Converter script -->
						
						</td> <!--**** colonna dx ***-->  
						
						<td valign="top" > <!--**** colonna sx ***-->  
						</td> <!--**** colonna sx ***-->  
					
					</tr> <!--**** finestra principale ***-->  
				
				</table>

	</form>
		
	</div> <!-- END MainWindow -->

	<!-- Per output messaggio conferma salvataggio -->
	<div id="dialog" style="display: none"></div>
	
	<!-- **** FOOTER **** -->  
	<div id="WindowFooter">       
		<div ></div>        
		<div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
		<div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
		<div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session("UserName")  %></div>        
	 </div> 

</body>

</html>