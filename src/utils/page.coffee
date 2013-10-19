# utils/page.coffee

window.app = window.app || {}

window.app.page =

    searchText: ''

    sorting:
        sortAttribute: 'name'
        sortDirection: 1

    page_defaults:
        currentPage: 1
        perPage: 10

    reset: ->
        return if not @info?
        @info.currentPage = 1

    updatePageInfo: ( collection ) ->

        perPage      = if @info? then @info.perPage else @page_defaults.perPage
        totalFriends = collection.models.length
        totalPages   = Math.ceil totalFriends / perPage
        currentPage  = if @info? then @info.currentPage else @page_defaults.currentPage
        currentPage  = if totalFriends then currentPage else 0
        start        = if currentPage * perPage isnt perPage then ( currentPage - 1 ) * perPage else 0
        finish       = currentPage * perPage

        @info =
            totalFriends : totalFriends
            totalPages   : totalPages
            currentPage  : currentPage
            perPage      : perPage
            start        : start
            finish       : finish

window.app.page = _.extend window.app.page, Backbone.Events
