var web = angular.module("web", ['ngAnimate']);
web.controller('maincontroller', function($scope, Colonygetter, Itemgetter, Menusgetter) {
    // pre define of varibales
    // name is the global name space for rhe controller and itself has no meanings


    // test use only variables, temperary, will be deleted later
    $scope.name = {}



    // the index of the images shown in both main and side 

    $scope.name.mainnow = 0;
    $scope.name.mainnext = 0;
    $scope.name.mainimgshow = true;

    $scope.name.sidenow = 0;
    $scope.name.sidenext = 0;
    $scope.name.sideimgshow = true;

    $scope.name.divshow = 1;
    $scope.name.step = 1;
    $scope.name.pagetitle = "Lunch Menu"
    $scope.name.pagefoot = "ADD TO CART"
    //the animation class of main and side
    $scope.name.mainclass = 'img1'
    $scope.name.sideclass = 'img1'
    // get the array of image urls

    $scope.name.foodselect = []
    $scope.name.price = 0;



    Menusgetter.get().success(function(data) {
        $scope.name.side = []
        $scope.name.main = []
        for (i = 0; i <= data['side_items'].length - 1; i++) {
            $scope.name.side.push(data['side_items'][i])
        }
        for (i = 0; i <= data['main_items'].length - 1; i++) {
            $scope.name.main.push(data['main_items'][i])
            console.log(data)
        }
    })

    // mainleng and sideleng are the number of main dishes and sidedishes
    // to detect and update runtime
    $scope.$watch('name.main', function() {
        $scope.name.mainleng = $scope.name.main == null ? 0 : $scope.name.main.length;
        // $scope.$watch('name.mainindex', function() {
        //     $scope.name.mainimage = $scope.name.main == null ? null : $scope.name.main[$scope.name.mainindex];
        // })
    })

    // $scope.$watch('name.mainindex', function() {
    //     $scope.name.mainimage = $scope.name.main == null ? null : $scope.name.main[$scope.name.mainindex];
    // })
    // $scope.$watch('name.sideindex', function() {
    //     $scope.name.sideimage = $scope.name.side == null ? null : $scope.name.side[$scope.name.sideindex];
    // })
    // to detect and update runtime
    $scope.$watch('name.side', function() {
        $scope.name.sideleng = $scope.name.side == null ? 0 : $scope.name.side.length;
        // $scope.$watch('name.sideindex', function() {
        //     $scope.name.sideimage = $scope.name.side == null ? null : $scope.name.side[$scope.name.sideindex];
        // })
    })


    $scope.name.maincheckfun = function(val) {
        if (val == 0) {
            console.log("LEFT SIDE")
            $scope.name.mainclass = "img1"
            $scope.name.mainnext = ($scope.name.mainleng == 0) ? 0 : ($scope.name.mainnow - 1 + $scope.name.mainleng) % ($scope.name.mainleng)
        } else {
            console.log("RIGHT SIDE")
            $scope.name.mainclass = "img2"
            $scope.name.mainnext = ($scope.name.mainleng == 0) ? 0 : ($scope.name.mainnow - 1 + $scope.name.mainleng) % ($scope.name.mainleng)
        }
        $scope.name.mainimgshow = !$scope.name.mainimgshow
        $scope.name.mainnow = $scope.name.mainnext
        console.log($scope.name.mainnext)
        console.log($scope.name.mainclass)

    }
    $scope.name.sidecheckfun = function(val) {
        if (val == 0) {
            console.log("LEFT SIDE")
            $scope.name.sideclass = "img1"
            $scope.name.sidenext = ($scope.name.sideleng == 0) ? 0 : ($scope.name.sidenow - 1 + $scope.name.sideleng) % ($scope.name.sideleng)
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
        console.log('in')
        // obj == 0 ? ($scope.name.sideclass == 'img3' ? $scope.name.sideclass = 'img1' : $scope.name.sideclass = 'img3') : ($scope.name.mainclass == 'img3' ? $scope.name.mainclass = 'img1' : $scope.name.mainclass = 'img3');
        if (obj == 0) {
            // if ($scope.name.sideclass == 'img3') {
            $scope.name.foodselect.push($scope.name.side[$scope.name.sidenow])
            $scope.name.price += parseInt($scope.name.side[$scope.name.sidenow].price);
            console.log("side in")
            // } else {
            // $scope.name.foodselect.pop();
            // $scope.name.price -= parseInt($scope.name.side[$scope.name.sidenow].price);
            // console.log('side out')
            // }
        } else {
            // if ($scope.name.mainclass == 'img3') {
            $scope.name.foodselect.push($scope.name.main[$scope.name.mainnow])
            $scope.name.price += parseInt($scope.name.main[$scope.name.mainnow].price);
            console.log('main in')
            // } else {
            // $scope.name.foodselect.pop();
            // $scope.name.price -= parseInt($scope.name.main[$scope.name.mainnow].price);
            // console.log('main out')
            // }
        }
        console.log($scope.name.foodselect)
    }

    $scope.$watch('name.divshow', function() {
        if ($scope.name.divshow == 1) {
            if ($scope.name.step == 1) {
                $scope.name.pagetitle = "Lunch Menu";
                $scope.name.pagefoot = "ADD TO CART";
            } else if ($scope.name.step == 2) {
                $scope.name.pagetitle = "Summary";
                $scope.name.pagefoot = "CHECK OUT"
            } else if ($scope.name.step == 3) {
                $scope.name.pagetitle = "Mode Of Payment";
                $scope.name.pagefoot = "NEXT"
            } else {
                $scope.name.pagetitle == "Confirmation";
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
            $scope.name.pagetitle = "Lunch Menu";
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
        $scope.name.divshow = obj;
        // $scope.name.foodselect.push($scope.name.mainnow)
    }
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
        get: function() {
            return $http.get('/api/menus', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })

        }
    }
});