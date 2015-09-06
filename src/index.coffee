module.exports = (System) ->
  globals:
    public:
      streamItem: 'kerplunk-stream:streamItem'
      streamTypes:
        'kerplunk-stream:stream':
          description: 'Stream! (recent posts)'
          sort: 'desc'
      styles:
        'kerplunk-stream/css/streamitem.css': ['/admin/dashboard', '/admin/dashboard/**']
