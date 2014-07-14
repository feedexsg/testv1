var web = angular.module("web", ['ngAnimate']);
web.controller('maincontroller', function($scope, Colonygetter, Itemgetter, Menusgetter) {
    // pre define of varibales
    // name is the global name space for rhe controller and itself has no meanings


    // test use only variables, temperary, will be deleted later
    $scope.name = {}
    $scope.name.test = function(obj) {
        $scope.name.divshow = obj;
        console.log($scope.name.divshow);
    }


    // the index of the images shown in both main and side 

    $scope.name.mainnow = 0;
    $scope.name.mainnext = 0;
    $scope.name.mainimgshow = true;

    $scope.name.sidenow = 0;
    $scope.name.sidenext = 0;
    $scope.name.sideimgshow = true;

    $scope.name.divshow = 1;

    //the animation class of main and side
    $scope.name.mainclass = 'img1'
    $scope.name.sideclass = 'img1'
    // get the array of image urls
    Menusgetter.get().success(function(data) {
        $scope.name.side = []
        $scope.name.main = []
        for (i = 0; i <= data['side_items'].length - 1; i++) {
            $scope.name.side.push(data['side_items'][i])
        }
        for (i = 0; i <= data['main_items'].length - 1; i++) {
            $scope.name.main.push(data['main_items'][i])
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