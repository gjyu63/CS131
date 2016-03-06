from twisted.internet import reactor, protocol
from twisted.internet.defer import Deferred
import sys, re
from time import time

# Byte-compiled regular expression for GPS coordinates
r = re.compile("([\+|-]\d+\.\d+)([\+|-]\d+\.\d+)")

class AtServer( protocol.Protocol ):
    def __init__( self ):
        self.name = sys.argv[1]
        self.servers = {}
        
    def dataReceived( self, data ):
        d = Deferred()
        d.addCallback( self.handleInput )
        d.callback( data )

    def handleInput(self, data):
        # process the data received
        types = [ str, str, str, str ]
        input = [ ty(val) for ty, val in
                  zip( types, data.split(" ")) ]
        # figure out the command
        if( input[0] == "IAMAT" ):
            dIAMAT = Deferred()
            dIAMAT.addCallback(self.handleIAMAT)
            dIAMAT.callback(input)

        elif( input[0] == "WHATSAT" ):
            dAT = Deferred()
            dAT.addCallback(self.handleWHATSAT)
            dAT.callback(input)
            
            self.transport.write( "fix this:\n" )
        else:
            self.transport.write( "?" )

    def storeServerLocation(self, input, time, time_diff):
        '''Store a server's location.
        
        arguments:
        input[1] = client name
        input[2] = location
        input[3] = client time
        time - server time
        time_diff - server-client time difference

        stores:
        server name, time difference, client,
        location, server-client time
        '''
        client = input[1]
        location = input[2]

        # parse the GPS location
        m = r.match(location)
        latitude = float(m.group(1))
        longitude = float(m.group(2))

        self.servers[client] = {
            "server-name"     : self.name,
            "time-difference" : time_diff,
            "client-name"     : client,
            "location"        : location,
            "sc-time"         : time,
            "latitude"        : latitude,
            "longitude"       : longitude }
            
    def handleIAMAT(self, input):
        client_time = input[3]
        server_time = time()
        time_diff = self.calculate_time_difference(
            client_time, server_time)

        server_name = self.name
        client_server = input[1]
        location = input[2]

        self.storeServerLocation(input, server_time, time_diff)
        
        output_str = "AT %s %s %s %s\n" % ( server_name,
                                             time_diff,
                                             client_server,
                                             time_diff )
        
        self.transport.write( "%s" % output_str )

    def handleWHATSAT(self, input):
        '''input will be a list of values:
        input[0] = WHATSAT command
        input[1] = client name
        input[2] = information upper bound
        input[3] = radius of the client

        the server should respond with information, if
        such a client has already been stored:

        AT <server> <time difference> <client> <location>...
        <time of server-client interaction> <GOOGLE info>
        '''
        client = input[1]
        upperbound = input[2]
        radius = input[3]
        lookup = self.servers[client]
        
        self.transport.write(
            "AT %s %s %s %s %s\n" % (
                lookup["server-name"],
                lookup["time-difference"],
                lookup["client-name"],
                lookup["location"],
                lookup["sc-time"] ))
                
    def calculate_time_difference(self, t1, t2):
        time_diff = str(float(t2) - float(t1))
        if (float(time_diff) >= 0):
            time_diff = "+" + time_diff

        return time_diff
        
    def speakName( self, data ):
        self.transport.write(
            "This is %s, hello.\n" % self.name )

class AtServerFactory( protocol.Factory ):
    def buildProtocol( self, addr ):
        return AtServer()

def check_server_name():
    server_names = { "Alford"   : 44444,
                     "Bolden"   : 44445,
                     "Hamilton" : 44446,
                     "Parker"   : 44447,
                     "Welsh"    : 44448 }
    
    if len( sys.argv ) != 2:
        raise ValueError(
            "Usage: python server.py <server name>")
    else:
        name = sys.argv[ 1 ]
        if not name in server_names:
            raise ValueError(
                "%s is not a valid server name" % name )
        return server_names[ name ]

def main():
    server_port = check_server_name()
    reactor.listenTCP( server_port, AtServerFactory() )
    
    reactor.run()
    
if __name__ == "__main__": main()
