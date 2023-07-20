using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class NotificationEntity
    {
        public int NotificationKey { get; set; }
        public int NotificationTypeKey { get; set; }
        public int UserProfileKey { get; set; }
        public string NotificationValue { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public DateTime LastUpdatedDateTime { get; set; }
        public string LastUpdatedBy { get; set; }
        public string NotificationType { get; set; }
        public string NotificationTypeCode { get; set; }
        public DateTime ReadDateTime { get; set; }
        public string NotificationTarget { get; set; }
    }
}
