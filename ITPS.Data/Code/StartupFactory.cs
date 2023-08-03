using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class StartupFactory
    {
        public static StartUpObjectEntity GetStartUpData()
        {
            DataSet ds = new();
            StartUpObjectEntity returnData = new();
            string strSQL = "EXEC dbo.GetStartUpData";

            try
            {
                ds = DataFactory.GetDataSet(strSQL, "StartUpData");
                returnData.Statuses = StatusFactory.LoadStatuses(ds.Tables[0]);
                returnData.Departments = LoadDepartments(ds.Tables[1]);
                returnData.Users = LoadUsers(ds.Tables[2]);
                returnData.NotificationTypes = LoadNotificationTypes(ds.Tables[3]);
            }
            catch (Exception ex)
            {
                returnData.ErrorObject=ex;
            }
            return returnData;
        }

        private static List<NotificationTypeEntity> LoadNotificationTypes(DataTable dataTable)
        {
            List<NotificationTypeEntity> returnData = new();

            foreach(DataRow newRow in dataTable.Rows)
            {
                NotificationTypeEntity newItem = new();
                newItem.NotificationTypeKey = Convert.ToInt32(newRow["NotificationTypeKey"]);
                newItem.NotificationTypeCode = newRow["NotificationTypeCode"].ToString();
                newItem.Description = newRow["Description"].ToString();
                returnData.Add(newItem);
            }
            return returnData;
        }

        private static List<UserEntity> LoadUsers(DataTable dataTable)
        {
            List<UserEntity> returnData = new();
            try
            {
                foreach (DataRow newRow in dataTable.Rows)
                {
                    UserEntity newItem = new();
                    newItem.FirstName = newRow["FirstName"].ToString();
                    newItem.LastName = newRow["LastName"].ToString();
                    newItem.DisplayName = newItem.FirstName + " " + newItem.LastName;
                    newItem.UserName = newRow["UserName"].ToString();
                    newItem.Password = newRow["Password"].ToString();
                    newItem.EmailAddress = newRow["EmailAddress"].ToString();
                    newItem.PhoneNumber = newRow["PhoneNumber"].ToString();
                    newItem.DepartmentKey = Convert.ToInt32(newRow["DepartmentKey"]);
                    newItem.UserProfileKey = Convert.ToInt32(newRow["UserProfileKey"]);
                    newItem.ActiveInd = newRow["ActiveInd"].ToString() == "1";
                    newItem.Department = newRow["Department"].ToString();
                    newItem.DepartmentCode = newRow["DepartmentCode"].ToString();
                    returnData.Add(newItem);
                }
                returnData.Add(new UserEntity() { FirstName = "Everyone", DisplayName = "Everyone" });
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the users: " + ex.Message);
            }
        }

        private static List<DepartmentEntity> LoadDepartments(DataTable dataTable)
        {
            List<DepartmentEntity> returnData = new();
            try
            {
                foreach (DataRow newRow in dataTable.Rows)
                {
                    DepartmentEntity newItem = new();
                    newItem.Description = newRow["Department"].ToString();
                    newItem.Code = newRow["DepartmentCode"].ToString();
                    newItem.DepartmentKey = Convert.ToInt32(newRow["DepartmentKey"]);
                    newItem.ActiveInd = newRow["ActiveInd"].ToString() == "1";
                    returnData.Add(newItem);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the departments: " + ex.Message);
            }
        }


    }
}
