
settings = angular.module 'osgUsageApp.settings', []


settings.service 'settingsService',
  class Settings
    constructor: (@$q, @$log) -> 
        @settings_defer = @$q.defer()
        @notify_list = new Array()
        @getSettings()

    getSettings: ->
        chrome.storage.sync.get 'settings', (items) =>
            if ( ! items.settings? )
                chrome.storage.local.get 'settings', (items) =>
                    if ( ! items.settings? )
                        items.settings = []
                        @settings_defer.resolve()
                    else
                        @settings = items.settings
                        @settings_defer.resolve()
            else
                @settings = items.settings
                @settings_defer.resolve()

    
    addNotify: (toCallback)->
        # Function that users can call to capture changes in the configuration
        # Callback has no parameters
        @notify_list.push toCallback
    
    syncSettings: ->
        chrome.storage.sync.set {settings: @settings}, () =>
            if (chrome.runtime.lastError?)
                @$log.error("Error setting settings: #{chrome.runtime.lastError}")
        chrome.storage.local.set {settings: @settings}, () =>
            if (chrome.runtime.lastError?)
                @$log.error("Error setting settings: #{chrome.runtime.lastError}")
        for func in @notify_list
            func()

    getProfiles: ->
        profile_defer = @$q.defer()
        @settings_defer.promise.then () =>
            profile_defer.resolve(@settings.profiles)
        profile_defer.promise
        
    getProfile: (profileId) ->
        if ( @settings.profiles? )
            if ( @settings.profiles[profileId]? )
                @settings.profiles[profileId]
            else
                null
        else
            null
        
            
    getDefaultProfile: () ->
        defaultProfile_defer = @$q.defer()
        @settings_defer.promise.then () =>
            if ( @settings.default_profile? )
                if @settings.profiles[@settings.default_profile]?
                    @settings.profiles[@settings.default_profile]
                else
                    null
            else
                null
        defaultProfile_defer.promise


    addProfile: (profile) ->
        if ( ! @settings.profiles?)
            @settings.profiles = []
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
    


    


