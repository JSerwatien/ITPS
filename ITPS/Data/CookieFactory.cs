using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using ITPS.Data.Code;
using Microsoft.JSInterop;

namespace ITPS.Data
{
    public interface ICookieFactory
    {
        public Task SetUserCookies(string loginCookie, string userCookie, string loginCookieName, string userCookieName, int loginDays, int userDays);
        public Task SetValue(string key, string value, int? days = null);
        public Task<string> WriteCookie(string theKey, string theValue, string expirationDays);
        public Task<string> GetValue(string key, string def = "");
        public Task<string> ReadCookie(string key);
    }
    public class CookieFactory : ICookieFactory
    {
        readonly IJSRuntime JSRuntime;
        static JSRuntime SJSRuntime;
        string expires = "";
        public CookieFactory(IJSRuntime jsRuntime)
        {
            JSRuntime = jsRuntime;
            ExpireDays = 300;
        }
        public async Task SetUserCookies(string loginCookie, string userCookie, string loginCookieName, string userCookieName, int loginDays, int userDays)
        {
            await SetCookie($"{loginCookieName}={loginCookie}; expires={loginDays}; path=/");
            await SetCookie($"{userCookieName}={userCookie}; expires={userDays}; path=/");
        }
        public async Task SetValue(string key, string value, int? days = null)
        {
            var curExp = (days != null) ? (days > 0 ? DateToUTC(days.Value) : "") : expires;
            await SetCookie($"{key}={value}; expires={curExp}; path=/");
        }
        public async Task<string> GetValue(string key, string def = "")
        {
            var cValue = await GetCookie();
            if (string.IsNullOrEmpty(cValue)) return def;
            var vals = cValue.Split(';');
            foreach (var val in vals)
                if (!string.IsNullOrEmpty(val) && val.IndexOf('=') > 0)
                    if (val.Substring(1, val.IndexOf('=') - 1).Trim().Equals(key, StringComparison.OrdinalIgnoreCase))
                        return val.Substring(val.IndexOf('=') + 1);
            return def;
        }
        public static async Task<string> GetStaticValue(string key, string def = "")
        {
            var cValue = await GetStaticCookie();
            if (string.IsNullOrEmpty(cValue)) return def;
            var vals = cValue.Split(';');
            foreach (var val in vals)
                if (!string.IsNullOrEmpty(val) && val.IndexOf('=') > 0)
                    if (val.Substring(1, val.IndexOf('=') - 1).Trim().Equals(key, StringComparison.OrdinalIgnoreCase))
                        return val.Substring(val.IndexOf('=') + 1);
            return def;
        }
        private async Task SetCookie(string value)
        {
            await JSRuntime.InvokeVoidAsync("eval", $"document.cookie = \"{value}\"");
        }
        private async Task<string> GetCookie()
        {
            return await JSRuntime.InvokeAsync<string>("eval", $"document.cookie");
        }
        private async Task<string> ReadCookie(string key)
        {
            string cookie = string.Empty;
            try
            {
                cookie = await JSRuntime.InvokeAsync<string>("Cookies.getCookie", key);
            }
            catch (Exception e)
            {
                var x = e.Message;
            }
            return cookie;
        }
        public async Task<string> WriteCookie(string theKey, string theValue, string expirationDays)
        {
            return await JSRuntime.InvokeAsync<string>("Cookies.setCookie", theKey, theValue, expirationDays);
        }
        private static async Task<string> GetStaticCookie()
        {
            return await SJSRuntime.InvokeAsync<string>("eval", $"document.cookie");
        }
        public int ExpireDays
        {
            set => expires = DateToUTC(value);
        }
        private static string DateToUTC(int days) => DateTime.Now.AddDays(days).ToUniversalTime().ToString("R");
        async Task<string> ICookieFactory.ReadCookie(string key)
        {
            return await JSRuntime.InvokeAsync<string>("Cookies.getCookie", key);
//            await JSRuntime.InvokeAsync<string>("ReadCookie.ReadCookie", key);
        }
    }
}
