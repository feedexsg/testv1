var web = angular.module("web", []);
web.controller('maincontroller', function($scope, Colonygetter, Itemgetter, Menusgetter) {

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