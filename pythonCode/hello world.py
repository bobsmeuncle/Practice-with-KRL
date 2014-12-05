
import requests

r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/pie/button')

#r = requests.post('http://cs.kobj.net/sky/event/D8193B5E-4B2F-11E4-8C99-9CD33A8D136F/123/pie/button')

print r.text
print r.status_code
print r.headers['content-type']
