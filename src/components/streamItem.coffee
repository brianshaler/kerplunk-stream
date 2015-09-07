_ = require 'lodash'
React = require 'react'
ReactiveData = require 'reactive-data'

Avatar = require './avatar'
# Media = require './streamMedia'
StreamItemControls = require './streamItemControls'

{DOM} = React

linkUrls = (message) ->
  maxLength = 34
  matches = message.match /https?:\/\/[-A-Za-z0-9+&@#\/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#\/%=~_()|]/gi
  if matches
    for url in matches
      # Keep the matched URL to use in href, but create a truncated version to display
      shorter = url
      shorter = shorter.replace /^http:\/\//, ""
      shorter = shorter.replace /^https:\/\//, ""
      shorter = shorter.replace /^www\./, ""
      if shorter.length > maxLength
        shorter = shorter.substring(0, maxLength-4) + "..."
      # Replace instance of matched URL with HTML
      message = message.replace url, "<a href='#{url}' title='#{url}' class='truncate-link'>#{shorter}</a>"
  message

# Turn hashtags into links
linkHashtags = (message) ->
  hashPattern = /(^|\s)#([-A-Za-z0-9_]+)(\b)/gi
  message.replace hashPattern, "$1<a href='/topic/bytext/$2'>#$2</a>$3"

# Turn @names into links
linkScreenNames = (message) ->
  atPattern = /(^|\s|[^a-zA-Z0-9_\-+])@([-A-Za-z0-9_]+)(\b|\s|[^a-zA-Z0-9]|$)/gi
  message.replace atPattern, "$1<a href='/identity/byusername/$2'>@$2</a>$3"

module.exports = React.createFactory React.createClass
  getInitialState: ->
    # console.log 'initial props on streamItem', @props
    itemId = String @props.item?._id ? @props.itemId
    if @props.item?._id
      @props.Repository.update @props.item._id, @props.item
      item = @props.item
    else
      item = @props.Repository.getLatest itemId

    expanded: null
    item: item

  componentDidMount: ->
    @item = ReactiveData.Item
      key: @props.itemId
      Repository: @props.Repository
    @item.listen @, 'item'

  componentWillUnmount: ->
    @item.unlisten @

  parseMessage: (message) ->
    return 'WAT.' unless message?
    linkUrls linkHashtags linkScreenNames message

  onExpand: (e) ->
    console.log 'onExpand'
    e.preventDefault()
    @setState
      expanded: true

  onCollapse: (e) ->
    e.preventDefault()
    @setState
      expanded: false

  render: ->
    return DOM.div null, 'loading ' + @props.itemId unless @state.item?._id
    expanded = if @state.expanded?
      @state.expanded
    else
      if @state.item?.attributes?.score? and @props.threshold?
        @state.item.attributes.score >= @props.threshold
      else
        true

    item = @state.item ? {}
    identity = item?.identity ? {}

    Media = @props.getComponent 'kerplunk-stream:streamMedia'

    DOM.div
      className: "media stream-item #{if expanded then 'expanded' else 'collapsed'}"
      onClick: (@onExpand unless expanded)
    ,
      StreamItemControls _.extend {}, @props,
        item: item
        onExpand: @onExpand
        onCollapse: @onCollapse
      DOM.div
        className: 'bd'
      ,
        Avatar
          identity: item.identity
          sourceIcon: @props.globals.public.activityItem.icons?[item.platform]
        DOM.span
          className: 'stream-item-author'
        ,
          DOM.a
            href: "/admin/identity/view/#{identity._id}"
          ,
            if identity.fullName and identity.fullName != ''
              identity.fullName
            else
              identity.nickName
            if identity.fullName and identity.fullName != '' and identity.fullName.toLowerCase().replace(/\s/g,'') != identity.nickName.toLowerCase().replace(/\s/g,'')
              " (#{identity.nickName})"
        DOM.p
          className: 'stream-item-text'
          dangerouslySetInnerHTML:
            __html: @parseMessage item.message
        Media
          key: "#{item._id}-media"
          media: item.media
