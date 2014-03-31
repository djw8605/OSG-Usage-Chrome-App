
settings = angular.module 'osgUsageApp.settings', []


settings.service 'settingsService',
  class Settings
    constructor: (@$q, @$log, @$rootScope) -> 
        @settings_defer = @$q.defer()
        @notify_list = new Array()
        @getSettings()

    getSettings: ->
        chrome.storage.sync.get 'settings', (items) =>
            if ( ! items.settings? )
                chrome.storage.local.get 'settings', (items) =>
                    if ( ! items.settings? )
                        @$rootScope.$apply () =>
                            @settings = {}
                            @$rootScope.settings = @settings
                            @settings_defer.resolve()
                            @$log.info("new settings")
                    else
                        @$rootScope.$apply () =>
                            @settings = angular.fromJson(items.settings)
                            @$rootScope.settings = @settings
                            @settings_defer.resolve()
                            @$log.info("from local: Settings = #{items.settings}")
            else
                @$rootScope.$apply () =>
                    @settings = angular.fromJson(items.settings)
                    @$rootScope.settings = @settings
                    @settings_defer.resolve()
                    @$log.info("from sync: Settings = #{items.settings}")
            
                
        @settings_defer.promise.then () =>
            @$rootScope.$watch('settings', @settingsChange, true)
        
    
    settingsChange: (newValue, oldValue) =>
        @$log.info("Settings changed:")
        @$log.info("Old:")
        @$log.info(oldValue)
        @$log.info("New Value:")
        @$log.info(newValue)
        @$log.info("Syncing settings...")
        @syncSettings()
    
    addNotify: (toCallback)->
        # Function that users can call to capture changes in the configuration
        # Callback has no parameters
        @notify_list.push toCallback
    
    syncSettings: ->
        json_string = angular.toJson(@settings)
        chrome.storage.sync.set {settings: json_string}, () =>
            if (chrome.runtime.lastError?)
                @$log.error("Error setting settings: #{chrome.runtime.lastError}")
            else
                @$log.info("Saving to sync was successful!")
        chrome.storage.local.set {settings: json_string}, () =>
            if (chrome.runtime.lastError?)
                @$log.error("Error setting settings: #{chrome.runtime.lastError}")
            else
                @$log.info("Saving to local was successful!")
        
        for func in @notify_list
            func()

    getProfiles: ->
        profile_defer = @$q.defer()
        @settings_defer.promise.then () =>
            profile_defer.resolve(@settings.profiles)
        profile_defer.promise
        
    getProfile: (profileId) ->
        profile_defer = @$q.defer()
        @settings_defer.promise.then () =>
            if ( @settings.profiles? )
                if ( @settings.profiles[profileId]? )
                    profile_defer.resolve(@settings.profiles[profileId])
                else
                    profile_defer.resolve(null)
            else
                profile_defer.resolve(null)
                
        profile_defer.promise
        
            
    getDefaultProfile: () ->
        defaultProfile_defer = @$q.defer()
        @settings_defer.promise.then () =>
            if ( @settings.default_profile? )
                if @settings.profiles[@settings.default_profile]?
                    defaultProfile_defer.resolve(@settings.profiles[@settings.default_profile])
                else
                    defaultProfile_defer.reject("Default Profile (#{@settings.default_profile}) doest not exist in list of profiles")
            else
                defaultProfile_defer.reject("No default profile defined")
                
        defaultProfile_defer.promise


    addProfile: (profile) ->
        if ( ! @settings.profiles?)
            @settings.profiles = {}
        @settings.profiles[profile.id] = profile
        @settings.default_profile = profile.id
        @syncSettings()


    removeProfile: (profile_name) ->
        delete @settings.profiles[profile_name]
        @syncSettings()

    removeProfiles: ->
        delete @settings.profiles
        delete @settings.default_profile
        @syncSettings()
    


    


