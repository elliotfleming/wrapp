# views/friend-view.coffee

window.app = window.app || {}

window.app.FriendView = Backbone.View.extend

    tagName: 'a'

    className: 'list-group-item'

    template: _.template $('#friend-template').html()

    initialize: ->

        @$friendContainer = $ '.friends-container'
        return
    
    render: ->
        
        @$el.html @template @model.toJSON()
        return @

    
