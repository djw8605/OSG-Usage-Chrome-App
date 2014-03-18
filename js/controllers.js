
var ProfileSetupControllerInstance = function($scope, $modalInstance) {
    
    $scope.save = function() {
        $modalInstance.close();
    }
    
    $scope.cancel = function() {
        $modalInstance.dismiss('cancel');
    }
    
    
    $scope.addProfile = function(profile) {
        
        $modalInstance.close(profile);
    }
    
    
}
