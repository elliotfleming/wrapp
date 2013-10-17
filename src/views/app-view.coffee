# views/app-view.coffee

window.app = window.app || {}

window.app.AppView = Backbone.View.extend

    el: '#content'

    events:
        'click .facebook-auth-button': 'auth'

    initialize: ->

        @$authContainer = $ '.auth'
        @$authButton    = $ '.facebook-auth-button'

        @listenTo window.app.facebook, 'facebookStatusChange', @updateAuth
        @listenTo window.app.friends, 'add', @addOne
        @listenTo window.app.friends, 'reset', @addAll
    
    render: ->
        # Nothing to render in this view, yet...
        return
    
    addOne: ( friend ) ->
        view = new window.app.FriendView { model: friend }
        $('.friends-list').append view.render().el
        return

    addAll: ->
        console.log 'addAll()'
        @$('.friend-list').empty()
        paginated = window.app.friends.slice 0, 10
        console.log paginated
        _.each paginated, @addOne, @
        return

    getData: ( callback ) ->
        query = '/me?fields=picture,friends.limit(10).fields(id,name,gender,devices,picture)'
        window.FB.api(query, (response) ->
            console.log response
            window.app.friends.reset response.friends.data
            return
        )
        return

    updateAuth: ( response ) ->

        if response.status is 'connected'
            $('.facebook-auth-button').html '<i class="icon-signout"></i> Logout'
            @getData()
        else 
            $('.facebook-auth-button').html '<i class="icon-facebook-sign"></i> Sign In with Facebook'
        return

    auth: ( e ) ->
        e.preventDefault()
        console.log 'auth()'
        return
