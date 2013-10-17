# facebook.coffee

window.app = window.app || {}
window.app.facebook = _.extend {}, Backbone.Events

# Facebook Initialization
window.fbAsyncInit = ->
    
    window.FB.init
        appId      : '634167176604683'
        channelUrl : '//' + window.location.hostname + '/channel.html'
        cookie     : true

    console.log '___FACEBOOK SDK___'
    console.log window.FB

    window.app.facebook.trigger 'sdkLoaded'

    window.FB.Event.subscribe 'auth.authResponseChange', (response) ->
        console.info '___FACEBOOK AUTH___'
        console.log response
        window.app.facebook.trigger 'facebookStatusChange', response
        return

# the Facebook JavaScript SDK
((d) ->
    id  = 'facebook-jssdk'
    ref = d.getElementsByTagName('script')[0]
    return if d.getElementById id
    js       = d.createElement('script')
    js.id    = id
    js.async = true
    js.src   = "//connect.facebook.net/en_US/all.js"
    ref.parentNode.insertBefore js, ref
    return
) document
