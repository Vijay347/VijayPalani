using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TwitterClone.DataLayer;
using TwitterClone.DataLayer.Models;

namespace TwitterClone.BusinessLayer
{
    public class UserBL
    {
        public void AddUser(Person item)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                db.People.Add(item);
                db.SaveChanges();
            }
        }

        public void UpdateUser(Person person)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                if (!string.IsNullOrWhiteSpace(person.UserId))                
                {
                    Person p;
                    p = SearchUser(person.UserId);
                    p.Active = person.Active;
                    p.Email = person.Email;
                    p.FullName = person.FullName;
                    p.Password = person.Password;
                    db.People.Attach(p);
                    db.Entry(p).State = EntityState.Modified;
                }
                db.SaveChanges();
            }
        }
        public Person Validate(string uname,string pwd)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                Person obj = db.People.FirstOrDefault(i => i.UserId == uname && i.Password == pwd && i.Active == true);
                return obj;
            }
        }
        public Person SearchUser(string uname)
        {
            using (TwitterCloneEntities db = new TwitterCloneEntities())
            {
                Person obj = db.People.FirstOrDefault(i => i.UserId.Contains(uname));
                return obj;
            }
        }


    }
}
