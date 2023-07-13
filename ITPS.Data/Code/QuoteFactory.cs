using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http.Headers;
using System.Data;
using Newtonsoft.Json;
using System.Xml;

namespace ITPS.Data.Code
{
    public class QuoteFactory
    {
        //https://api-ninjas.com/api
        public static string GetRandomJoke()
        {
            var theClient = new HttpClient();
            try
            {
                var theRequest = new HttpRequestMessage
                {
                    Method = HttpMethod.Get,
                    RequestUri = new Uri("https://api.api-ninjas.com/v1/dadjokes?limit=1"),
                    Headers =
    {
        { "X-Api-Key", "kQMgtsmtUtKsbxBo+dtM8A==ItTVokmqzMyPkqCV" },
    },
                };
                using (var response = theClient.Send(theRequest))
                {
                    //response.EnsureSuccessStatusCode();
                    var theBody = response.Content.ReadAsStringAsync();
                    string jsonString = $"{{ \"rootNode\": {{{theBody.Result.Replace("[", "").Replace("]", "").Trim().TrimStart('{').TrimEnd('}')}}} }}";
                    DataSet ds = ConvertJSONToDataSet(jsonString);
                    return ds.Tables[0].Rows[0]["joke"].ToString();
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        public static string GetRandomQuote()
        {
            var theClient = new HttpClient();
            try
            {
                var theRequest = new HttpRequestMessage
                {
                    Method = HttpMethod.Get,
                    RequestUri = new Uri("https://api.api-ninjas.com/v1/quotes?category=inspirational"),
                    Headers =
    {
        { "X-Api-Key", "kQMgtsmtUtKsbxBo+dtM8A==ItTVokmqzMyPkqCV" },
    },
                };
                using (var response = theClient.Send(theRequest))
                {
                    var theBody = response.Content.ReadAsStringAsync();
                    // To convert JSON text contained in string json into an XML node
                    string jsonString = $"{{ \"rootNode\": {{{theBody.Result.Replace("[", "").Replace("]", "").Trim().TrimStart('{').TrimEnd('}')}}} }}";
                    DataSet ds = ConvertJSONToDataSet(jsonString);
                    return ds.Tables[0].Rows[0]["quote"] + ": <i>" + ds.Tables[0].Rows[0]["author"] + "</i>";
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        private static DataSet ConvertJSONToDataSet(string jsonString)
        {
            XmlDocument theDoc = JsonConvert.DeserializeXmlNode(jsonString);
            XmlDocument xmlDoc = new XmlDocument();
            //Code to load xml into xmlDocument
            XmlReader xmlReader = new XmlNodeReader(theDoc);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            return ds;
        }
    }
}
