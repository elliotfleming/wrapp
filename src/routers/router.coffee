# routers/router.coffee

window.app = window.app || {}

Router = Backbone.Router.extend

    routes:
        'filter': 'setFilter'

    setFilter: ->
        console.log 'setFilter()'

window.app.router = new Router()
Backbone.history.start()

console.log '___THE APP___'
console.log window.app
