Posts = new Meteor.Collection 'posts'

if Meteor.isClient
  
  Meteor.subscribe 'allPosts', -> Session.set 'loadedPosts', true

  Handlebars.registerHelper 'humanDate', (date) -> moment(date).fromNow()

  Template.content.helpers
    loggedIn : -> Meteor.userId
 
  
  Template.submit_post.events =
    'submit' : (event, template) -> 
      event.preventDefault()
      
      Posts.insert
        url : "http://"+template.find("input[name=url]").value
        title : template.find("input[name=title]").value
        submitter : Meteor.user().emails[0].address
        createdAt: new Date()
        points: 0

      template.find('form').reset()

  Template.content.helpers
    loadedPosts: -> Session.equals 'loadedPosts', true
    posts : -> Posts.find({},{sort:{points:-1}})

  Template.post.helpers
    isAdmin : -> Meteor.user()?.profile?.isAdmin
    editingThisPost: -> Session.equals 'editingPost', @_id

  Template.post.events = 
    'click .up, click .down' : (event) ->
      Posts.update @_id, 
        $inc:
          points: if $(event.target).hasClass('up') then 1 else -1

    'click .edit' : -> Session.set 'editingPost', @_id

    'click .stop-edit': -> Session.set 'editingPost', null

    'keyup input, change input' : (event) ->
      value = if $(event.target).attr('type') is 'number' then parseInt($(event.target).val()) else $(event.target).val()
      update = {} 
      update[$(event.target).attr('name')] = value
      Posts.update @_id,
        $set:update
           


if Meteor.isServer

  Meteor.startup ->
    Meteor.users.update {'emails.0.address':'chris@test.com'},
      $set: {'profile.isAdmin':true}

  Meteor.publish 'allPosts', -> Posts.find({},{sort:{points:-1}})

