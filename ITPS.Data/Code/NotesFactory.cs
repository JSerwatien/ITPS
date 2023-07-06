using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class NotesFactory
    {
        public static List<TicketNoteEntity> LoadNotes(DataTable theData)
        {
            DataSet ds = new();
            List<TicketNoteEntity> returnData = new();

            try
            {
                foreach(DataRow newRow in theData.Rows)
                {
                    TicketNoteEntity newItem = new();
                    newItem.TicketNoteKey = LoadTicketNoteKey(newRow);
                    newItem.CreatedDateTime = LoadCreatedDateTime(newRow);
                    newItem.NoteEnteredBy = LoadNoteEnteredBy(newRow);
                    newItem.Note = newRow["Note"].ToString();
                    returnData.Add(newItem);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return returnData;
        }

        private static string LoadNote(DataTable dataTable)
        {
            string returnData;
            try
            {
                returnData = dataTable.Rows[0]["Note"].ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the Note: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadTicketNoteKey(DataRow newRow)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(newRow["NoteKey"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the ticket note key: " + ex.Message);
            }
            return returnData;
        }


        private static DateTime LoadCreatedDateTime(DataRow newRow)
        {
            DateTime returnData;
            try
            {
                returnData = Convert.ToDateTime(newRow["CreatedDateTime"]);//can u convert to datetime this way
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the created date time: " + ex.Message);
            }
            return returnData;
        }

        private static int LoadUserProfileKey(DataRow newRow)
        {
            int returnData;
            try
            {
                returnData = Convert.ToInt32(newRow["UserProfileKey"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the user profile key: " + ex.Message);
            }
            return returnData;
        }

        private static string LoadNoteEnteredBy(DataRow newRow)
        {
            string returnData;
            try
            {
                returnData = Convert.ToString(newRow["CreatedBy"]);
            }
            catch (Exception ex)
            {
                throw new Exception("Error loading the note entered by: " + ex.Message);
            }
            return returnData;
        }
        public static int SaveNote(TicketNoteEntity theNote)
        {
            DataSet ds = new();
            string strSQL = "EXEC dbo.TicketNote_INS '{0}', '{1}', {2}";
            try
            {
                strSQL = string.Format(strSQL, theNote.Note.Replace("'", "''"), theNote.NoteEnteredBy, theNote.TicketKey);
                ds = DataFactory.GetDataSet(strSQL, "NewNote");
                return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
