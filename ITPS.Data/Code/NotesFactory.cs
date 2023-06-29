using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class NotesFactory
    {
        public static List<TicketNoteEntity> LoadNotes(DataTable theData)
        {
            return new List<TicketNoteEntity>();
        }
    }
}
