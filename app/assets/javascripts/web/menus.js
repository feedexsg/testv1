var web = angular.module("web", ['ngAnimate']);
web.controller('maincontroller', function($scope, Colonygetter, Itemgetter, Menusgetter) {
    // pre define of varibales
    $scope.name = {}
    $scope.name.test = "wangjiadong"
    $scope.name.show = true;

    $scope.name.mainindex = 0;
    $scope.name.sideindex = 0;

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

    // to detect and update runtime
    $scope.$watch('name.main', function() {
        $scope.name.mainleng = $scope.name.main.length
    })
    // to detect and update runtime
    $scope.$watch('name.side', function() {
        $scope.name.sideleng = $scope.name.side.length
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
        get: function() {
            return $http.get('/api/menus', {
                headers: {
                    'X-Auth': 'c63c4aabc197ab6016aaad8ba2b44a76'
                }
            })

        }
    }
});