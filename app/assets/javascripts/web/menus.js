var web = angular.module("web", ['ngAnimate']);
web.controller('maincontroller', function($scope, Colonygetter, Itemgetter, Menusgetter, Tokengetter) {
    // pre define of varibales
    // name is the global name space for rhe controller and itself has no meanings
    $scope.name = {}

    // the index of the images shown in both main and side 
    $scope.name.mainnow = 0;
    $scope.name.mainnext = 0;
    $scope.name.mainimgshow = true;

    $scope.name.sidenow = 0;
    $scope.name.sidenext = 0;
    $scope.name.sideimgshow = true;


    //page content variables
    $scope.name.divshow = 1;
    $scope.name.step = 1;
    $scope.name.pagetitle = null
    $scope.name.pagefoot = "ADD TO CART"
    $scope.name.menutitle = null;

    //the animation class of main and side
    $scope.name.mainclass = 'img1'
    $scope.name.sideclass = 'img1'


    //user info and food info 

    $scope.name.foodselect = []
    $scope.name.price = 0;
    $scope.name.pay = 'Cash';
    $scope.name.credit = 0;

    $scope.name.usertoken = null;

    //setting page variables
    $scope.name.setemail = '';
    $scope.name.setpassword = '';
    $scope.name.setpassword2 = '';
    $scope.name.setphone = '';




    $scope.name.buttonclass = ['navibuttonc', 'navibutton', 'navibutton', 'navibutton']

    Tokengetter.get().success(function(data) {
        $scope.name.usertoken = data['auth_key'];
        $scope.name.credit = data['user']['total_credits'];
        console.log(data)
    })

    $scope.$watch('name.usertoken', function() {
        Menusgetter.get($scope.name.usertoken).success(function(data) {
            $scope.name.side = []
            $scope.name.main = []
            for (i = 0; i <= data['side_items'].length - 1; i++) {
                $scope.name.side.push(data['side_items'][i])
            }
            for (i = 0; i <= data['main_items'].length - 1; i++) {
                $scope.name.main.push(data['main_items'][i])
                console.log(data)
            }
            $scope.name.menutitle = data['menu']['title']
            // console.log(data)
        })
    })
    // mainleng and sideleng are the number of main dishes and sidedishes
    // to detect and update runtime

    $scope.$watch('name.main', function() {
        $scope.name.mainleng = $scope.name.main == null ? 0 : $scope.name.main.length;
        $scope.name.pagetitle = $scope.name.menutitle
    })
    $scope.$watch('name.side', function() {
        $scope.name.sideleng = $scope.name.side == null ? 0 : $scope.name.side.length;

    })


    $scope.name.maincheckfun = function(val) {
        if (val == 0) {
            // console.log("LEFT SIDE")
            $scope.name.mainclass = "img1"
            $scope.name.mainnext = ($scope.name.mainleng == 0) ? 0 : ($scope.name.mainnow + 1 + $scope.name.mainleng) % ($scope.name.mainleng)
        } else {
            // console.log("RIGHT SIDE")
            $scope.name.mainclass = "img2"
            $scope.name.mainnext = ($scope.name.mainleng == 0) ? 0 : ($scope.name.mainnow - 1 + $scope.name.mainleng) % ($scope.name.mainleng)
        }
        $scope.name.mainimgshow = !$scope.name.mainimgshow
        $scope.name.mainnow = $scope.name.mainnext
        // console.log($scope.name.mainnext)
        // console.log($scope.name.mainnow)
        // console.log($scope.name.mainclass)

    }
    $scope.name.sidecheckfun = function(val) {
        if (val == 0) {
            console.log("LEFT SIDE")
            $scope.name.sideclass = "img1"
            $scope.name.sidenext = ($scope.name.sideleng == 0) ? 0 : ($scope.name.sidenow + 1 + $scope.name.sideleng) % ($scope.name.sideleng)
        } else {
            console.log("RIGHT SIDE")
            $scope.name.sideclass = "img2"
            $scope.name.sidenext = ($scope.name.sideleng == 0) ? 0 : ($scope.name.sidenow - 1 + $scope.name.sideleng) % ($scope.name.sideleng)
        }
        $scope.name.sideimgshow = !$scope.name.sideimgshow
        $scope.name.sidenow = $scope.name.sidenext
        console.log($scope.name.sidenext)
        console.log($scope.name.sideclass)
    }
    // update the index of the maindishes and sidedishes
    // $scope.name.check = function(type, position) {
    //     if (type == 0 && position == 0) {
    //         return $scope.name.sideindex == 0;
    //     } else if (type == 1 && position == 0) {
    //         return $scope.name.mainindex == 0;
    //     } else if (type == 0 && position == 1) {
    //         return $scope.name.sideindex == $scope.name.sideleng - 1;
    //     } else {
    //         return $scope.name.mainindex == $scope.name.mainleng - 1;
    //     }
    // }
    $scope.name.sure = function(obj) {
        // console.log('in')
        // obj == 0 ? ($scope.name.sideclass == 'img3' ? $scope.name.sideclass = 'img1' : $scope.name.sideclass = 'img3') : ($scope.name.mainclass == 'img3' ? $scope.name.mainclass = 'img1' : $scope.name.mainclass = 'img3');
        if (obj == 0) {
            // if ($scope.name.sideclass == 'img3') {
            $scope.name.foodselect.push($scope.name.side[$scope.name.sidenow])
            $scope.name.price += parseFloat($scope.name.side[$scope.name.sidenow].price);
            // console.log("side in")
            // } else {
            // $scope.name.foodselect.pop();
            // $scope.name.price -= parseInt($scope.name.side[$scope.name.sidenow].price);
            // console.log('side out')
            // }
        } else {
            // if ($scope.name.mainclass == 'img3') {
            $scope.name.foodselect.push($scope.name.main[$scope.name.mainnow])
            $scope.name.price += parseFloat($scope.name.main[$scope.name.mainnow].price);
            // console.log('main in')
            // } else {
            // $scope.name.foodselect.pop();
            // $scope.name.price -= parseInt($scope.name.main[$scope.name.mainnow].price);
            // console.log('main out')
            // }
        }
        console.log($scope.name.foodselect)
    }

    $scope.$watch('name.divshow', function() {
        // console.log('in1')
        // console.log($scope.name.step)
        if ($scope.name.divshow == 1) {
            console.log('in2')
            if ($scope.name.step == 1) {
                // console.log('lunchmenu')
                $scope.name.pagetitle = $scope.name.menutitle;
                $scope.name.pagefoot = "ADD TO CART";
            } else if ($scope.name.step == 2) {
                $scope.name.pagetitle = "Summary";
                $scope.name.pagefoot = "CHECK OUT"
            } else if ($scope.name.step == 3) {
                $scope.name.pagetitle = "Mode Of Payment";
                $scope.name.pagefoot = "NEXT"
            } else if ($scope.name.step == 4) {
                // console.log('in3')
                $scope.name.pagetitle = "Confirmation";
                $scope.name.pagefoot = "AWSOME"
            }
        } else if ($scope.name.divshow == 2) {
            $scope.name.pagetitle = "My Wallet";
            $scope.name.pagefoot = "ADD VALUE"
        } else if ($scope.name.divshow == 3) {
            $scope.name.pagetitle = "Settings"
            $scope.name.pagefoot = "SAVE CHANGES"

        } else {
            $scope.name.pagetitle = 'Log Out'
        }
    })
    $scope.$watch('name.step', function() {
        if ($scope.name.step == 1) {
            $scope.name.pagetitle = $scope.name.menutitle;
            $scope.name.pagefoot = "ADD TO CART";
        } else if ($scope.name.step == 2) {
            $scope.name.pagetitle = "Summary";
            $scope.name.pagefoot = "CHECK OUT"
        } else if ($scope.name.step == 3) {
            $scope.name.pagetitle = "Mode Of Payment";
            $scope.name.pagefoot = "NEXT"
        } else if ($scope.name.step == 4) {
            $scope.name.pagetitle = "Confirmation";
            $scope.name.pagefoot = "AWSOME"
        }
    })
    $scope.name.test = function(obj) {
        $scope.name.buttonclass[$scope.name.divshow - 1] = 'navibutton'
        $scope.name.divshow = obj;
        $scope.name.buttonclass[obj - 1] = 'navibuttonc'
        // $scope.name.foodselect.push($scope.name.mainnow)
    }
    $scope.name.footchange = function() {
        if ($scope.name.divshow == 1) {
            // if ($scope.name.step == 3 && $scope.name.remainvalue < $scope.name.price) {

            // } else {
            $scope.name.step = $scope.name.step % 4 + 1;
        } else {
            // $scope.name.divshow = 1;
        }
    }
    $scope.name.footshow = function() {
        if ($scope.name.divshow == 1) {
            if ($scope.name.step == 1) {
                if ($scope.name.price == 0) {
                    $scope.name.pagefoot = "Select Your Food First"
                    return false;
                } else {
                    $scope.name.pagefoot = "Add To Cart"
                    return true;
                }
            } else if ($scope.name.step == 2) {
                if ($scope.name.price == 0) {
                    $scope.name.pagefoot = "No Food Selected"
                    return false;
                } else {
                    $scope.name.pagefoot = "Check Out"
                    return true;
                }
            } else if ($scope.name.step == 3) {
                if ($scope.name.pay == "Cash") {
                    $scope.name.pagefoot = "Next"
                    return true;
                } else {
                    if ($scope.name.price > $scope.name.credit) {
                        $scope.name.pagefoot = "Credit Not Enough"
                        return false;
                    } else {
                        $scope.name.pagefoot = "Next"
                        return true;
                    }
                }
            } else {
                return true;
            }
        } else if ($scope.name.divshow == 2) {
            if (isNaN($scope.name.topupnum))
                return false;
            else {
                if ($scope.name.topupnum >= 10)
                    return true;
                else {
                    return false;
                }
            }
        } else if ($scope.name.divshow == 3) {
            if ($scope.name.setemail == '') {
                return false;
            } else {
                if ($scope.name.setpassword == '')
                    return false;
                else {
                    if ($scope.name.setphone == '')
                        return false;
                    else
                        return true;
                }
            }
        } else {
            return false;
        }
    }
    $scope.name.cartremove = function(index) {
        $scope.name.price -= $scope.name.foodselect[index].price
        $scope.name.foodselect.splice(index, 1)
    }
    $scope.$watch('name.pay', function() {
        console.log($scope.name.pay)
    })

});

/*http get colony index*/
/*X auth is temperary!*/
web.factory('Colonygetter', function($http) {
    return {
        get: function() {
            return $http.get('/api/colonies', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })

        }
    }

});

/*http items api*/
/*X auth is temperary!*/
web.factory('Itemgetter', function($http) {
    return {
        getitems: function() {
            return $http.get('/api/items', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })
        },
        getitemid: function() {
            return $http.get('/api/items/1', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })
        },
        getavailable: function() {
            return $http.get('/api/items/available', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })
        },
        getcategory: function() {
            return $http.get('/api/items/sort?category=Maincourse', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })
        }
    }
});

web.factory('Menusgetter', function($http) {
    return {
        get: function(obj) {
            return $http.get('/api/menus', {
                headers: {
                    'X-Auth': obj
                }
            })

        }
    }
});
web.factory('Tokengetter', function($http) {
    return {
        get: function() {
            return $http({
                method: 'POST',
                url: '/api/sessions',
                data: JSON.stringify({
                    email: 'wangjiadong1993@gmail.com',
                    password: '12345'
                }),
                headers: {
                    'Content-Type': 'application/json'
                }
            })
        }
    }
})