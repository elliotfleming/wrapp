# collections/friends.coffee

window.app = window.app || {}

Friends = Backbone.Collection.extend
    
    model: window.app.Friend

    comparator: ( friend ) ->
        return friend.get 'name'

    pagination_defaults:
        page: 1
        currentPage: 1
        perPage: 10

    updatePageInfo: ->
        numberOfFriends = @models.length
        numberOfPages   = Math.ceil numberOfFriends / @pagination_defaults.perPage
        start           = if ( @pagination_defaults.page * 10 isnt 10 ) then ( ( @pagination_defaults.page - 1 ) * 10 ) else 0
        finish          = @pagination_defaults.page * 10

        info =
            totalFriends: numberOfFriends
            totalPages: numberOfPages
            start: start
            finish: finish

        @page = info
        return @page

window.app.friends = new Friends()
