public import std.socket;
import std.stdio;

class BaseRegistry
{

    TcpSocket listener;
    void Listen(ushort port)
    {
        listener = new TcpSocket();
        listener.blocking = false;
        listener.bind(new InternetAddress("127.0.0.1", port));
        listener.listen(10);
    }

    void[] ProcessPacket(uint packettype, ubyte[] data, sockaddr fromi)
    {
        return [];
    }

    void Tick(double delta)
    {
        if(listener is null)
        {
            return;
        }

        try
        {
            Address from;
            ubyte[2048] packet;
            auto packetLength = listener.receiveFrom(packet[], from);
            
            while(packetLength != Socket.ERROR)
            {
                writeln("hi");

                sockaddr fromi = *from.name();
                uint packettype = *cast(uint*)packet.ptr;

                ubyte[] tosend = cast(ubyte[])ProcessPacket(packettype,(packet.ptr)[0..packetLength],fromi);
                if(tosend.length > 0)
                {
                    listener.sendTo(tosend,from);
                }
                packetLength = listener.receiveFrom(packet[], from);
            }
        }
        catch(Exception e)
        {

        }
    }

    void CloseSocket()
    {
        listener.shutdown(SocketShutdown.BOTH);
        listener.close();
        listener = null;
    }

    /*void SendToAll(PacketT)(PacketT pack)
    {
        foreach(addr; clients)
        {
            listener.sendTo([pack],new InternetAddress(cast(sockaddr_in)addr));
        }
    }*/
}