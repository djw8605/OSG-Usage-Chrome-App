define [ 'angular', 'angular-resource' ], (angular) ->

    addGraphController = angular.module 'osgUsageApp.controller.addgraph', [ 'ngResource' ]

    addGraphController.controller 'AddGraphCtrl',

        class AddGraphCtrl
            constructor: (@$scope, @$rootScope, @$log, @$modalInstance, @$http, @$resource) ->
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

                # Startswith implementation
                if (typeof String.prototype.startsWith != 'function')
                    String.prototype.startsWith = (str) ->
                        return this.slice(0, str.length) == str;



                original_url = @$scope.graph.baseUrl
                @$scope.checkingURL = true
                params = $.parseParams ( original_url.split('?')[1]  )

                target = $(".statusChecking .spinnerInject").spin()
                
                toSend = { "requestURL": @$scope.graph.baseUrl }
                
                @$http.post("/api/checkgraph", JSON.stringify(toSend)).success (data, status, headers) =>

                    headers = headers()
                    # If html / xml
                    if (headers['content-type'].startsWith('text/xml') or headers['content-type'].startsWith('application/xml'))
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
                        originalPathname = graphUrlRegex.exec(original_url)[0]
                        @$scope.graph.websiteURL = originalPathname
                        @$scope.graph.queryParams = params
                        @$log.info(@$scope.graph)
                        @$modalInstance.close(@$scope.graph)
                    # if raw image
                    else if (headers['content-type'].startsWith('image/png') or headers['content-type'].startsWith('image/svg+xml'))
                        @$log.info("Got a raw image...")
                        @$scope.graph.baseUrl = graphUrlRegex.exec(@$scope.graph.baseUrl)[0]
                        @$log.info("Got new baseUrl")
                        @$log.info(@$scope.graph.baseUrl)
                        @$scope.graph.queryParams = params
                        @$modalInstance.close(@$scope.graph)


                .error (data, status, headers, config) =>
                    @$log.info("Failed to get website from #{@$scope.graph.baseUrl}")
                    @$scope.errorDisplay = "Unable to contact website: #{status}"









            cancel: () =>
                @$modalInstance.dismiss('cancel')
