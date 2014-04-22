define ['angular', 'angular-resource', 'settings' ], () ->


    profileModule = angular.module 'osgUsageApp.profileService', [ 'osgUsageApp.settings', 'ngResource' ]


    profileModule.service 'profileService',
      class ProfileService
        @$inject = [ '$q', '$log', 'settingsService', '$resource' ]
        constructor: (@$q, @$log, @settingsService, @$resource) ->
            @weburl = ""


        getProfile: (profileId) ->

            getProfile_defer = @$q.defer()

            # First, check if the profile is in the settings
            @settingsService.getProfile(profileId).then (profile) =>
                if (profile != null)
                    getProfile_defer.resolve(profile)
                else
                    # Now try to get the profile from the webservice
                    downloaded_profile = $resource("/profile/#{profileId}").get {}, =>

                        $log.info("Got profile from webservice")
                        $log.info(downloaded_profile)

                        profile = JSON.parse(downloaded_profile.profile_json)
                        profile.id = downloaded_profile.id
                        getProfile_defer.resolve(profile)
                    , =>
                        $log.info("error getting profile from websrevice")
                        getProfile_defer.reject()

            return getProfile_defer.promise
