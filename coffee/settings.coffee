
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

    addProfile: (profile) ->
        if ( ! @settings.profiles?)
            @settings.profiles = []
        @settings.profiles[profile.name] = profile

    removeProfile: (profile_name) ->
        delete @settings.profiles[profile_name]

    removeProfiles: ->
        delete @settings.profiles
    


    


