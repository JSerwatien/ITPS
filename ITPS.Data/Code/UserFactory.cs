﻿using ITPS.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class UserFactory
    {
        public static UserEntity GetUserInformation(string userName, string passWord)
        {
            string strSQL = "EXEC dbo.User_SEL '{0}'";
            DataSet ds = new();
            UserEntity returnData = new();
            try
            {
                strSQL = string.Format(strSQL, LocalFunctions.ScrubValueForSQL(userName));
                ds = DataFactory.GetDataSet(strSQL, "UserInformation");
                returnData.UserName = userName;
                returnData.Password = passWord;
                returnData = PopulateUserInformation(ds, returnData);
                returnData.StartupObjects = StartupFactory.GetStartUpData();
            }
            catch (Exception ex)
            {
                returnData.ErrorMessage = ex.Message;
            }
            return returnData;
        }

        private static UserEntity PopulateUserInformation(DataSet ds, UserEntity returnData)
        {
            returnData = ValidateUser(ds, returnData);
            if(string.IsNullOrEmpty(returnData.ErrorMessage))
            {
                returnData = LoadSingleUser(ds.Tables[0].Rows[0], returnData);
                returnData = PopulateNotifications(returnData, ds.Tables[1]);
            }

            return returnData;
        }

        private static UserEntity PopulateNotifications(UserEntity returnData, DataTable dataTable)
        {
            try
            {
                returnData.NotificationList = new();
                foreach(DataRow newRow in dataTable.Rows)
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
                    newItem.UserProfileKey = newRow["UserProfileKey"]!=DBNull.Value ? Convert.ToInt32(newRow["UserProfileKey"]) : 0;
                    newItem.NotificationKey = Convert.ToInt32(newRow["NotificationKey"]);
                    returnData.NotificationList.Add(newItem);
                }
                return returnData;
            }
            catch (Exception ex)
            {
                throw new Exception("There was an error loading the notifications: " + ex.Message);
            }
        }

        private static UserEntity ValidateUser(DataSet ds, UserEntity returnData)
        {
            if(ds?.Tables[0].Rows.Count==0)
            { returnData.ErrorMessage = "No user information was found for this user"; }
            else if (ds.Tables[0].Rows[0]["Password"].ToString() != returnData.Password)
            { returnData.ErrorMessage = "Incorrect password entered"; }
            else if (ds.Tables[0].Rows[0]["ActiveInd"].ToString() != "1")
            { returnData.ErrorMessage = "User is inactive"; }
            return returnData;
        }

        private static UserEntity LoadSingleUser(DataRow newRow, UserEntity returnData)
        {
            try
            {
                returnData.ActiveInd = Convert.ToInt16(newRow["ActiveInd"]) == 1;
                returnData.PhoneNumber = newRow["PhoneNumber"].ToString();
                returnData.CreatedDateTime = Convert.ToDateTime(newRow["CreatedDateTime"]);
                returnData.EmailAddress = newRow["EmailAddress"].ToString();
                returnData.FirstName = newRow["FirstName"].ToString();
                returnData.LastName = newRow["LastName"].ToString();
                returnData.Department = newRow["Department"].ToString();
                returnData.DepartmentCode = newRow["DepartmentCode"].ToString();
                returnData.DepartmentKey = Convert.ToInt32(newRow["DepartmentKey"]);
                returnData.UserProfileKey = Convert.ToInt32(newRow["UserProfileKey"]);
                returnData.SQLUserName = newRow["SQLUserName"].ToString();
                returnData.LastRefreshed = DateTime.Now;
            }
            catch (Exception ex)
            {
                returnData.ErrorMessage = ex.Message;
            }
            return returnData;
        }
    }
}
