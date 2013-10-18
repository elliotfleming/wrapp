# views/app-view.coffee

window.app = window.app || {}

window.app.AppView = Backbone.View.extend

    el: '#content'

    events:
        'click #facebook-auth-button' : 'auth'
        'keyup #search-friends'       : 'searchFriends'
        'click .pagination-button'    : 'navigate'
        'click .alpha-sort-button'    : 'alphaSort'

    initialize: ->

        @$auth              = $ '.auth'
        @$authButton        = $ '#facebook-auth-button'
        @$friendList        = $ '#friends-list'
        @$filters           = $ '#filters'
        @$search            = $ '#search-friends'
        @$pagination        = $ '#pagination'
        @$paginationInfo    = $ '#pagination-info'
        @$paginationBack    = $ '#pagination-back-button'
        @$paginationForward = $ '#pagination-forward-button'
        @$sortAZ            = $ '#alpha-sort-az'
        @$sortZA            = $ '#alpha-sort-za'

        @listenTo window.app.facebook, 'facebookStatusChange', @updateAuth
        @listenTo window.app.facebook, 'isLoggedIn',           @getData
        @listenTo window.app.page,     'pageUpdate',           @render
        @listenTo window.app.friends,  'reset',                @render

    render: ( collection ) ->

        if window.app.friends? and window.app.friends.length

            if not $('.user-profile-picture').length and window.app.facebook.graph
                $('<img/>', {class: 'user-profile-picture img-rounded', src: window.app.facebook.graph.picture.data.url, width: '40', height: '40'}).appendTo @$auth
            
            $('.loading-container').remove() if $('.loading-container').length

            @$filters.show()

            if collection
                collection = collection
            if window.app.filteredCollection? and window.app.filteredCollection.length isnt window.app.friends.length
                collection = window.app.filteredCollection
            else
                collection = window.app.friends

            window.app.page.updatePageInfo collection
            collection.sortDirection = window.app.page.sorting.sortDirection
            collection.sortFriends window.app.page.sorting.sortAttribute
            
            paginated = collection.slice window.app.page.info.start, window.app.page.info.finish
            @$paginationInfo.html window.app.page.info.currentPage + ' / ' + window.app.page.info.totalPages

            if window.app.page.info.currentPage < 2
                @$paginationBack.addClass 'disabled'
            else if @$paginationBack.hasClass 'disabled'
                @$paginationBack.removeClass 'disabled'
            if window.app.page.info.currentPage is window.app.page.info.totalPages
                @$paginationForward.addClass 'disabled'
            else if @$paginationForward.hasClass 'disabled'
                @$paginationForward.removeClass 'disabled'

            @$friendList.empty()
            if paginated.length
                _.each paginated, @showFriend, @
            else
                $('<a/>', {class: 'list-group-item text-center', html: '<span><i class="icon-frown"></i> No Matches</span>'}).appendTo @$friendList

        else
            $('.user-profile-picture').remove()
            @$friendList.empty()
            @$filters.hide()
        return
    
    showFriend: ( friend ) ->

        friendView = new window.app.FriendView { model: friend }
        @$friendList.append friendView.render().el
        return

    getData: ( callback ) ->

        if !$.trim @$friendList.html()

            $loadingContainer = $('<div/>', {class: 'loading-container text-center'}).appendTo '#content'
            $loadingSpinner = $('<i/>', {class: 'icon-cog icon-spin icon-4x text-primary'}).appendTo $loadingContainer

            window.app.friends.fetch
                success: ( collection, response, options ) ->
                    window.app.facebook.graph = options.facebookResponse
                error: ( response ) ->
                    console.log 'Facebook query error'
                reset: true
        return

    searchFriends: ( e ) ->

        e.preventDefault() if e.which == 13

        searchText = @$search.val()
        window.app.filteredCollection = window.app.friends.search searchText

        window.app.page.reset()
        window.app.page.trigger 'pageUpdate'
        return

    navigate: ( e ) ->

        e.preventDefault()
        thisNavButton = $ e.currentTarget

        if thisNavButton.is '#pagination-back-button'
            window.app.page.info.currentPage--
        else
            window.app.page.info.currentPage++

        window.app.page.trigger 'pageUpdate'
        return

    alphaSort: ( e ) ->

        e.preventDefault()
        thisSortButton = $ e.currentTarget

        return if thisSortButton.hasClass 'active'
        $( '.alpha-sort-button' ).removeClass 'active'
        thisSortButton.addClass 'active'

        asc = if thisSortButton.is '#alpha-sort-az' then true else false
        window.app.page.sorting.sortDirection = if asc is true then 1 else -1

        window.app.page.reset()
        window.app.page.trigger 'pageUpdate'
        return

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
            window.FB.logout ( response ) ->
                window.location.reload(true)
        else
            window.FB.login null, {scope: 'friends_photos, user_friends, user_photos'}
        return
