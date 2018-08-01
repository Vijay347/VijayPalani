using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TwitterClone.DataLayer.Models;

namespace TwitterClone.UI.Models
{
    public class TweetVM
    {
        public List<Tweet> Tweets { get; set; }

        public int NoOfTweets { get; set; }

        public int Following { get; set; }

        public int Followers { get; set; }


    }
}