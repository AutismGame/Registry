import baseentry;
import crypto;

class ClientEntry : BaseEntry {
    this(ulong accountid) {
        this.accountid = accountid;
        this.accountkey = new Key();
    }
    
    immutable ulong accountid;
    private Key accountkey;
}