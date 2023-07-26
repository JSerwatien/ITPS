using ITPS.Entity;
using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace ITPS.Data.Code
{
    public class TicketFactory
    {
        public static TicketEntity LoadSummaryTicketFromDataRow(DataRow theData)
        {
            TicketEntity returnData = new TicketEntity();
            try
            {
                returnData.TicketKey = Convert.ToInt32(theData["Ticketkey"]);
                returnData.AssignedToUserProfileKey = Convert.ToInt32(theData["AssignedToUserProfileKey"]);
                returnData.ShortDescription = theData["ShortDescription"].ToString();
                returnData.LongDescription = theData["LongDescription"].ToString();
                returnData.Priority = Convert.ToInt32(theData["Priority"]);
                returnData.StatusKey = Convert.ToInt32(theData["StatusKey"]);
                returnData.DueDate = Convert.ToDateTime(theData["DueDate"]);
                returnData.CreatedDateTime = Convert.ToDateTime(theData["CreatedDateTime"]);
                if (theData["LastUpdatedDateTime"] != DBNull.Value)
                { returnData.LastUpdatedDateTime = Convert.ToDateTime(theData["LastUpdatedDateTime"]); }
                returnData.CreatedBy = theData["CreatedBy"].ToString();
                returnData.LastUpdatedBy = theData["LastUpdatedBy"].ToString();
                returnData.Status = theData["Status"].ToString();
                if (theData.Table.Columns.Contains("AssignedToFirstName"))
                {
                    returnData.AssignedToDisplayName = theData["AssignedToFirstName"].ToString() + " " + theData["AssignedToLastName"].ToString();
                }
                if (theData.Table.Columns.Contains("AssignedToDisplayName"))
                {
                    returnData.AssignedToDisplayName = theData["AssignedToDisplayName"].ToString();
                }
                if (theData.Table.Columns.Contains("StatusCode"))
                { returnData.StatusCode = theData["StatusCode"].ToString();}
                if (theData.Table.Columns.Contains("TicketOwnerDisplayName"))
                {
                    returnData.TicketOwnerDisplayName = theData["TicketOwnerDisplayName"].ToString();
                }
                if (theData.Table.Columns.Contains("ClosedInd"))
                { returnData.StatusIsClosed = theData["ClosedInd"].ToString() == "1"; }
            }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }

            return returnData;
        }
        public static TicketEntity LoadTicket(int ticketKey)
        {
            TicketEntity returnData = new();
            string strSQL = "EXEC dbo.Ticket_SEL " + ticketKey;
            DataSet ds = new();
            try
            {
                ds = DataFactory.GetDataSet(strSQL, "TicketData");
                if (ds.Tables[0].Rows.Count == 0)
                { returnData.ErrorObject = new Exception("No ticket was found for ticket ID " + ticketKey); }
                else
                {
                    returnData = LoadTicketData(ds.Tables[0]);
                    returnData.NoteList = NotesFactory.LoadNotes(ds.Tables[1]);
                    returnData.StatusHistory = StatusFactory.LoadStatusHistory(ds.Tables[2]);
                }
            }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }
            return returnData;
        }

        private static TicketEntity LoadTicketData(DataTable dataTable)
        {
            TicketEntity returnData = new();
            try
            {
                DataRow newRow = dataTable.Rows[0];
                returnData.TicketKey = Convert.ToInt32(newRow["TicketKey"]);
                returnData.UserProfileKey = Convert.ToInt32(newRow["UserProfileKey"]);
                returnData.AssignedToUserProfileKey = Convert.ToInt32(newRow["AssignedToUserProfileKey"]);
                returnData.PreviousAssignedToUserProfileKey = Convert.ToInt32(newRow["AssignedToUserProfileKey"]);
                returnData.ShortDescription = newRow["ShortDescription"].ToString();
                returnData.LongDescription = newRow["LongDescription"].ToString();
                returnData.Priority = Convert.ToInt32(newRow["Priority"]);
                returnData.StatusKey = Convert.ToInt32(newRow["StatusKey"]);
                returnData.PreviousStatusKey = Convert.ToInt32(newRow["StatusKey"]);
                returnData.DueDate = Convert.ToDateTime(newRow["DueDate"]);
                returnData.CreatedDateTime = Convert.ToDateTime(newRow["CreatedDateTime"]);
                if (newRow["LastUpdatedDateTime"] != System.DBNull.Value) { returnData.LastUpdatedDateTime = Convert.ToDateTime(newRow["LastUpdatedDateTime"]); }
                returnData.CreatedBy = newRow["CreatedBy"].ToString();
                returnData.LastUpdatedBy = newRow["LastUpdatedBy"].ToString();

            }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }
            return returnData;
        }
        public static TicketEntity SaveTicket(TicketEntity theTicket, UserEntity currentUser)
        {
            DataSet ds = new();
            string strSQL = GetSaveSQL(theTicket, currentUser);
            try
            {
                ds = DataFactory.GetDataSet(strSQL, "SaveTicket");
                theTicket.TicketKey = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                if (theTicket.PreviousAssignedToUserProfileKey != theTicket.AssignedToUserProfileKey)
                { NotifyAssignee(theTicket); }
                if (theTicket.PreviousStatusKey != theTicket.StatusKey)
                { NotifyOwnerOfStatusChange(theTicket, currentUser.StartupObjects.Statuses); }
                theTicket.PreviousAssignedToUserProfileKey = theTicket.AssignedToUserProfileKey;
                theTicket.PreviousStatusKey = theTicket.StatusKey;
                theTicket = LoadTicket(theTicket.TicketKey);
            }
            catch (Exception ex)
            {
                theTicket.ErrorObject = ex;
            }
            return theTicket;
        }

        private static void NotifyOwnerOfStatusChange(TicketEntity theTicket, List<StatusEntity> statusList)
        {
            var currentStatus = statusList.Where(x => x.StatusCodeKey == theTicket.StatusKey).FirstOrDefault();
            var previousStatus = statusList.Where(x => x.StatusCodeKey == theTicket.PreviousStatusKey).FirstOrDefault();
            try
            {
                NotificationFactory.AddNewNotification(theTicket.UserProfileKey, Constants.NotificationType_Alert, "Ticket #<a href='/ticket/" + theTicket.TicketKey + "'>" + theTicket.TicketKey + "</a> had a status change from " + previousStatus.Status + " to " + currentStatus.Status);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static void NotifyAssignee(TicketEntity theTicket)
        {
            try
            {
                NotificationFactory.AddNewNotification(theTicket.AssignedToUserProfileKey, Constants.NotificationType_Alert, "Ticket #<a href='/ticket/" + theTicket.TicketKey + "'>" + theTicket.TicketKey + "</a> has been assigned to you.");
                if (theTicket.PreviousAssignedToUserProfileKey > 0) { NotificationFactory.AddNewNotification(theTicket.PreviousAssignedToUserProfileKey, Constants.NotificationType_Alert, "Ticket #<a href='/ticket/" + theTicket.TicketKey + "'>" + theTicket.TicketKey + "</a> has been re-assigned to someone else."); }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string GetSaveSQL(TicketEntity theTicket, UserEntity currentUser)
        {
            string returnData = "EXEC dbo.Ticket_UPTINS {0}, {1},{2},'{3}', '{4}', {5},{6},'{7}', '{8}'";
            var openStatus = currentUser.StartupObjects.Statuses.Where(x => x.StatusCode == "OPEN").FirstOrDefault();
            returnData = string.Format(returnData, theTicket.TicketKey, theTicket.UserProfileKey == 0 ? currentUser.UserProfileKey : theTicket.UserProfileKey,
                    theTicket.AssignedToUserProfileKey, theTicket.ShortDescription.Replace("'", "''"), theTicket.LongDescription.Replace("'", "''"),
                    theTicket.Priority, theTicket.StatusKey == 0 ? openStatus.StatusCodeKey : theTicket.StatusKey, theTicket.DueDate, currentUser.UserName);
            return returnData;
        }
        public static List<TicketEntity> GetReportData()
        {
            List<TicketEntity> returnData = new();
            string strSQL = "EXEC dbo.GetReportingData";
            DataSet ds = new();
            try
            {
                ds = DataFactory.GetDataSet(strSQL, "TicketReport");
                foreach(DataRow newRow in ds.Tables[0].Rows)
                {
                    returnData.Add(LoadSummaryTicketFromDataRow(newRow));
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnData;
        }

        public static List<int> GetTicketByDescription(string desc)
        {
            List<int> returnData = new();
            string strSQL = "exec dbo.Ticket_SELKeyByDescription '{0}'";
            DataSet ds = new();
            try
            {
                strSQL = string.Format(strSQL, desc.Replace("'", "''"));
                ds = DataFactory.GetDataSet(strSQL, "tableKeys");
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    returnData.Add(Convert.ToInt32(dr["TicketKey"]));
                }
                return returnData;
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
        public static List<TicketEntity> GetScheduleData()
        {
            List<TicketEntity> returnData = new();
            string strSQL = "EXEC dbo.Ticket_SELDueDate";
            DataSet ds = new();
            try
            {
                ds = DataFactory.GetDataSet(strSQL, "TicketDueDate");
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    TicketEntity newItem = new();
                    newItem.DueDate = Convert.ToDateTime(row["DueDate"]);
                    newItem.ShortDescription = row["ShortDescription"].ToString();
                    newItem.TicketKey = Convert.ToInt32(row["TicketKey"]);
                    returnData.Add(newItem);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnData;
        }
        public static void RemoveNote(int noteKey)
        {
            string strSQL = "EXEC dbo.Note_UPTActiveInd {0},{1}";
            try
            {
                strSQL = string.Format(strSQL, noteKey, 0);
                DataFactory.GetDataSet(strSQL, "RemoveNote");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static OverviewReportEntity GetOverviewReportData()
        {
            OverviewReportEntity returnData = new();
            string strSQL = "EXEC dbo.GetOverviewReportData";
            try
            {
                returnData.DetailData = new();
                returnData.RawData = DataFactory.GetDataSet(strSQL, "OverviewData");
                foreach(DataRow newRow in returnData.RawData.Tables[2].Rows)
                { returnData.DetailData.Add(LoadSummaryTicketFromDataRow(newRow)); }
                returnData.AssignedToData = LoadOverviewChartList(returnData.RawData.Tables[0]);
                returnData.StatusData = LoadOverviewChartList(returnData.RawData.Tables[1]);
            }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }
            return returnData;
        }

        private static List<OverviewChartEntity> LoadOverviewChartList(DataTable dataTable)
        {
            List<OverviewChartEntity> returnData = new();
            OverviewChartEntity newItem;
            foreach (DataRow newRow in dataTable.Rows)
            {
                newItem = new();
                newItem.TableKey = Convert.ToInt32(newRow[0]);
                newItem.DisplayValue = newRow[1].ToString();
                newItem.DataCount = Convert.ToInt32(newRow[2]);
                returnData.Add(newItem);
            }
            //Add Show All item
            newItem = new();
            newItem.TableKey = -1;
            newItem.DisplayValue = "Show All";
            newItem.DataCount = returnData.Sum(x => x.DataCount);
            returnData.Add(newItem);
            return returnData;
        }
    }
}
