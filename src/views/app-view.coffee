# views/app-view.coffee

window.app = window.app || {}

window.app.AppView = Backbone.View.extend

    el: '#content'

    events:
        'click .facebook-auth-button': 'auth'

    initialize: ->
        @$authContainer = $ '.auth'
        @$authButton    = $ '.facebook-auth-button'
        @$friendList    = $ '.friends-list'

        @listenTo window.app.facebook, 'facebookStatusChange', @updateAuth
        @listenTo window.app.friends, 'add', @showFriend
        @listenTo window.app.friends, 'reset', @resetFriendList
    
    render: ->
        # Nothing to render in this view, yet...
        return
    
    showFriend: ( friend ) ->
        view = new window.app.FriendView { model: friend }
        @$friendList.append view.render().el
        return

    resetFriendList: ->
        @$friendList.empty()
        window.app.friends.updatePageInfo()
        paginated = window.app.friends.slice window.app.friends.page.start, window.app.friends.page.finish
        _.each paginated, @showFriend, @
        return

    getData: ( callback ) ->
        query = '/me?fields=picture,friends.limit(10).fields(id,name,gender,devices,picture)'
        window.FB.api(query, (response) ->
            console.log '___FACEBOOK GRAPH DATA___'
            console.log response
            window.app.friends.reset response.friends.data
            return
        )
        return

    updateAuth: ( response ) ->
        if response.status is 'connected'
            @$authButton.html '<i class="icon-signout"></i> Logout'
            window.app.facebook.isLoggedIn = true
            @getData() if !$.trim @$friendList.html()
        else 
            @$authButton.html '<i class="icon-facebook-sign"></i> Sign In with Facebook'
            window.app.facebook.isLoggedIn = false
        return

    auth: ( e ) ->
        e.preventDefault()
        console.log 'auth()'
        if window.app.facebook.isLoggedIn is true
            console.log 'Log Out'
            window.FB.logout()
        else
            console.log 'Log In'
            window.FB.login null, {scope: 'friends_photos, user_friends, user_photos'}
        return
