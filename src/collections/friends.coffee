# collections/friends.coffee

window.app = window.app || {}

window.app.Friends = Backbone.Collection.extend
    
    model: window.app.Friend

    url: '/me?fields=picture,friends.fields(id,name,gender,devices,picture)'

    #comparator: ( friend ) ->
    #    return friend.get 'name'

    sortAttribute: 'name'
    sortDirection: 1

    comparator: ( a, b ) ->
        a = a.get @sortAttribute
        b = b.get @sortAttribute

        return 0 if a is b

        if @sortDirection is 1
            return if a > b then 1 else -1
        else
            return if a < b then 1 else -1

    sync: ( method, model, options) ->
        
        window.FB.api model.url, ( response ) ->
            if not response or response.error
                options.error response
                return
            console.log '___FACEBOOK GRAPH DATA___'
            console.log response
            options.success response.friends.data, response, options
            return

    sortFriends: ( attribute ) ->

        @sortAttribute = attribute
        @sort()

    search: ( searchText ) ->

        pattern = new RegExp( searchText, 'i' )
        filtered = @filter ( friend ) ->
            pattern.test friend.get('name')
        new window.app.Friends filtered

window.app.friends = new window.app.Friends()
