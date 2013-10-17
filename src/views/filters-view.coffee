# views/pagination-view.coffee

window.app = window.app || {}

window.app.FiltersView = Backbone.View.extend

    tagName: 'div'

    paginationTemplate: _.template $('#pagination-template').html()
    searchTemplate: _.template $('#search-template').html()

    events:
        'click #pagination-back-button': 'pageBack'
        'click #pagination-forward-button': 'pageForward'

    initialize: ->

        @paginationContainerClassName = 'pagination-container'
        @$filtersContainer = $ '.filters'
        return
    
    render: ->

        @$el.addClass(@paginationContainerClassName).html @paginationTemplate window.app.friends.page
        return this

    pageBack: ( e ) ->

        e.preventDefault()
        window.app.friends.page.currentPage--
        window.app.friends.trigger 'pageUpdate'

    pageForward: ( e ) ->

        e.preventDefault()
        window.app.friends.page.currentPage++
        window.app.friends.trigger 'pageUpdate'
