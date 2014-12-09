
import requests
import json

r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/raspberrypie/button')
directives = json.loads(r.text)

print directives['directives'][0]['options']['blinks']

