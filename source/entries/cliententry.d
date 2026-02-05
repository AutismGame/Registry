import baseentry;
import crypto;

class ClientEntry : BaseEntry {
    this(ulong accountid) {
        this.accountid = accountid;
        this.accountkey = NewKey();
    }
    
    immutable ulong accountid;
    Key accountkey;
}