module.exports = (System) ->
  globals:
    public:
      streamItem: 'kerplunk-stream:streamItem'
      streamTypes:
        'kerplunk-stream:stream':
          description: 'Stream! (recent posts)'
          sort: 'desc'
      css:
        'kerplunk-stream:streamItem': 'kerplunk-stream/css/streamitem.css'
