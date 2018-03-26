import groovy.json.JsonSlurper 
def registryRequest = 'curl http://192.168.56.10:5000/v2/task7/tags/list'.execute().text
def jsonSlurper  = new JsonSlurper()
def parseRequest = jsonSlurper.parseText(registryRequest)
return parseRequest.tags