from twisted.internet import reactor, protocol
from twisted.internet.defer import Deferred
import sys

class AtServer( protocol.Protocol ):
    def __init__( self ):
        self.name = sys.argv[1]
        self.d = Deferred()
        self.d.addCallback( self.handleInput )
        
    def dataReceived( self, data ):
        self.d.callback( data )

    def handleInput(self, data):
        # process the data received
        types = [ str, str, str, str ]
        input = [ ty(val) for ty, val in
                  zip( types, data.split(" ")) ]
        # figure out the command
        if( input[0] == "IAMAT" ):
            self.transport.write( input[0] )
        elif( input[0] == "AT" ):
            self.transport.write( "fix this" )
        else:
            self.transport.write( "?" )
        # execute the command if it is valid

        # add the correct callback

        # fire the callback
        
        
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
