import std.stdio; // DBG
import core.stdc.signal;
import registry;
import cliententry;
import serverentry;
import config;
import test;

extern(C) nothrow @nogc void killsignal(sig_atomic_t signal) {
    printf("\numieram :(\n");
    Registry_End();
}

void main(string[] args)
{
    signal(SIGINT, &killsignal);
    
    // TODO Load Config

    printf("i try\n");
    
    Registry_Init();

    Test();
}