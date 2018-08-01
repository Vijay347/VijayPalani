using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TwitterClone.DataLayer.Models;

namespace TwitterClone.BusinessLayer
{
    public class TweetBL
    {
        public List<Tweet> GetTweets(string userId)
        {
            List<Tweet> tweets = new List<Tweet>();
            List<Tweet> FollowingTweets = new List<Tweet>();
            List<Following> followings = new List<Following>();
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                tweets = (from t in db.Tweets                                
                          where t.UserId == userId
                          select t
                          ).OrderBy(x => x.CreatedDate).ToList();
                followings = (from f in db.Followings
                              where f.UserId == userId
                              select f
                          ).ToList();

                foreach (var item in followings)
                {
                    FollowingTweets = (from t in db.Tweets
                              where t.UserId == item.FollowingId
                              select t
                         ).OrderBy(x => x.CreatedDate).ToList();

                    foreach (var tweet in FollowingTweets)
                    {
                        tweets.Add(tweet);
                    }
                }
            }
            return tweets;
        }

        public int GetUserTweetCount(string userId)
        {
            int result = 0;
            List<Tweet> tweets = new List<Tweet>();           
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                tweets = (from t in db.Tweets
                          where t.UserId == userId
                          select t
                          ).OrderBy(x => x.CreatedDate).ToList();

                if (tweets != null && tweets.Count > 0)
                    result = tweets.Count;
              
            }
            return result;
            
        }

        public int GetUserFollowingCount(string userId)
        {
            int result = 0;        
            List<Following> followings = new List<Following>();
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                followings = (from f in db.Followings
                              where f.UserId == userId
                              select f
                          ).ToList();

                if (followings != null && followings.Count > 0)
                    result = followings.Count;

            }
            return result;

        }

        public int GetUserFollowersCount(string userId)
        {
            int result = 0;
            List<Following> followings = new List<Following>();
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                followings = (from f in db.Followings
                              where f.FollowingId == userId
                              select f
                          ).ToList();

                if (followings != null && followings.Count > 0)
                    result = followings.Count;

            }
            return result;

        }



        public void SaveTweet(Tweet tweet)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                if (tweet.TweetId == 0)
                {
                    db.Tweets.Add(tweet);
                }
                else
                {
                    Tweet t;
                    t = GetTweetById(tweet.TweetId);
                    t.Message = tweet.Message;
                    db.Tweets.Attach(t);
                    db.Entry(t).State = EntityState.Modified;
                }
                db.SaveChanges();
            }
        }

        public void DeleteTweet(int tweetId)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                Tweet t;
                t = GetTweetById(tweetId);
                //db.Tweets.Remove(t);
                db.Entry(t).State = EntityState.Deleted;
                db.SaveChanges();
            }
        }

        public Tweet GetTweetById(int tweetId)
        {
            Tweet tweet = new Tweet();
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                tweet = (from t in db.Tweets
                          where t.TweetId == tweetId
                          select t).SingleOrDefault();

            }
            return tweet;
        }
    }
}
