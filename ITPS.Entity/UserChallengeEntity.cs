using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPS.Entity
{
    public class UserChallengeEntity
    {
        public string UserName { get; set; }
        public string ChallengeQuestion { get; set; }
        public string ChallengeAnswer { get; set; }
        public string Password { get; set; }
    }
}
