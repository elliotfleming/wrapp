# collections/friends.coffee

window.app = window.app || {}

Friends = Backbone.Collection.extend
    
    model: window.app.Friend

    comparator: ( friend ) ->
        return friend.get 'name'

    pagination:
        page: 1
        perPage: 10

window.app.friends = new Friends()
