# utils/page.coffee

window.app = window.app || {}

window.app.page =

    searchText: ''

    sorting:
        sortAttribute: 'name'
        sortDirection: 1

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
        currentPage  = if totalFriends then currentPage else 0
        start        = if currentPage * 10 isnt 10 then ( currentPage - 1 ) * 10 else 0
        finish       = currentPage * 10

        @info =
            totalFriends: totalFriends
            totalPages: totalPages
            currentPage: currentPage
            start: start
            finish: finish

window.app.page = _.extend window.app.page, Backbone.Events
