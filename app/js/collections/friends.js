// Generated by CoffeeScript 1.6.3
(function() {
  var Friends;

  window.app = window.app || {};

  Friends = Backbone.Collection.extend({
    model: window.app.Friend,
    url: '/me?fields=picture,friends.limit(10).fields(id,name,gender,devices,picture)',
    sync: function(method, model, options) {
      return window.FB.api(model.url, function(response) {
        if (!response || response.error) {
          options.error(response);
          return;
        }
        console.log('___FACEBOOK GRAPH DATA___');
        console.log(response);
        options.success(response.friends.data, response, options);
      });
    },
    comparator: function(friend) {
      return friend.get('name');
    },
    pagination_defaults: {
      page: 1,
      currentPage: 1,
      perPage: 10
    },
    updatePageInfo: function() {
      var finish, info, numberOfFriends, numberOfPages, start;
      numberOfFriends = this.models.length;
      numberOfPages = Math.ceil(numberOfFriends / this.pagination_defaults.perPage);
      start = this.pagination_defaults.page * 10 !== 10 ? (this.pagination_defaults.page - 1) * 10 : 0;
      finish = this.pagination_defaults.page * 10;
      info = {
        totalFriends: numberOfFriends,
        totalPages: numberOfPages,
        start: start,
        finish: finish
      };
      this.page = info;
      return this.page;
    }
  });

  window.app.friends = new Friends();

}).call(this);
