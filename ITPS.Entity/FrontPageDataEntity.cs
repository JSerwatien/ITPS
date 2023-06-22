using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class FrontPageDataEntity
    {
        public int OpenTicketsCount { get; set; }
        public int DepartmentTicketsCount { get; set; }
        public int UnassignedTicketCount { get; set; }
        public int HistoricallyCountClosed { get; set; }
        public int HistoricallyCountOpen { get; set; }
        public int NeedingMyAttentionCount { get; set; }
        public int PastDueCount { get; set; }
        public int ClosedVsOpen { get; set; }
        public List<TicketEntity> Top10Tickets { get; set; }
        public List<TicketEntity> PasteDueComingDueTickets { get; set; }
    }
}
