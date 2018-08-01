using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TwitterClone.UI.Models;
using TwitterClone.BusinessLayer;
using TwitterClone.DataLayer;
using TwitterClone.DataLayer.Models;

namespace TwitterClone.UI.Controllers
{
    public class UserController : Controller
    {
        UserBL obj = new UserBL();
        // GET: User
        public ActionResult Index()
        {
            return View();
        }
        public ViewResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(PersonVM item)
        {
            if (ModelState.IsValid)
            {
                Person p = new Person()
                {
                    UserId = item.UserId,
                    Password = item.Pwd,
                    Email = item.Email,
                    FullName = item.Name,
                    Active = true,
                    Joined = DateTime.Now
                };
                obj.AddUser(p);
                return RedirectToAction("Login");

            }
            else
                return View();
        }

        public ViewResult Update()
        {
            Person person = obj.SearchUser(Session["UserId"].ToString());
            PersonVM peopleVM = new PersonVM();
            peopleVM.UserId = person.UserId;
            peopleVM.Email = person.Email;
            peopleVM.Active = person.Active;
            peopleVM.Joined = person.Joined;
            peopleVM.Name = person.FullName;
            peopleVM.Pwd = person.Password;
            return View(peopleVM);
        }

        [HttpPost]
        public ActionResult Update(PersonVM item)
        {
            if (ModelState.IsValid)
            {
                Person p = new Person()
                {
                    UserId = item.UserId,
                    Password = item.Pwd,
                    Email = item.Email,
                    FullName = item.Name,
                    Active = item.Active,
                    Joined = DateTime.Now
                };
                obj.UpdateUser(p);
                return RedirectToAction("Login");

            }
            else
                return View();
        }

        [HttpPost]
        public ActionResult Deactivate()
        {
            Person p = obj.SearchUser(Session["UserId"].ToString());
            if(p != null)
            {
                p.Active = false;                
            };
            obj.UpdateUser(p);
            //return RedirectToAction("Login");
            var result = "success";
            return Json(result, JsonRequestBehavior.AllowGet);

        }
        public ViewResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(string uname, string pwd)
        {
            Person p = obj.Validate(uname, pwd);
            if (p != null)
            {
                //return RedirectToAction("Details", p);
                Session["UserName"] = p.FullName;
                Session["UserId"] = p.UserId;
                return RedirectToAction("Index", "Home", p);
            }
            else
            {
                TempData["err"] = "Invalid Login Details";
                return View();
            }
        }
        public ViewResult Details(Person p)
        {
            return View(p);
        }

    }
}