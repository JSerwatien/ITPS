using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class OverviewReportEntity
    {
        public List<TicketEntity> DetailData { get; set; }
        public DataSet RawData { get;set;}
        public List<OverviewChartEntity> AssignedToData { get; set; }
        public List <OverviewChartEntity> StatusData { get; set; }
        public Exception ErrorObject { get; set; }
    }
    public class OverviewChartEntity
    {
        public int TableKey { get; set; }
        public string DisplayValue { get; set; }
        public int DataCount { get; set; }
    }
}
