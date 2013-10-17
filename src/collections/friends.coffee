# collections/friends.coffee

window.app = window.app || {}

window.app.Friends = Backbone.Collection.extend
    
    model: window.app.Friend

    url: '/me?fields=picture,friends.fields(id,name,gender,devices,picture)'

    comparator: ( friend ) ->
        return friend.get 'name'

    sync: ( method, model, options) ->
        
        window.FB.api model.url, ( response ) ->
            if not response or response.error
                options.error response
                return
            console.log '___FACEBOOK GRAPH DATA___'
            console.log response
            options.success response.friends.data, response, options
            return

    search: ( searchText ) ->

        pattern = new RegExp( searchText, 'i' )
        filtered = @filter ( friend ) ->
            pattern.test friend.get('name')
        new window.app.Friends filtered

window.app.friends = new window.app.Friends()

window.app.page = 

    page_defaults:
        page: 1
        currentPage: 1
        perPage: 10

    reset: ->
        @info.currentPage = 1

    updatePageInfo: ( collection ) ->

        totalFriends = collection.models.length
        totalPages   = Math.ceil totalFriends / @page_defaults.perPage
        currentPage  = if @info? then @info.currentPage else @page_defaults.currentPage
        start        = if currentPage * 10 isnt 10 then ( currentPage - 1 ) * 10 else 0
        finish       = currentPage * 10

        @info =
            totalFriends: totalFriends
            totalPages: totalPages
            currentPage: currentPage
            start: start
            finish: finish

window.app.page = _.extend window.app.page, Backbone.Events
