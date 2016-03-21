module.exports = (System) ->
  globals:
    public:
      streamItem: 'kerplunk-stream:streamItem'
      streamItems:
        'kerplunk-stream:streamItem': 'Stream Item'
        'kerplunk-stream:streamItem2': 'Stream Item 2'
      streamTypes:
        'kerplunk-stream:stream':
          description: 'Stream! (recent posts)'
          sort: 'desc'
          optionsComponent: 'kerplunk-stream:chooseStreamItem'
      css:
        'kerplunk-stream:streamItem': 'kerplunk-stream/css/streamitem.css'
        'kerplunk-stream:streamItem2': 'kerplunk-stream/css/streamitem2.css'
        'kerplunk-stream:avatar': 'kerplunk-stream/css/streamitem.css'
