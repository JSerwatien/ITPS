using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Data.Code
{
    public class DataFactory
    {
        private static readonly string connectionString = "Data Source=DESKTOP-K792KQS\\SQLEXPRESS;Initial Catalog =ITPS; Integrated Security = True;TrustServerCertificate=True";
        public static DataSet GetDataSet(string strSQL, string tableName)
        {
            try
            {
                DataSet ds = new DataSet();
                SqlDataAdapter sqlAdapter = new SqlDataAdapter(strSQL, connectionString);
                sqlAdapter.Fill(ds, tableName);
                return ds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static string GetChainName(int chainKey)
        {
            string strSQL = "EXEC dbo.Chain_SELByKey {0}";
            DataSet ds = new();
            strSQL = string.Format(strSQL, chainKey);
            ds = GetDataSet(strSQL, "ChainInfo");
            return ds.Tables[0].Rows.Count > 0 ? ds.Tables[0].Rows[0]["ChainName"].ToString() : "No chain was found for ID " + chainKey;
        }
        public static string GetChainNameByParameter(int chainKey)
        {
            DataSet ds = new DataSet();
            SqlDataAdapter sqlAdapter;
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = connection.CreateCommand())
                    {
                        command.CommandText = "dbo.Chain_SELByKey";
                        command.CommandType = CommandType.StoredProcedure;

                        SqlParameter parameter;
                        parameter = command.Parameters.AddWithValue("@ChainKey", chainKey);
                        sqlAdapter = new SqlDataAdapter(command);
                        sqlAdapter.SelectCommand.Connection = connection;
                        sqlAdapter.Fill(ds);
                    }
                }
                return ds.Tables[0].Rows.Count > 0 ? ds.Tables[0].Rows[0]["ChainName"].ToString() : "No chain was found for ID " + chainKey;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
    }
}
