// Module for placeholder code that helps implementing a new feature

import std.socket;
import std.stdio;
import packet;
import registry;
import crypto;

void Test() {
    TcpSocket awesome = new TcpSocket(new InternetAddress("127.0.0.1", 8540));
    
    RegistryPacket_C10_Account p;
    
    p.operation = RegistryPacket_C10_Account.UserOperation.Create;
    
    void[] buf = p.Serialize();
    
    awesome.send(buf);
    
    writeln("i send");
    
    while(1) {}
}