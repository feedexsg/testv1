var web = angular.module("web", []);
web.controller('maincontroller', ['$scope',
    function($scope) {
        $scope.name = {}
        $scope.name.test = "Wang Jiadong"
    }
])