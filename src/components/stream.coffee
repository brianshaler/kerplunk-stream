_ = require 'lodash'
React = require 'react'
ReactiveData = require 'reactive-data'

{DOM} = React

module.exports = React.createFactory React.createClass
  getInitialState: ->
    ids = _.compact _.map (@props.data ? []), '_id'

    ids: ids
    latestUpdatedAt: null
    oldestPost: null
    threshold: @props.threshold ? 0

  componentDidMount: ->
    window._stream = @
    @refreshLater()

  componentWillUnmount: ->
    clearTimeout @refreshTimeout
    @refreshTimeout = null

  refreshLater: ->
    clearTimeout @refreshTimeout
    @refreshTimeout = setTimeout =>
      @refresh()
    , 5000

  sortIds: (ids = @state.ids) ->
    return ids unless ids?.length > 0
    _ ids
    .map (id) => @props.Repository.getLatest id
    .sortBy (item) -> -1 * Date.parse item.postedAt
    .map '_id'
    .value()

  refresh: ->
    return unless @isMounted()
    clearTimeout @refreshTimeout if @refreshTimeout
    @refreshTimeout = null
    opt = {}
    url = "/admin/dashboard/stream/#{@props.stream._id}.json"
    if @state.latestUpdatedAt
      opt.updatedSince = @state.latestUpdatedAt
      opt.postedSince = @state.oldestPost

    @props.request.get url, opt, (err, response) =>
      return unless @isMounted()
      if err
        console.log 'error', err
        return @refreshLater()
      items = []
      if response.state.data?.length > 0
        items = response.state.data

      # console.log "received #{items.length} item(s)"
      return @refreshLater() unless items.length > 0

      latestUpdatedAt = 0
      oldestPost = 0
      for item in items
        @props.Repository.update item._id, item
        updatedAt = Date.parse item.updatedAt
        postedAt = Date.parse item.postedAt
        latestUpdatedAt = updatedAt if updatedAt > latestUpdatedAt
        oldestPost = postedAt if oldestPost == 0 or postedAt < oldestPost

      newIds = _.map items, '_id'
      newIds = _.filter newIds, (id) =>
        -1 == @state.ids.indexOf id
      # console.log 'newIds', newIds

      if newIds.length > 0
        @setState
          ids: @sortIds newIds.concat @state.ids

      if latestUpdatedAt > @state.latestUpdatedAt
        @setState
          latestUpdatedAt: latestUpdatedAt
          oldestPost: if !@state.oldestPost? or oldestPost < @state.oldestPost
            oldestPost
          else
            @state.oldestPost

      @refreshLater()

  render: ->
    componentPath = @props.stream.attributes?.streamItem ? @props.globals.public.streamItem
    ItemComponent = @props.getComponent componentPath

    #activityItems = @state.activityItems
    list = _.map @state.ids, (id, index) =>
      ItemComponent _.extend {}, @props, @state,
        itemId: id
        key: "activity-item-#{id}"
    unless list.length > 0
      list = DOM.div null, 'no items'

    DOM.div
      className: 'activityitem-list'
    ,
      list
