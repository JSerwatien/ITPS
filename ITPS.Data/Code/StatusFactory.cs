using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class StatusFactory
    {
        public static List<StatusEntity> LoadStatuses(DataTable dataTable)
        {
            List<StatusEntity> returnData = new();
            try
            {
                foreach (DataRow newRow in dataTable.Rows)
                {
                    StatusEntity newItem = new();
                    newItem.Status = newRow["Description"].ToString();
                    newItem.StatusCode = newRow["StatusCode"].ToString();
                    newItem.StatusCodeKey = Convert.ToInt32(newRow["StatusKey"]);
                    newItem.ClosedInd = newRow["ClosedInd"].ToString() == "1";
                    returnData.Add(newItem);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the statuses: " + ex.Message);
            }
        }
        public static List<StatusHistoryEntity> LoadStatusHistory(DataTable dataTable)
        {
            List<StatusHistoryEntity> returnData = new();
            try
            {
                foreach (DataRow newRow in dataTable.Rows)
                {
                    StatusHistoryEntity newItem = new();
                    newItem.OldStatus = newRow["OldStatus"].ToString();
                    newItem.NewStatus = newRow["NewStatus"].ToString();
                    newItem.DateOfStatus = Convert.ToDateTime(newRow["DateOfChange"]);
                    newItem.UpdatedBy = newRow["UpdatedBy"].ToString() ;
                    returnData.Add(newItem);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the statuses: " + ex.Message);
            }
        }
    }
}
