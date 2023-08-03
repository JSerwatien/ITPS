using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class NotificationFactory
    {
        public static List<NotificationEntity> GetAllNotifications(int userProfileKey)
        {
            string strSQL = "EXEC dbo.Notification_GetAllNotifications " + userProfileKey;
            DataSet ds = new();
            try
            {
                ds = DataFactory.GetDataSet(strSQL, "Notifications");
                return PopulateNotifications(ds.Tables[0]);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static List<NotificationEntity> PopulateNotifications(DataTable dataTable)
        {
            List<NotificationEntity> returnData = new();
            try
            {
                foreach (DataRow newRow in dataTable.Rows)
                {
                    NotificationEntity newItem = new();
                    newItem.NotificationValue = newRow["NotificationValue"].ToString();
                    newItem.NotificationType = newRow["NotificationType"].ToString();
                    newItem.NotificationTypeCode = newRow["NotificationTypeCode"].ToString();
                    newItem.CreatedBy = newRow["CreatedBy"].ToString();
                    newItem.LastUpdatedBy = newRow["NotificationValue"].ToString();
                    newItem.CreatedDateTime = Convert.ToDateTime(newRow["CreatedDateTime"]);
                    if (newRow["LastUpdatedDateTime"] != DBNull.Value)
                    { newItem.LastUpdatedDateTime = Convert.ToDateTime(newRow["LastUpdatedDateTime"]); }
                    newItem.NotificationTypeKey = Convert.ToInt32(newRow["NotificationTypeKey"]);
                    newItem.UserProfileKey = newRow["UserProfileKey"] != DBNull.Value ? Convert.ToInt32(newRow["UserProfileKey"]) : 0;
                    newItem.NotificationTarget = newRow["UserProfileKey"] != DBNull.Value ? "Direct" : "General";
                    newItem.NotificationKey = Convert.ToInt32(newRow["NotificationKey"]);
                    newItem.ReadDateTime = newRow["ReadDateTime"] != DBNull.Value ? Convert.ToDateTime(newRow["ReadDateTime"]) : DateTime.MinValue;
                    returnData.Add(newItem);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the notifications: " + ex.Message);
            }
        }
        public static NotificationEntity UpdateNotificationToRead(NotificationEntity theNotification, int userProfileKey)
        {
            string strSQL = "EXEC dbo.Notification_MarkAsRead {0},{1}";
            try
            {
                strSQL = string.Format(strSQL, theNotification.NotificationKey, userProfileKey);
                DataFactory.GetDataSet(strSQL, "NotificationUpdate");
                return theNotification;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string AddNewNotification(int userProfileKey, int notificationTypeKey, string notificationValue, List<NotificationTypeEntity> theTypes)
        {
            string notificationTypeCode = theTypes.Where(x => x.NotificationTypeKey == notificationTypeKey).FirstOrDefault().NotificationTypeCode;
            return AddNewNotification(userProfileKey, notificationTypeCode, notificationValue);
        }

        public static string AddNewNotification(int userProfileKey, string notificationTypeCode, string notificationValue)
        {
            string strSQL = "EXEC dbo.Notification_AddNotification '{0}', {1}, '{2}'";
            DataSet ds = new DataSet();
            try
            {
                strSQL = string.Format(strSQL, notificationTypeCode.Replace("'", "''"), userProfileKey == 0 ? "NULL" : userProfileKey, notificationValue.Replace("'", "''"));
                ds = DataFactory.GetDataSet(strSQL, "NewNotification");
                return ds.Tables[0].Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                return ex.Message;
            }

        }
    }
}
