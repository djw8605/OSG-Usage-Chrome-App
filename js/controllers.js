
var ProfileSetupControllerInstance = function($scope, $modalInstance) {
    
    $scope.save = function() {
        $modalInstance.close();
    }
    
    $scope.cancel = function() {
        $modalInstance.dismiss('cancel');
    }
    
    $scope.templates = [
        {
            title: "Resource Owner",
            content: "The Resource Owner Template"
        
        },
        {
            title: "VO Manager",
            content: "The VO Manager Tempalate"
        }
        
    ];
    
    
}
