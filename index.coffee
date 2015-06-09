XMLHttpRequest = require('xhr2')


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


  getCurrentUserInfo: (callback) ->
    req = {}
    req.endpoint = "/users/me"
    req.callback = callback

    return @makeRequest req


  getUserInfo: (id, callback) ->
    req = {}
    req.endpoint = "/users/#{id}"
    req.callback = callback

    return @makeRequest req


  searchInstitutions: (query, callback) ->
    req = {}
    req.params   = {"q": query}
    req.callback = callback
    req.endpoint = "/search/institutions"

    return @makeRequest req


  makeRequest: ({endpoint, method, params, payload, callback} = {}) ->
    method ?= 'GET'
    params ?= {}

    if @token
      params.token = @token

    params = @serialize(params)
    url = "#{@apiServer}#{endpoint}?#{params}"

    xhr = new XMLHttpRequest
    xhr.open(method, url);
    xhr.send();

    xhr.onreadystatechange = () ->
      if xhr.readyState == 4 and xhr.status == 200
        data = xhr.responseText
        try
          json = JSON.parse(data)
        catch
          json = {"success" : false, "message" : "Could not parse JSON"}

        callback(json)


  serialize: (obj) ->
    str = []

    for p of obj
      param = encodeURIComponent(p) + "=" + encodeURIComponent(obj[p])
      str.push param

    return str.join("&")



login = ->
  onLogin = (err, data) ->
    if 'token' of data
      console.log "Hello, #{data.name}, your token is #{data.token}"
    else
      throw new Error "Invalid login details"

  api = new HackerAPI
  api.getToken "kartik@hackthenorth.com", "", onLogin

token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzM5MTUyOTgsImlkIjoyLCJldnQiOlsxXSwidHlwIjoidXNyIn0.USfHFAJ_AYw4hP-wAjiVSWiXbwxPwWLjzzC5oXhVCws"
api = new HackerAPI token
callback = console.log
# api.searchInstitutions("water", console.log)
# api.getCurrentUserInfo(callback)
api.getUserInfo(1, callback)





# TODOS
# - handle errors


