import requests
import json

#r = requests.post('http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,fb&f=l1&e=.csv')
#r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/echo/hello')
#directives = json.loads(r.text)
#blinks = directives['directives'][0]['options']['something']
#print blinks

r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/echo/message?input=god&msg_type=song')
directives = json.loads(r.text)
print directives['directives']


