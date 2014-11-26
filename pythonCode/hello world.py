
import requests

r = requests.post('http://cs.kobj.net/sky/event/FC64E88C-6F51-11E4-8766-859FE71C24E1/123/foursquare/checkin')

print r.text
print r.status_code
print r.headers['content-type']
