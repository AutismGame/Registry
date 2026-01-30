class Config {
    ushort port;
    
    this(ushort port /* TEMP */) {
        this.port = port;
    }
    
    void Load() {
        this.port = 8540;
        // TODO read file and fill struct
    }
    
    void Save() {
        // TODO read and save to file
    }
}

// init function?

/*
    Read Config files and fill the struct with its data.
    Create a new one if it doesnt exist
    Error out when weird shit happens
    Warn when saving fails
    
    Config files (macOS/Linux)
        /etc/autismregistry/config.ini
    
    Config files (windows)
        /Programms x86/AutismRegistry/Data/config.ini
*/

// TODO Impl