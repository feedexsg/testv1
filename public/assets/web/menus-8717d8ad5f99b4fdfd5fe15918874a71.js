var web=angular.module("web",["ngAnimate"]);web.controller("maincontroller",function(e,n,a,t,m){e.name={},e.name.mainnow=0,e.name.mainnext=0,e.name.mainimgshow=!0,e.name.sidenow=0,e.name.sidenext=0,e.name.sideimgshow=!0,e.name.divshow=1,e.name.step=1,e.name.pagetitle=null,e.name.pagefoot="ADD TO CART",e.name.menutitle=null,e.name.mainclass="img1",e.name.sideclass="img1",e.name.foodselect=[],e.name.price=0,e.name.pay="Cash",e.name.credit=0,e.name.usertoken=null,e.name.setemail="",e.name.setpassword="",e.name.setpassword2="",e.name.setphone="",e.name.buttonclass=["navibuttonc","navibutton","navibutton","navibutton"],m.get().success(function(n){e.name.usertoken=n.auth_key,e.name.credit=n.user.total_credits,console.log(n)}),e.$watch("name.usertoken",function(){t.get(e.name.usertoken).success(function(n){for(e.name.side=[],e.name.main=[],i=0;i<=n.side_items.length-1;i++)e.name.side.push(n.side_items[i]);for(i=0;i<=n.main_items.length-1;i++)e.name.main.push(n.main_items[i]),console.log(n);e.name.menutitle=n.menu.title})}),e.$watch("name.main",function(){e.name.mainleng=null==e.name.main?0:e.name.main.length,e.name.pagetitle=e.name.menutitle}),e.$watch("name.side",function(){e.name.sideleng=null==e.name.side?0:e.name.side.length}),e.name.maincheckfun=function(n){0==n?(e.name.mainclass="img1",e.name.mainnext=0==e.name.mainleng?0:(e.name.mainnow+1+e.name.mainleng)%e.name.mainleng):(e.name.mainclass="img2",e.name.mainnext=0==e.name.mainleng?0:(e.name.mainnow-1+e.name.mainleng)%e.name.mainleng),e.name.mainimgshow=!e.name.mainimgshow,e.name.mainnow=e.name.mainnext},e.name.sidecheckfun=function(n){0==n?(console.log("LEFT SIDE"),e.name.sideclass="img1",e.name.sidenext=0==e.name.sideleng?0:(e.name.sidenow+1+e.name.sideleng)%e.name.sideleng):(console.log("RIGHT SIDE"),e.name.sideclass="img2",e.name.sidenext=0==e.name.sideleng?0:(e.name.sidenow-1+e.name.sideleng)%e.name.sideleng),e.name.sideimgshow=!e.name.sideimgshow,e.name.sidenow=e.name.sidenext,console.log(e.name.sidenext),console.log(e.name.sideclass)},e.name.sure=function(n){0==n?(e.name.foodselect.push(e.name.side[e.name.sidenow]),e.name.price+=parseFloat(e.name.side[e.name.sidenow].price)):(e.name.foodselect.push(e.name.main[e.name.mainnow]),e.name.price+=parseFloat(e.name.main[e.name.mainnow].price)),console.log(e.name.foodselect)},e.$watch("name.divshow",function(){1==e.name.divshow?(console.log("in2"),1==e.name.step?(e.name.pagetitle=e.name.menutitle,e.name.pagefoot="ADD TO CART"):2==e.name.step?(e.name.pagetitle="Summary",e.name.pagefoot="CHECK OUT"):3==e.name.step?(e.name.pagetitle="Mode Of Payment",e.name.pagefoot="NEXT"):4==e.name.step&&(e.name.pagetitle="Confirmation",e.name.pagefoot="AWSOME")):2==e.name.divshow?(e.name.pagetitle="My Wallet",e.name.pagefoot="ADD VALUE"):3==e.name.divshow?(e.name.pagetitle="Settings",e.name.pagefoot="SAVE CHANGES"):e.name.pagetitle="Log Out"}),e.$watch("name.step",function(){1==e.name.step?(e.name.pagetitle=e.name.menutitle,e.name.pagefoot="ADD TO CART"):2==e.name.step?(e.name.pagetitle="Summary",e.name.pagefoot="CHECK OUT"):3==e.name.step?(e.name.pagetitle="Mode Of Payment",e.name.pagefoot="NEXT"):4==e.name.step&&(e.name.pagetitle="Confirmation",e.name.pagefoot="AWSOME")}),e.name.test=function(n){e.name.buttonclass[e.name.divshow-1]="navibutton",e.name.divshow=n,e.name.buttonclass[n-1]="navibuttonc"},e.name.footchange=function(){1==e.name.divshow&&(e.name.step=e.name.step%4+1)},e.name.footshow=function(){return 1==e.name.divshow?1==e.name.step?0==e.name.price?(e.name.pagefoot="Select Your Food First",!1):(e.name.pagefoot="Add To Cart",!0):2==e.name.step?0==e.name.price?(e.name.pagefoot="No Food Selected",!1):(e.name.pagefoot="Check Out",!0):3==e.name.step?"Cash"==e.name.pay?(e.name.pagefoot="Next",!0):e.name.price>e.name.credit?(e.name.pagefoot="Credit Not Enough",!1):(e.name.pagefoot="Next",!0):!0:2==e.name.divshow?isNaN(e.name.topupnum)?!1:e.name.topupnum>=10?!0:!1:3==e.name.divshow?""==e.name.setemail?!1:""==e.name.setpassword?!1:""==e.name.setphone?!1:!0:!1},e.name.cartremove=function(n){e.name.price-=e.name.foodselect[n].price,e.name.foodselect.splice(n,1)},e.$watch("name.pay",function(){console.log(e.name.pay)})}),web.factory("Colonygetter",function(e){return{get:function(){return e.get("/api/colonies",{headers:{"X-Auth":"c63c4aabc197ab6016aaad8ba2b44a76"}})}}}),web.factory("Itemgetter",function(e){return{getitems:function(){return e.get("/api/items",{headers:{"X-Auth":"c63c4aabc197ab6016aaad8ba2b44a76"}})},getitemid:function(){return e.get("/api/items/1",{headers:{"X-Auth":"c63c4aabc197ab6016aaad8ba2b44a76"}})},getavailable:function(){return e.get("/api/items/available",{headers:{"X-Auth":"c63c4aabc197ab6016aaad8ba2b44a76"}})},getcategory:function(){return e.get("/api/items/sort?category=Maincourse",{headers:{"X-Auth":"c63c4aabc197ab6016aaad8ba2b44a76"}})}}}),web.factory("Menusgetter",function(e){return{get:function(n){return e.get("/api/menus",{headers:{"X-Auth":n}})}}}),web.factory("Tokengetter",function(e){return{get:function(){return e({method:"POST",url:"/api/sessions",data:JSON.stringify({email:"wangjiadong1993@gmail.com",password:"12345"}),headers:{"Content-Type":"application/json"}})}}});