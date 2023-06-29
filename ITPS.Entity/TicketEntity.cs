using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.JavaScript;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class TicketEntity
    {
        public int TicketKey { get; set; }
        public int AssignedToUserProfileKey { get; set; }
        public int UserProfileKey { get; set; }
        public string ShortDescription { get; set; }
        public string LongDescription { get; set; }
        public int Priority { get; set; }
        public int StatusKey { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public DateTime LastUpdatedDateTime { get; set; }
        public string LastUpdatedBy { get; set; }
        public List<StatusHistoryEntity> StatusHistory { get; set; }
        public List<TicketNoteEntity> NoteList { get; set; }
        public Exception ErrorObject { get; set; }
    }
}
