# views/friend-view.coffee

window.app = window.app || {}

window.app.FriendView = Backbone.View.extend

    tagName: 'a'

    className: 'list-group-item'

    template: _.template $('#friend-template').html()

    initialize: ->

        this.$friendContainer = $ '.friends-container'
        return
    
    render: ->
        this.$el.html this.template this.model.toJSON()
        return this

    
