import baseregistry;

class Registry : BaseRegistry {

    override ubyte[] ProcessPacket(uint packettype, ubyte[] data, sockaddr fromi)
    {
        return [];
    }


}