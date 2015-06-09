XMLHttpRequest = require('xhr2')


class HackerAPI

  constructor: (token) ->
    @token = token
    @userId = null
    @apiServer = "https://hackerapi.com/v1"


  ########## Auth Endpoint ##########
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

  ########## Users Endpoint ##########
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


  getUserFiles: (id, callback) ->
    req = {}
    req.endpoint = "/users/#{id}/files"
    req.callback = callback

    return @makeRequest req


  getUserResume: (id, callback) ->
    req = {}
    req.endpoint = "/users/#{id}/resume"
    req.callback = callback

    return @makeRequest req


  ########## Teams Endpoint ##########
  getTeamInfo: (id, callback) ->
    req = {}
    req.endpoint = "/teams/#{id}"
    req.callback = callback

    return @makeRequest req


  ########## Pipeline Endpoint ##########
  getPipelineInfo: (id, callback) ->
    req = {}
    req.endpoint = "/pipeline/#{id}"
    req.callback = callback

    return @makeRequest req


  getPipelineClaims: (id, callback) ->
    req = {}
    req.endpoint = "/pipeline/#{id}/claims"
    req.callback = callback

    return @makeRequest req


  getPipelineFields: (id, callback) ->
    req = {}
    req.endpoint = "/pipeline/#{id}/fields"
    req.callback = callback

    return @makeRequest req


  getPipelineFieldById: (id, field_id, callback) ->
    req = {}
    req.endpoint = "/pipeline/#{id}/fields/#{field_id}"
    req.callback = callback

    return @makeRequest req


  ########## Claims Endpoint ##########
  getClaimInfo: (id, callback) ->
    req = {}
    req.endpoint = "/claims/#{id}"
    req.callback = callback

    return @makeRequest req


  ########## Files Endpoint ##########
  getFileInfo: (id, callback) ->
    req = {}
    req.endpoint = "/files/#{id}"
    req.callback = callback

    return @makeRequest req


  getFileDownload: (id, callback) ->
    req = {}
    req.endpoint = "/files/#{id}/download"
    req.callback = callback

    return @makeRequest req


  ########## Institutions Endpoint ##########
  getInstitutionInfo: (id, callback) ->
    req = {}
    req.endpoint = "/institutions/#{id}"
    req.callback = callback

    return @makeRequest req


  ########## Events Endpoint ##########
  getEventInfo: (slug, callback) ->
    req = {}
    req.endpoint = "/events/#{slug}"
    req.callback = callback

    return @makeRequest req


  getEventSignups: (slug, callback) ->
    req = {}
    req.endpoint = "/events/#{slug}/signups"
    req.callback = callback

    return @makeRequest req


  ########## Search Endpoint ##########
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
api.searchInstitutions("water", console.log)
# api.getCurrentUserInfo(callback)
api.getUserInfo(1, callback)





# TODOS
# - handle errors
