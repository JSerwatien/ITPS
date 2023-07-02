using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class FrontPageFactory
    {
        public static FrontPageDataEntity GetFrontPageData()
        {
            DataSet ds = new ();
            FrontPageDataEntity returnData = new FrontPageDataEntity();
            string strSQL = "EXEC dbo.Front_Page_Data_SEL";

            try
            {
                ds = DataFactory.GetDataSet(strSQL, "FrontPage"); //HAVE TO ENTER TABLE NAME? 
                returnData.OpenTicketsCount = LoadOpenTickets(ds.Tables[0]);
                returnData.DepartmentTicketsCount = LoadDepartmentTicketsCount(ds.Tables[0]);
                returnData.UnassignedTicketCount = LoadUnassignedTicketCount(ds.Tables[0]);
                returnData.HistoricalCountClosed = LoadHistoricalCountClosed(ds.Tables[0]); 
                returnData.HistoricalCountOpen = LoadHistoricalCountOpen(ds.Tables[0]);
                returnData.NeedingMyAttentionCount = LoadNeedingMyAttentionCount(ds.Tables[0]);
                returnData.PastDueCount = LoadPastDueCount(ds.Tables[0]); 
                returnData.ClosedVsOpen = LoadClosedVsOpen(ds.Tables[0]);
                returnData.Top10Tickets = LoadTop10Tickets(ds.Tables[1]);
                returnData.PastComingDueTickets = LoadPastDueTickets(ds.Tables[2]);
                if (ds.Tables.Count > 3) { returnData.OpenMonthlyCount = LoadOpenMonthlyCount(ds.Tables[3]); }
                if (ds.Tables.Count > 4) { returnData.ClosedMonthlyCount = LoadClosedMonthlyCount(ds.Tables[4]); }
            }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }
            return returnData;
        }

        private static int LoadOpenTickets(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["OpenCount"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the open tickets: "+ex.Message);
            }
            return returnData;
        }

        private static int LoadDepartmentTicketsCount(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["DepartmentCount"]); 
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadUnassignedTicketCount(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["UnassignedCount"]); 
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadHistoricalCountClosed(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["HistoricalClosedCount"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadHistoricalCountOpen(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["HistoricalOpenCount"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }
        private static int LoadNeedingMyAttentionCount(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["PastDue"]); 
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadPastDueCount(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["PastDue"]); 
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadClosedVsOpen(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0][/*HOW TO ACCESS FROM SP??*/""]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
            return returnData;
        }
        private static List<TicketEntity> LoadTop10Tickets(DataTable dataTable)
        {
            List<TicketEntity> returnData = new();
            try
            {
                foreach(DataRow row in dataTable.Rows)
                {
                    returnData.Add(TicketFactory.LoadSummaryTicketFromDataRow(row));
                }
                return returnData;   
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
        }
        private static List<TicketEntity> LoadPastDueTickets(DataTable dataTable)
        {
            List<TicketEntity> returnData = new();
            try
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    returnData.Add(TicketFactory.LoadSummaryTicketFromDataRow(row));
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
        }


        private static List<MonthEntity> LoadOpenMonthlyCount(DataTable dataTable)
        {
            List<MonthEntity> returnData = new();
            try
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    MonthEntity newMonth = new MonthEntity();
                    newMonth.MonthName = row["TheMonth"].ToString();
                    newMonth.Count = Convert.ToInt32(row["C"]);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
        }

        private static List<MonthEntity> LoadClosedMonthlyCount(DataTable dataTable)
        {
            List<MonthEntity> returnData = new();
            try
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    MonthEntity newMonth = new MonthEntity();
                    newMonth.MonthName = row["TheMonth"].ToString();
                    newMonth.Count = Convert.ToInt32(row["C"]);
                    returnData.Add(newMonth);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading: " + ex.Message);
            }
        }
    }
}
