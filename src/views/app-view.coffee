# views/app-view.coffee

window.app = window.app || {}

window.app.AppView = Backbone.View.extend

    el: '#content'

    events:
        'click .facebook-auth-button': 'auth'
        'click #pagination-back-button': 'pageBack'
        'click #pagination-forward-button': 'pageForward'
        'keyup #search-friends': 'searchFriends'

    initialize: ->

        @$authContainer       = $ '.auth'
        @$authButton          = $ '.facebook-auth-button'
        @$friendList          = $ '.friends-list'
        @$filterContainer     = $ '.filters'
        @$search              = $ '#search-friends'
        @$paginationContainer = $ '.pagination-container'
        @$paginationInfo      = $ '.pagination-info'
        @$paginationBack      = $ '#pagination-back-button'
        @$paginationForward   = $ '#pagination-forward-button'

        @listenTo window.app.facebook, 'facebookStatusChange', @updateAuth
        @listenTo window.app.facebook, 'isLoggedIn',           @getData
        @listenTo window.app.friends,  'reset',                @resetFriendList
        @listenTo window.app.page,     'pageUpdate',           @resetFriendList
        @listenTo window.app.friends,  'all',                  @render

    render: ( event ) ->
        # Nothing to render yet
        return
    
    showFriend: ( friend ) ->

        friendView = new window.app.FriendView { model: friend }
        @$friendList.append friendView.render().el
        return

    resetFriendList: ->

        if window.app.filteredCollection? and window.app.filteredCollection.models.length isnt window.app.friends.models.length
            console.log window.app.filteredCollection
            window.app.page.updatePageInfo window.app.filteredCollection
            collection = window.app.filteredCollection
        else
            window.app.page.updatePageInfo window.app.friends
            collection = window.app.friends
        
        paginated = collection.slice window.app.page.info.start, window.app.page.info.finish
        
        @$paginationInfo.html window.app.page.info.currentPage + ' / ' + window.app.page.info.totalPages

        if window.app.page.info.currentPage is 1
            @$paginationBack.addClass 'disabled'
        else if @$paginationBack.hasClass 'disabled'
            @$paginationBack.removeClass 'disabled'

        if window.app.page.info.currentPage is window.app.page.info.totalPages
            @$paginationForward.addClass 'disabled'
        else if @$paginationForward.hasClass 'disabled'
            @$paginationForward.removeClass 'disabled'

        @$friendList.empty()
        _.each paginated, @showFriend, @
        return

    getData: ( callback ) ->

        if !$.trim @$friendList.html()
            window.app.friends.fetch
                success: ( collection, response, options ) ->
                    #console.log '___FACEBOOK FRIENDS LIST___'
                    #console.log response
                error: ( response ) ->
                    console.log 'Facebook query error'
                reset: true
        return

    searchFriends: ( e ) ->

        e.preventDefault() if e.which == 13
        searchText = @$search.val()
        window.app.filteredCollection = window.app.friends.search searchText
        window.app.page.trigger 'pageUpdate', window.app.filteredCollection
        window.app.page.reset()
        return

    pageBack: ( e ) ->

        e.preventDefault()
        window.app.page.info.currentPage--
        window.app.page.trigger 'pageUpdate'

    pageForward: ( e ) ->

        e.preventDefault()
        window.app.page.info.currentPage++
        window.app.page.trigger 'pageUpdate'

    updateAuth: ( response ) ->

        if response.status is 'connected'
            @$authButton.html '<i class="icon-signout"></i> Logout'
            window.app.facebook.isLoggedIn = true
            window.app.facebook.trigger 'isLoggedIn'
        else 
            @$authButton.html '<i class="icon-facebook-sign"></i> Sign In with Facebook'
            window.app.facebook.isLoggedIn = false
        return

    auth: ( e ) ->

        e.preventDefault()
        if window.app.facebook.isLoggedIn is true
            window.FB.logout()
        else
            window.FB.login null, {scope: 'friends_photos, user_friends, user_photos'}
        return
