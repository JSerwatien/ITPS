using ITPS.Entity;
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
                returnData.LastUpdatedDateTime = Convert.ToDateTime(theData["LastUpdatedDateTime"]);
                returnData.CreatedBy = theData["CreatedBy"].ToString();
                returnData.LastUpdatedBy = theData["LastUpdatedBy"].ToString();
                //NEED TO ADD THE LAST TWO COLUMNS : STATUS AND STATUS CODE HOWEVER NOT IN TICKET ENTITY
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
                returnData = LoadTicketData(ds.Tables[0]);
                returnData.NoteList = NotesFactory.LoadNotes(ds.Tables[1]);
                returnData.StatusHistory = StatusFactory.LoadStatusHistory(ds.Tables[2]);
            }
            catch (Exception ex)
            {
                returnData.ErrorObject= ex;
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
                returnData.ShortDescription = newRow["ShortDescription"].ToString();
                returnData.LongDescription = newRow["LongDescription"].ToString();
                returnData.Priority = Convert.ToInt32(newRow["Priority"]);
                returnData.StatusKey = Convert.ToInt32(newRow["StatusKey"]);
                returnData.DueDate = Convert.ToDateTime(newRow["DueDate"]);
                returnData.CreatedDateTime = Convert.ToDateTime(newRow["CreatedDateTime"]);
                returnData.LastUpdatedDateTime = Convert.ToDateTime(newRow["LastUpdatedDateTime"]);
                returnData.CreatedBy = newRow["CreatedBy"].ToString();
                returnData.LastUpdatedBy = newRow["LastUpdatedBy"].ToString();

            }
            catch (Exception ex)
            {
                returnData.ErrorObject=ex;
            }
            return returnData;
        }
    }
}
