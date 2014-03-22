
settings = angular.module 'osgUsageApp.settings', []


settings.service 'settingsService',
  class Settings
    constructor: -> 
        @getSettings()

    getSettings: ->
        chrome.storage.sync.get 'settings', (items) =>
            if ( ! items.settings? )
                items.settings = []
            @settings = items.settings
    
    syncSettings: ->
        chrome.storage.sync.set 'settings', @settings

    getProfiles: ->
        @settings.profiles
        
    getProfile: (profileId) ->
        if ( @settings.profiles? )
            if ( @settings.profiles[profileId]? )
                @settings.profiles[profileId]
            else
                null
        else
            null

    addProfile: (profile) ->
        if ( ! @settings.profiles?)
            @settings.profiles = []
        @settings.profiles[profile.id] = profile

    removeProfile: (profile_name) ->
        delete @settings.profiles[profile_name]

    removeProfiles: ->
        delete @settings.profiles
    


    


