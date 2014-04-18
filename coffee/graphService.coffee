define [ 'angular', 'angular-resource' ], (angular) ->

    graphModule = angular.module 'osgUsageApp.graphService', []

    graphModule.service 'graphService',
        class GraphService
            constructor: (@$http, @$log, @$q) ->

                @graphFolder = 'graphFolder'

                # First, read in the graph configuration (which is json)
                @readGraphsData()
                @requestFilesystem()



            requestFilesystem: ->
                # Request file system space for the graphs, 10MB
                @deferred_fs = @$q.defer()
                #window.webkitRequestFileSystem "TEMPORARY", 10 * 1024 * 1024, (@fs) =>
                #    @$log.info "Initiailized the FS"
                #    @deferred_fs.resolve()
                @deferred_fs.resolve()
                return @deferred_fs.promise


            readGraphsData: ->
                @$log.info "Getting the graphs.json"
                @http_promise = @$http.get('data/graphs.json').success (data) =>
                    @$log.info "Received graphs.json: #{data}"
                    @graphsData = data



            getGraph: (graphName) ->
                @$log.info "Inside getGraph, getting #{graphName}"
                deferred_reading = @$q.defer()
                @http_promise.then () =>
                    @$log.info "Inside http_promise.then for #{graphName}"
                    if (graphName of @graphsData)
                        @$log.info "Resolving graphs data for #{graphName}"
                        deferred_reading.resolve(@graphsData[graphName])
                    else
                        @$log.info "rejecting graphs data"
                        deferred_reading.reject("#{graphName} not in Recieved Graph Data")

                deferred_reading.promise


            writeFile: (blob) ->
                @fs.root.getDirectory(@graphFolder, {create: true}, (dirEntry) =>
                    dirEntry.getFile(blob.name, {create: true, exclusive: false}, (fileEntry) =>
                        fileEntry.createWriter( (fileWriter) =>
                            fileWriter.onwriteend = (e) =>
                                @$log.info("Write completed.")
                            fileWriter.write(blob)
                            )
                        )
                    )

            convertParams: (params) ->
                # For each parameter, convert the value from a comma (and space) delimited
                # to a | symbol delimited.
                newParams = {}
                for key, value of params
                    if (value == "")
                        continue
                    else
                        value = value.replace /\s*\,\s*/g, '|'
                        newParams[key] = value

                newParams


            _createURL: (baseUrl, queryParams) ->
                convertedParams = @convertParams(queryParams)
                joinedParams = for key, value of convertedParams
                    "#{key}=#{value}"

                totalParams = joinedParams.join('&')
                if totalParams == ""
                    return "#{baseUrl}"
                else
                    return "#{baseUrl}?#{totalParams}"

            getUrl: (baseUrl, queryParams) ->
                # In this funciton, we get the query string, download the graph,
                # save it, and return a url

                return @_createURL baseUrl, queryParams

                deferred_graphUrl = @$q.defer()


                # Need a better way to uniqify the graph file name
                #filename = Math.floor((Math.random() * 1000000) + 1).toString() + '.png'
                #fs_url = @fs.root.toURL() + @graphFolder + '/' + filename
                url_get = @$http.get(baseUrl, {params: @convertParams(queryParams), responseType: 'blob'})

                url_get.success (data, status, headers, config) =>
                    @$log.info("Retrieved graph...")
                    params = $.param(@convertParams(queryParams))
                    @$log.info("#{baseUrl}?#{params}")
                    #data.name = filename
                    # @writeFile(data)

                    deferred_graphUrl.resolve(window.URL.createObjectURL(data))


                url_get.error (data, status, headers, config) =>
                    @$log.info("Failed to get graph")
                    deferred_graphUrl.reject("Error #{status}")


                deferred_graphUrl.promise





            getExternalUrl: (baseUrl, queryParams) ->
                extractRegex = /(.*gratia)\/.*\/(.*)/

                # Extract the components from the URL
                # Example URL:
                # http://gratiaweb.grid.iu.edu/gratia/bar_graphs/vo_hours_bar_smry
                # needs to be:
                # http://gratiaweb.grid.iu.edu/gratia/xml/vo_hours_bar_smry
                extractedUrl = baseUrl.match(extractRegex)
                if (extractedUrl?)
                    reconstructedUrl = extractedUrl[1] + "/xml/" + extractedUrl[2]
                    # Now add the query params
                    @_createURL reconstructedUrl, queryParams

