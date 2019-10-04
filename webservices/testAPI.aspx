<%@ Page Language="C#" %>

<!DOCTYPE html>

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/timereport/include/jquery/tooltip/jquery.smallipop.css" type="text/css" />

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server" >

        <h1>Test API gvision</h1>

        <div>

            <asp:TextBox ID="TBContent" runat="server" Rows="10" Columns="50" TextMode="MultiLine" Text=""></asp:TextBox>

            <br />
            <br />

            <asp:Button ID="BTOCR" runat="server" Text="Parse Text" />
            &nbsp;&nbsp;
            <asp:Button ID="BTImage" runat="server" Text="Scan Image" />


        </div>
    </form>
</body>


    
<script type="text/javascript">

    var currency = [{
        "symbol": "$",
        "name": "US Dollar",
        "symbol_native": "$",
        "decimal_digits": 2,
        "rounding": 0,
        "code": "USD",
        "name_plural": "US dollars"
    },
    {
        "symbol": "CA$",
        "name": "Canadian Dollar",
        "symbol_native": "$",
        "decimal_digits": 2,
        "rounding": 0,
        "code": "CAD",
        "name_plural": "Canadian dollars"
    },
    {
        "symbol": "€",
        "name": "Euro",
        "symbol_native": "€",
        "decimal_digits": 2,
        "rounding": 0,
        "code": "EUR",
        "name_plural": "euros"
    },
    
    {
        "symbol": "£",
        "name": "British Pound Sterling",
        "symbol_native": "£",
        "decimal_digits": 2,
        "rounding": 0,
        "code": "GBP",
        "name_plural": "British pounds sterling"   
   
    }
];

    $("#BTOCR").click(function (e) {

    e.preventDefault();
    var BillText = "TOTALE €\n8.10\nCONTANTI\nM.45276 OP.1\n31/07/19 09:43\n"

    var foundAmount = false;
    var arrBillData = BillText.split(/\n/);
    var dateStr;
    var lvalue;

    // Check for Date and Total Amount
    //yyyy-mm-dd hh:mm
    //var date1 = /^([12]\d{3}[-/.](0[1-9]|1[0-2])[-/.](0[1-9]|[12]\d|3[01])) (2[0-3]|[01][0-9]):[0-5][0-9]$/;

     //dd-mm-yyyy
    //var date1 = /^((0[1-9]|[12]\d|3[01])[-/.](0[1-9]|1[0-2])[-/.][12]\d{3})/;

    //dd-mm-yyyy (hh:mm)
    var date1 = /^((0[1-9]|[12]\d|3[01])[-\/.](0[1-9]|1[0-2])[-\/.][12]\d{3})(\s(2[0-3]|[01][0-9]):[0-5][0-9])?$/;

    //dd-mm-yy (hh:mm)
    var date2 = /^((0[1-9]|[12]\d|3[01])[-/.](0[1-9]|1[0-2])[-/.][12]\d{1}) ((2[0-3]|[01][0-9]):[0-5][0-9])?$/;

    // Loop through all Text
    for (i = 0; i < arrBillData.length; i++) {
        let value = arrBillData[i];

        // Date
        if (date1.test(value) || date2.test(value)) {
            console.log(value);

            if (date1.test(value)) {
                //dd-mm-yyyy
                dateStr = value.substr(6,4) + value.substr(3,2) + value.substr(0,2);
               //inReceiptDate.setValue(dateStr);
            }

            if (date2.test(value)) {
                //dd-mm-yy
                dateStr = dateStr = '20' + value.substr(6,2) + value.substr(3,2) + value.substr(0,2);
                //inReceiptDate.setValue(dateStr);
            }
        }

        // Amount

        ccodeShort = "EUR";
        ccodeLong = "EURO";
        ccode = "€";

        if (value.includes(ccode)) {

            //inReceiptCurrency.setSelectedKey(ccodeShort); // almeno imposta la valuta

            // cerca NNNN,nn€ o NNN,nn €
            var amnt1 = /\d+[,.]\d{2}\s*€/;
            if (amnt1.test(value)) {
                        console.log("VERIFICATO: " + value);
                        lvalue = value;
                        lvalue = lvalue.replace(/\s/g, ''); // rimuove spazi
                        lvalue = lvalue.substring(0, lvalue.length - 1); // estrae il numero
                        //inReceiptAmount.setValue(lvalue);
                        foundAmount = true;
                        break;
            }

            // cerca il simbolo Eur o € a  fine stringa e prende il campo
            // dopo se è un numero
            var symb = /[€,EUR,EURO]$/;   // EUR, EURO o € a fine stringa
            var amnt2 = /\d+[,.]\d{2}$/;  // numero a due cifre
            if (symb.test(value) &  amnt2.test(arrBillData[i+1])) {
                        console.log("VERIFICATO-1: " + value + " " + arrBillData[i+1]);
                        lvalue = arrBillData[i+1];
                        lvalue = lvalue.replace(/\s/g, ''); // rimuove spazi
                        lvalue = lvalue.replace('.',','); // punto con virgola
                        //inReceiptAmount.setValue(lvalue);
                        foundAmount = true;
                break;
            }

            }
        }

    // Get Shop Name
    inReceiptInfo.setValue(arrBillData[0] + '-' + arrBillData[1]);

    });


</script>


</html>
