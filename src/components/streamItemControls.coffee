_ = require 'lodash'
React = require 'react'

{DOM} = React

formatDuration = (duration) ->
  if duration < 60
    str = "<1m"
  else if duration < 60*60
    str = Math.round(duration/60)+"m"
  else if duration < 60*60*24
    str = Math.round(duration/60/60)+"h"
  else if duration < 60*60*24*30
    str = Math.round(duration/60/60/24)+"d"
  else
    d = new Date(Date.now() - duration*1000)
    str = (d.getMonth()+1) + "/" + d.getDate()
    if d.getFullYear() != (new Date()).getFullYear()
      str += "/" + d.getFullYear()
  " #{str} "


module.exports = React.createFactory React.createClass
  getInitialState: ->
    timeAgo: null # formatDuration @getTimeAgo()

  componentDidMount: ->
    @setState
      timeAgo: formatDuration @getTimeAgo()
    @refresh()

  componentWillUnount: ->
    clearTimeout @refreshTimeout if @refreshTimeout

  getTimeAgo: ->
    ctime = Date.now() / 1000
    intPostedAt = Date.parse(@props.item.postedAt) / 1000
    diff = ctime - intPostedAt

  refresh: ->
    @refreshTimeout = setTimeout =>
      @setState
        timeAgo: formatDuration @getTimeAgo()
    , @getTimeAgo() / 60

  render: ->
    components = []
    controls = @props.globals.public.activityItem?.controls ? {}
    for componentPath, v of controls
      components.push @props.getComponent componentPath

    DOM.div
      className: 'stream-item-controls'
    ,
      DOM.span
        className: 'stream-item-time-ago time-ago'
      , @state.timeAgo
      DOM.a
        className: 'stream-item-control'
        href: "/admin/item/#{@props.item._id}/show"
      , '#'
      _.map components, (Component, index) =>
        Component _.extend {}, @props,
          key: "ctrl-#{@props.item._id}-#{index}"
      # a
      #   className: 'stream-item-control btn-like'
      #   href: "/admin/item/like/#{@props.item._id}"
      # ,
      #   DOM.em
      #     className: 'glyphicon glyphicon-thumbs-up'
      #   , ''
      # a
      #   className: 'stream-item-control btn-dislike'
      #   href: "/admin/item/dislike/#{@props.item._id}"
      # ,
      #   DOM.em
      #     className: 'glyphicon glyphicon-thumbs-down'
      #   , ''
      DOM.a
        className: 'stream-item-control btn-expand'
        href: '#'
        onClick: @props.onExpand
      ,
        DOM.em
          className: 'glyphicon glyphicon-chevron-down'
        , ''
      DOM.a
        className: 'stream-item-control btn-collapse'
        href: '#'
        onClick: @props.onCollapse
      ,
        DOM.em
          className: 'glyphicon glyphicon-chevron-up'
        , ''
