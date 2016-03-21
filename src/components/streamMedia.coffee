_ = require 'lodash'
React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    return {} unless @props.media?.length > 0
    # console.log 'media', @props.media
    image = ""
    imageWidth = 1
    imageHeight = 1
    maxWidth = 400
    maxHeight = 340
    #photos = _.filter @props.media, (m) -> m.type == 'photo'
    photos = @props.media
    photo = photos[0]
    sizes = _.sortBy photo.sizes, (size) ->
      if size.width > maxWidth
        -maxWidth / size.width
      else
        -size.width / maxWidth

    imageWidth = sizes[0].width
    imageHeight = sizes[0].height

    if imageWidth > maxWidth
      imageHeight *= maxWidth / imageWidth
      imageWidth = maxWidth
    if imageHeight > maxHeight
      imageWidth *= maxHeight / imageHeight
      imageHeight = maxHeight

    url: sizes[0].url
    width: imageWidth
    height: imageHeight

  render: ->
    if @props.media?.length > 0
      DOM.div
        className: 'stream-item-media'
      ,
        DOM.img
          src: @state.url
          style: unless @props.nosize
            width: @state.width
            height: @state.height
    else
      DOM.div
        style:
          display: 'none'
