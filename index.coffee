Promise = require("bluebird")
request = require("request")


class HackerAPI

  constructor: ->
    @token = null
    @data = null
    @userId = null
    @apiServer = "https://hackerapi.com/v1"


  setToken: (token) ->
    @token = token


  getToken: (username, password) ->
    req = {}
    req.method = 'POST'
    req.endpoint ='/auth/user'
    req.payload = {
                    username: username,
                    password: password
                  }

    return @makeRequest req


  makeRequest: ({endpoint, method, params, payload, callback} = {}) ->
    return new Promise (resolve, reject) =>
      method ?= 'GET'
      params ?= {}
      url = "#{@apiServer}#{endpoint}"

      options = {
                  url : url,
                  qs : params
                  method : method,
                  json : true,
                }

      if method is 'POST'
        options.body = payload

      request options, (error, response, body) ->
        if error
          reject(error)
          callback(error) if callback
        else
          resolve(body)
          callback(null, body) if callback



api = new HackerAPI
api.getToken("kartik@hackthenorth.com", "test").then((body) ->
  if 'success' not in body
    console.log "Hello, #{body.name}, your token is #{body.token}"
)
