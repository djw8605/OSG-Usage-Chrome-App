define ['../js/angular'], () ->
    
    
    class Graph
        constructor: (@graphData, @$http, @$log) -> 
            @queryParams = []
            
        getImageUrl: ->
            # In a chrome app, we need to pull down the images and save to disk
            
            
        setParams: (values)->
            @queryParams[key] = value for key, value of values 
            
            