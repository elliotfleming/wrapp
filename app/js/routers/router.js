// Generated by CoffeeScript 1.6.3
(function() {
  var Router;

  window.app = window.app || {};

  Router = Backbone.Router.extend({
    routes: {
      'filter': 'setFilter'
    },
    setFilter: function() {
      return console.log('setFilter()');
    }
  });

  window.app.router = new Router();

  Backbone.history.start();

  console.log('___THE APP___');

  console.log(window.app);

}).call(this);