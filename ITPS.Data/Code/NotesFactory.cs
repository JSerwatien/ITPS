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
            DataSet ds = new();
            TicketNoteEntity returnData = new TicketNoteEntity();
            string strSQL = "EXEC dbo.Ticket_SEL";

             try
            {
                ds = DataFactory.GetDataSet(strSQL, "Notes"); //HAVE TO ENTER TABLE NAME? 
                returnData.Note = LoadNote(ds.Tables[0]);
                returnData.TicketNoteKey = LoadTicketNoteKey(ds.Tables[0]);
                returnData.CreatedDateTime = LoadCreatedDateTime(ds.Tables[0]);
                returnData.UserProfileKey = LoadUserProfileKey(ds.Tables[0]); 
                returnData.NoteEnteredBy = LoadNoteEnteredBy(ds.Tables[0]);
              }
            catch (Exception ex)
            {
                returnData.ErrorObject = ex;
            }
            return returnData;
        }

        private static string LoadNote(DataTable dataTable)
        {
            string returnData;
            try
            {
                returnData = Convert.ToString(dataTable.Rows[0]["Note"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the Note: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadTicketNoteKey(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["TicketNoteKey"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the ticket note key: " + ex.Message);
            }
            return returnData;
        }


        private static int LoadCreatedDateTime(DataTable dataTable)
        {
            DateTime returnData;
            try
            {
                returnData = Convert.ToDateTime(dataTable.Rows[0]["CreatedDateTime"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the created date time: " + ex.Message);
            }
            return returnData;
        }

        private static int UserProfileKey(DataTable dataTable)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(dataTable.Rows[0]["UserProfileKey"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the user profile key: " + ex.Message);
            }
            return returnData;
        }

        private static string LoadNoteEnteredBy(DataTable dataTable)
        {
            string returnData;
            try
            {
                returnData = Convert.ToString(dataTable.Rows[0]["NoteEnteredBy"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the note entered by: " + ex.Message);
            }
            return returnData;
        }
    }
    }
}
