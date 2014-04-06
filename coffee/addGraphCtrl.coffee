addGraphController = angular.module 'osgUsageApp.controller.addgraph', []

addGraphController.controller 'AddGraphCtrl',

    class AddGraphCtrl
        constructor: (@$scope, @$rootScope, @$log, @$modalInstance, @$http) ->
            @$scope.graph = {}
            @$scope.graph.queryParams = {}
            @$scope.addGraph = @addGraph
            @$scope.cancel = @cancel
            
        
        getLocation: (href) ->
            l = document.createElement("a")
            l.href = href
            return l
        
            
        
        addGraph: () =>
            graphUrlRegex = /^([\w\:\/\.]*)/
            
            graph_get = @$http.get(@$scope.graph.baseUrl)
            original_url = @$scope.graph.baseUrl
            @$scope.checkingURL = true
            
            target = $(".statusChecking .spinnerInject").spin()
            
            graph_get.success (data, status, headers, config) =>
                
                headers = headers()
                # If html / xml
                if (headers['content-type'] in ['text/xml', 'application/xml'])
                    @$log.info("Got website from #{@$scope.graph.baseUrl}")
                    # Now, check if we can parse it
                    webpage = $.parseXML( data )
                    webpage = $(webpage)
                    img = webpage.find('url')
                    @$log.info("Found img tag:")
                    @$log.info(img)
                    hostname = @getLocation(@$scope.graph.baseUrl).origin
                    pathname = graphUrlRegex.exec(img[0].textContent)[0]
                    @$scope.graph.baseUrl = "#{hostname}/#{pathname}"
                    @$scope.graph.websiteURL = original_url
                    @$log.info(@$scope.graph)
                    @$modalInstance.close(@$scope.graph)
                # if raw image
                else if (headers['content-type'] in ['image/png', ['image/svg+xml']])
                    @$log.info("Got a raw image...")
                    @$scope.graph.baseUrl = graphUrlRegex.exec(@$scope.graph.baseUrl)[0]
                    @$log.info("Got new baseUrl")
                    @$log.info(@$scope.graph.baseUrl)
                    @$modalInstance.close(@$scope.graph)
                
                
            graph_get.error (data, status, headers, config) =>
                @$log.info("Failed to get website from #{@$scope.graph.baseUrl}")
                @$scope.errorDisplay = "Unable to contact website: #{status}"
                
                
            
            


        

            
        cancel: () =>
            @$modalInstance.dismiss('cancel')
        