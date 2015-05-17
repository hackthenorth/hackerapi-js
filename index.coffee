Promise = require("bluebird")
request = require("request")


class HackerAPI

  constructor: (token) ->
    @token = token
    @userId = null
    @apiServer = "https://hackerapi.com/v1"


  getToken: (username, password, callback) ->
    req = {}
    req.method = 'POST'
    req.endpoint ='/auth/user'
    req.callback = callback
    req.payload = {
                    username: username,
                    password: password
                  }

    return @makeRequest req


  getUserInfo: (id, callback) ->
    req = {}
    req.endpoint ="/users/#{id}"
    req.callback = callback

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

      if @token
        options.qs.token = @token

      request options, (error, response, body) ->
        if error
          reject(error)
          callback(error) if callback
        else
          resolve(body)
          callback(null, body) if callback



login = ->
  onLogin = (err, data) ->
    if 'token' of data
      console.log "Hello, #{data.name}, your token is #{data.token}"
    else
      throw new Error "Invalid login details"

  api = new HackerAPI
  api.getToken "kartik@hackthenorth.com", "", onLogin



token = ''

api = new HackerAPI token
api.getUserInfo(2).then((x) ->
  console.log x
)

