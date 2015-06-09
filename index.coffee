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


  setToken: (token) ->
    @token = token


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


  updateUser: (id, payload, callback) ->
    req = {}
    req.method   = 'PUT'
    req.payload  = payload
    req.endpoint = "/users/#{id}"
    req.callback = callback

    return @makeRequest req


  ########## Teams Endpoint ##########
  getTeamInfo: (id, callback) ->
    req = {}
    req.endpoint = "/teams/#{id}"
    req.callback = callback

    return @makeRequest req


  createTeam: (event_slug, callback) ->
    req = {}
    req.method   = "POST"
    req.endpoint = "/events/#{event_slug}/teams"
    req.callback = callback

    return @makeRequest req


  ########## Pipeline Endpoint ##########
  getPipelineInfo: (id, callback) ->
    req = {}
    req.endpoint = "/pipelines/#{id}"
    req.callback = callback

    return @makeRequest req


  getPipelineClaims: (id, callback) ->
    req = {}
    req.endpoint = "/pipelines/#{id}/claims"
    req.callback = callback

    return @makeRequest req


  getPipelineFields: (id, callback) ->
    req = {}
    req.endpoint = "/pipelines/#{id}/fields"
    req.callback = callback

    return @makeRequest req


  getPipelineFieldById: (id, field_id, callback) ->
    req = {}
    req.endpoint = "/pipelines/#{id}/fields/#{field_id}"
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


  createInstitution: (payload, callback) ->
    if not payload.name?
      throw "Institution name missing"

    if not payload.institution_type?
      throw "Institution type missing"

    if not payload.country_code?
      throw "Missing country code"

    types = ['post-secondary', "high_school", "middle_school", "other"]
    if payload.institution_type not in types
      throw "Invalid institution type"

    if payload.country_code.length != 2
      throw "Invalid country code"

    req = {}
    req.method  = 'POST'
    req.payload = {
                    name : payload.name,
                    institution_type : payload.institution_type,
                    country_code : payload.country_code
                  }
    req.endpoint = "/institutions"
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


  uploadFile: (slug, payload, callback) ->
    if not event_slug?
      throw "Event slug missing"

    if not payload.file?
      throw "File missing"

    if not payload.type?
      throw "File type missing."

    types = ['resume', "receipt", "form", "other"]
    if payload.type not in types
      throw "Invalid file type"

    req = {}
    req.method  = 'POST'
    req.payload = {
                    file : payload.file,
                    type : payload.type
                  }
    req.endpoint = "/events/#{slug}/upload"
    req.callback = callback

    return @makeRequest req


  ########## Search Endpoint ##########
  searchInstitutions: (query, callback) ->
    req = {}
    req.params   = {
                     q: query
                   }
    req.callback = callback
    req.endpoint = "/search/institutions"

    return @makeRequest req


  makeRequest: ({endpoint, method, params, payload, callback} = {}) ->
    method ?= 'GET'
    params ?= {}
    payload ?= null

    if @token
      params.token = @token

    params = @serialize(params)
    url = "#{@apiServer}#{endpoint}?#{params}"

    xhr = new XMLHttpRequest
    xhr.open(method, url, true)

    xhr.onreadystatechange = () ->
      if xhr.readyState == 4 and xhr.status == 200
        data = xhr.responseText
        try
          json = JSON.parse(data)
        catch
          json = {"success" : false, "message" : "Could not parse JSON"}
        callback(json)

    if method == 'POST' or method == 'PUT'
      if payload
        xhr.setRequestHeader("Content-type", "application/json")
        xhr.send(JSON.stringify(payload))
      else
        xhr.send()
    else
      xhr.send()


  serialize: (obj) ->
    str = []

    for p of obj
      param = encodeURIComponent(p) + "=" + encodeURIComponent(obj[p])
      str.push param

    return str.join("&")



token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzM5MTUyOTgsImlkIjoyLCJldnQiOlsxXSwidHlwIjoidXNyIn0.USfHFAJ_AYw4hP-wAjiVSWiXbwxPwWLjzzC5oXhVCws"
api = new HackerAPI token
callback = console.log
# api.searchInstitutions("water", console.log)
# api.getCurrentUserInfo(callback)
# api.getUserInfo(1, callback)
# api.createInsitution({name:"Emery Collegiate Institute", institution_type:"high_school", country_code:"CA"}, callback)
# api.getInsitutionInfo(22593, callback)
# user_payload = {"address": {}}
# api.updateUser(2, user_payload, callback)
# api.createTeam('hackthenorth', callback)
api.getTeamInfo('8ed19e0022', callback)


# TODOS
# - handle errors
