React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    identity = @props.identity ? {}
    photoUrl = if identity.photo?.length > 0
      identity.photo[identity.photo.length - 1]?.url
    photoUrl = '/images/kerplunk/logo_t.png' unless photoUrl?.length > 0

    platform = identity.platform?[0] ? identity.platform
    sourceIcon = @props.sourceIcon
    unless sourceIcon
      sourceIcon = @props.globals?.public?.activityItem?.icons?[platform]

    DOM.div
      className: 'img avatar-holder'
    ,
      DOM.a
        onClick: @props.pushState
        href: "/admin/identity/view/#{identity._id}"
      ,
        DOM.div
          className: 'avatar stream-item-avatar'
          style:
            position: 'absolute'
        ,
          DOM.img
            src: photoUrl
        DOM.img
          style:
            display: ('none' unless sourceIcon)
          className: 'stream-item-source-icon'
          src: sourceIcon ? ''
