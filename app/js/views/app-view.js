// Generated by CoffeeScript 1.6.3
(function() {
  window.app = window.app || {};

  window.app.AppView = Backbone.View.extend({
    el: '#content',
    events: {
      'click .facebook-auth-button': 'auth'
    },
    initialize: function() {
      this.$authContainer = $('.auth');
      this.$authButton = $('.facebook-auth-button');
      this.$friendList = $('.friends-list');
      this.listenTo(window.app.facebook, 'facebookStatusChange', this.updateAuth);
      this.listenTo(window.app.facebook, 'isLoggedIn', this.getData);
      return this.listenTo(window.app.friends, 'reset', this.resetFriendList);
    },
    render: function() {},
    showFriend: function(friend) {
      var view;
      view = new window.app.FriendView({
        model: friend
      });
      this.$friendList.append(view.render().el);
    },
    resetFriendList: function() {
      var paginated;
      this.$friendList.empty();
      window.app.friends.updatePageInfo();
      paginated = window.app.friends.slice(window.app.friends.page.start, window.app.friends.page.finish);
      _.each(paginated, this.showFriend, this);
    },
    getData: function(callback) {
      if (!$.trim(this.$friendList.html())) {
        window.app.friends.fetch({
          success: function(collection, response, options) {
            console.log('___FACEBOOK FRIENDS LIST___');
            return console.log(response);
          },
          error: function(response) {
            return console.log('Facebook query error');
          },
          reset: true
        });
      }
    },
    updateAuth: function(response) {
      if (response.status === 'connected') {
        this.$authButton.html('<i class="icon-signout"></i> Logout');
        window.app.facebook.isLoggedIn = true;
        window.app.facebook.trigger('isLoggedIn');
      } else {
        this.$authButton.html('<i class="icon-facebook-sign"></i> Sign In with Facebook');
        window.app.facebook.isLoggedIn = false;
      }
    },
    auth: function(e) {
      e.preventDefault();
      console.log('auth()');
      if (window.app.facebook.isLoggedIn === true) {
        console.log('Log Out');
        window.FB.logout();
      } else {
        console.log('Log In');
        window.FB.login(null, {
          scope: 'friends_photos, user_friends, user_photos'
        });
      }
    }
  });

}).call(this);
