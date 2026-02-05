import baseregistry;
import serverentry;
import cliententry;
import std.stdio;
import std.concurrency;
import packet;
import crypto;


class Registry : BaseRegistry {
    
    //ServerEntry[sockaddr] servers;
    ClientEntry[] clients; // TRULY this needs to be a database         (MongoDB is Webscale, just like /dev/null kekw!)
    ClientEntry[] connected_clients;
    
    ServerEntry[] connected_servers;
    
    private ulong biggest_accountid; // account ids will be done incrementally to prevent spoofing
                                     // TODO save somehow

    override void[] ProcessPacket(uint packettype, ubyte[] packet, sockaddr fromi)
    {
        writeln("Registry:");
        writeln(packettype);
        ubyte[] retVal;
        
        // we only deal with registry packets
        if (!(packettype & PACKET_FLAGS.Registry)) {
            return retVal;
        }

        switch(packettype)
        {   
            // Clients
            case RegistryPacket_C10_Account.p.Type:
                mixin PackAsType!(RegistryPacket_C10_Account, packet);
                /*^ w ^*/ // TODO validate user input
                switch(pack.operation) {
                    case RegistryPacket_C10_Account.UserOperation.Create:
                        ClientEntry newAccount = new ClientEntry(NextFree());
                        
                        RegisterClient(newAccount);
                        break;
                    case RegistryPacket_C10_Account.UserOperation.Modify:
                        break;
                    case RegistryPacket_C10_Account.UserOperation.Remove:
                        
                        
                        break;
                    default:
                        break;
                }
                break;
                
            
            // Servers
            
            default:
                retVal = [];
                break;
        }
        return retVal;
    }
    
    override void Tick(double delta) {
        super.Tick(delta);
    }
    
    ClientEntry FindClientEntry(ulong accountid) {
        foreach (client; clients) {
            if (client.accountid == accountid) {
                return client;
            }
        }
        
        return null;
    }
    
    void TrackServer(ServerEntry entry) {
        printf("registering server");
        connected_servers ~= entry;
    }
    
    void RegisterClient(ClientEntry entry) {
        writeln("Client registered\n");
        
        clients ~= entry;
    }
    
    void UnregisterClient(ulong accountid) {
        // MAKE SURE YOU HAVE VERIFIED that whatever is calling this method has full permission to delete accounts (such as the owner themselves)
        
    }
    
    private ulong NextFree() {
        return biggest_accountid++;
    }
}

shared(bool) Registry_run;

void Registry_Loop()
{
    Registry rg = new Registry();
    rg.Listen(8540); //config

    while(Registry_run) {
        rg.Tick(0.016);
    }
    
    Registry_End();
    rg.CloseSocket();
}

public void Registry_Init()
{
    Registry_run = true;
    spawn(&Registry_Loop);
}

public nothrow @nogc void Registry_End()
{
    Registry_run = false;
}