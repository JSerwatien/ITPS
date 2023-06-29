using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class StatusHistoryEntity
    {
        public DateTime DateOfStatus { get; set; }
        public string  OldStatus { get; set; }
        public string NewStatus { get; set; }
        public string UpdatedBy { get; set; }
    }
}
