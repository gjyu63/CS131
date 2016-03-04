from twisted.internet import reactor, protocol
import sys

class AtServer(protocol.Protocol):
    def __init__(self):
        self.name = sys.argv[1]

class AtServerFactory(protocol.ServerFactory):
    def buildFactory(self, addr):
        return AtServer()

def check_server_name():
    server_names = ("Alford",
                    "Bolden",
                    "Hamilton",
                    "Parker",
                    "Welsh")
    
    if len(sys.argv) != 2:
        raise ValueError(
            "Usage: python server.py <server name>")
    else:
        name = sys.argv[1]
        if not name in server_names:
            raise ValueError(
                "%s is not a valid server name" % name)

def main():
    check_server_name()
    reactor.listenTCP(44444, AtServerFactory())
    reactor.run()
    
# main subroutine call
if __name__ == "__main__": main()
