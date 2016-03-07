from twisted.web.client import getPage
from twisted.internet import reactor
import json

url = "https://maps.googleapis.com/maps/api/place/" \
      "nearbysearch/json?location=-33.8670522,151.1957362" \
      "&radius=500&type=restaurant&name=cruise&key=" \
      "AIzaSyAI7i4FJB5-_Vysqrq1vMoEQQuXODXuXLM"

def stop(result):
    reactor.stop()

def printPage(result):
    print "new run: \n\n\n"
    jdata = json.loads(result)
    get = jdata["results"]
    print get

d = getPage(url)
d.addCallbacks(printPage)
d.addCallback(stop)

reactor.run()
