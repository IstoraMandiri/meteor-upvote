Posts = new Meteor.Collection 'posts'

if Meteor.isClient

  Handlebars.registerHelper 'humanDate', (date) -> moment(date).fromNow()

  Template.content.loggedIn = -> Meteor.userId
  
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

  Template.content.posts = -> Posts.find({},{sort:{points:-1}})

  Template.post.events = 
    'click .up, click .down' : (event) ->
      Posts.update @_id, 
        $inc:
          points: if $(event.target).hasClass('up') then 1 else -1
