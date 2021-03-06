// Generated by CoffeeScript 1.6.3
(function() {
  window.app = window.app || {};

  window.app.FriendView = Backbone.View.extend({
    tagName: 'a',
    className: 'list-group-item',
    template: _.template($('#friend-template').html()),
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    }
  });

}).call(this);
