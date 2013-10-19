# views/app-view.coffee

window.app = window.app || {}

( ( app, friends, page, facebook, FriendView ) ->

    app.AppView = Backbone.View.extend

        el: '#content'

        sortingTemplate: _.template $('#sorting-template').html()

        events:
            'click #facebook-auth-button' : 'auth'
            'keyup #search-friends'       : 'searchFriends'
            'click .pagination-button'    : 'navigate'
            'click .alpha-sort-button'    : 'alphaSort'

        initialize: ->

            @$auth       = $ '.auth'
            @$authButton = $ '#facebook-auth-button'
            @$friendList = $ '#friends-list'
            @$filters    = $ '#filters'
            @$sorting    = $ '#sorting'
            @$search     = $ '#search-friends'

            @listenTo facebook, 'facebookStatusChange', @updateAuth
            @listenTo facebook, 'isLoggedIn',           @getData
            @listenTo page,     'pageUpdate',           @render
            @listenTo friends,  'sync',                 @render

        render: ( collection ) ->

            if friends? and friends.length

                if not $('.user-profile-picture').length and facebook.graph
                    $('<img/>', {class: 'user-profile-picture img-rounded', src: facebook.graph.picture.data.url, width: '40', height: '40'}).appendTo @$auth
                
                $('.loading-container').remove() if $('.loading-container').length

                if collection
                    collection = collection
                if app.filteredCollection? and app.filteredCollection.length isnt friends.length
                    collection = app.filteredCollection
                else
                    collection = friends

                page.updatePageInfo collection
                collection.sortDirection = page.sorting.sortDirection
                collection.sortFriends page.sorting.sortAttribute

                paginated = collection.slice page.info.start, page.info.finish

                @$filters.show()
                @$sorting.html @sortingTemplate
                    currentPage: page.info.currentPage
                    totalPages: page.info.totalPages

                $('.alpha-sort-button').removeClass 'active'
                if page.sorting.sortDirection is 1
                    $( '#alpha-sort-az' ).addClass 'active'
                else
                    $( '#alpha-sort-za' ).addClass 'active'

                if page.info.currentPage < 2
                    $( '#pagination-back-button' ).addClass 'disabled'
                else if $( '#pagination-back-button' ).hasClass 'disabled'
                    $( '#pagination-back-button' ).removeClass 'disabled'
                if page.info.currentPage is page.info.totalPages
                     $( '#pagination-forward-button' ).addClass 'disabled'
                else if  $( '#pagination-forward-button' ).hasClass 'disabled'
                     $( '#pagination-forward-button' ).removeClass 'disabled'

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

            friendView = new FriendView { model: friend }
            @$friendList.append friendView.render().el
            return

        getData: ( callback ) ->

            if !$.trim @$friendList.html()

                $loadingContainer = $('<div/>', {class: 'loading-container text-center'}).appendTo '#content'
                $loadingSpinner = $('<i/>', {class: 'icon-cog icon-spin icon-4x text-primary'}).appendTo $loadingContainer

                friends.fetch
                    success: ( collection, response, options ) ->
                        facebook.graph = options.facebookResponse
                    error: ( response ) ->
                        console.log 'Facebook query error'
                    reset: true
            return

        searchFriends: ( e ) ->

            e.preventDefault() if e.which == 13

            searchText = $('#search-friends').val()
            app.filteredCollection = friends.search searchText
            page.searchText = searchText

            page.reset()
            page.trigger 'pageUpdate'
            return

        navigate: ( e ) ->

            e.preventDefault()
            thisNavButton = $ e.currentTarget

            if thisNavButton.is '#pagination-back-button'
                page.info.currentPage--
            else
                page.info.currentPage++

            page.trigger 'pageUpdate'
            return

        alphaSort: ( e ) ->

            e.preventDefault()
            thisSortButton = $ e.currentTarget

            return if thisSortButton.hasClass 'active'

            asc = if thisSortButton.is '#alpha-sort-az' then true else false
            page.sorting.sortDirection = if asc is true then 1 else -1

            page.reset()
            page.trigger 'pageUpdate'
            return

        updateAuth: ( response ) ->

            if response.status is 'connected'
                @$authButton.html '<i class="icon-signout"></i> Logout'
                facebook.isLoggedIn = true
                facebook.trigger 'isLoggedIn'
            else 
                @$authButton.html '<i class="icon-facebook-sign"></i> Sign In with Facebook'
                facebook.isLoggedIn = false
            return

        auth: ( e ) ->

            e.preventDefault()
            if facebook.isLoggedIn is true
                window.FB.logout ( response ) ->
                    window.location.reload(true)
            else
                window.FB.login null, {scope: 'friends_photos, user_friends, user_photos'}
            return

    window.app            = app
    window.app.friends    = friends
    window.app.page       = page
    window.app.facebook   = facebook
    window.app.FriendView = FriendView

) window.app, window.app.friends, window.app.page, window.app.facebook, window.app.FriendView
