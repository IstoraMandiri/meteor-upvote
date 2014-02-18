Posts = new Meteor.Collection 'posts'

if Meteor.isClient

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