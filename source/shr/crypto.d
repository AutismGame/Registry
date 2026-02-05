import libsodium;

/// libsodium-devel is required for header files.

// i dont know any other libs so ill remain using libsodium

class Key {
    /**
    * 256 Key Class
    */
    private:
        ulong[4] quads;
    
    public:
        /** 
         * This Constructor method generates a new, unique key.
         */
        this() {
            randombytes_buf(quads.ptr, 32);
        }
    
        Key Hash(Key other) {
            // TODO
            
            throw new Error("unimplemented");
            
            return other;
        }
    
        Key GeneratePublic() {
            // TODO

            throw new Error("unimplemented");

            return this;
        }
        
}