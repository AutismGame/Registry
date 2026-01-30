import std.stdio; // DBG
import registry;
import config;

Config cf;
Registry rg;

void main(string[] args)
{
    // Load Config
    cf = new Config(8450); // TODO: deconstantialize
    
    rg = new Registry();
    rg.Listen(cf.port); // TODO: looks weird, maybe have some sort of AttachConfig function or require a *Config configuration when creating a registry.
}