//****************************************************************/

// DEFINE VARIABLES

// whitespace characters
var whitespace = " \t\n\r";

// Check whether string s is empty.

function IsEmpty(s)
{   return ((s == null) || (s.length == 0));
}


//****************************************************************/
function IsNumeric(objValue)
   //  check for valid numeric strings	
   {
   var strValidChars = "0123456789,";
   var strChar;
   var blnResult = true;

   objValue.value = objValue.value + '';
   
// if (strString.length == 0) return false;

   //  test strString consists of valid characters listed above
   for (i = 0; i < objValue.value.length && blnResult == true; i++)
      {
      strChar = objValue.value.charAt(i);
      if (strValidChars.indexOf(strChar) == -1)
         {
         blnResult = false;
         alert(objValue.value + ' non è  un valore numerico. Verificare inserimento.' );
         objValue.focus();
         objValue.select();
         }
      }
   return blnResult;
   }

/****************************************************************/

// Returns true if string s is empty or 
// whitespace characters only.

function IsWhitespace (s)

{   var i;
	
    // Is s empty?
    if (IsEmpty(s)) return true;

    // Search through string's characters one by one
    // until we find a non-whitespace character.
    // When we do, return false; if we don't, return true.

    for (i = 0; i < s.length; i++)
    {   
	// Check that current character isn't whitespace.
	var c = s.charAt(i);

	if (whitespace.indexOf(c) == -1) return false;
    }

    // All characters are whitespace.
    return true;
}

/****************************************************************/

// Checks to see if a required field is blank.  If it is, a warning
// message is displayed...

function ForceEntry(objField, FieldName)
{
			
	var strField = new String(objField.value);
		
	if (IsWhitespace(strField)) {
		alert("Il campo '" + FieldName + "' non è stato compilato, inserire un valore prima di premere il tasto registra.");
		objField.focus();
		objField.select();
		return false;
	}

	return true;
}

/****************************************************************/


function CheckDecimals(objToCheck, maxSinistra, maxDestra) 
{
	var exptocheck;
	exptocheck = new RegExp("\^\\d{0,"+maxSinistra+"}(\\,\\d{0,"+maxDestra+"})?\$");	

	if ( !exptocheck.test(objToCheck.value) ) {
		alert(objToCheck.value + ' non è nel formato corretto. Verificare lunghezza campo e numero di decimali.' );
		objToCheck.focus();
		objToCheck.select();
		return false;						
	}		
	else
		return true;	
}