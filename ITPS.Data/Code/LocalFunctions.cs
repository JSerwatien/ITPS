using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class LocalFunctions
    {
        public static string ScrubValueForSQL(string theValue)
        {
            if (!string.IsNullOrEmpty(theValue)) { theValue = theValue.Replace("'", "''"); }
            return theValue;
        }
    }
}
