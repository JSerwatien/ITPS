using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class TicketNoteEntity
    {
        public string Note { get; set; }
        public int TicketNoteKey { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int UserProfileKey { get; set; }
        public string NoteEnteredBy { get; set; }
        public int TicketKey { get; set; }
    }
}
