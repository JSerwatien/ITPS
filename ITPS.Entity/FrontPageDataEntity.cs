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
        public int HistoricalCountClosed { get; set; }
        public int HistoricalCountOpen { get; set; }
        public int NeedingMyAttentionCount { get; set; }
        public int PastDueCount { get; set; }
        public int ClosedVsOpen { get; set; }
        public List<TicketEntity> Top10Tickets { get; set; }
        public List<TicketEntity> PastComingDueTickets { get; set; }
        public List<TicketEntity> OpenMonthlyCount { get; set; }
        public List<TicketEntity> ClosedMonthlyCount { get; set; }
        public Exception ErrorObject { get; set; }
    }
}
