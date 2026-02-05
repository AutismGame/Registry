import crypto;
import sex;

public enum PACKET_FLAGS : uint {
	Error      = 0x80000000,
	Processing = 0x40000000,
	Registry   = 0x20000000,
	User       = 0x10000000
	// Encryption?
}

struct RegistryPacket(uint ID)
{ align(1):
	static const uint Type = PACKET_FLAGS.Registry | ID;
	uint type = ID;
}

mixin template PackAsType(T, alias packet)
{
	T pack = *cast(T*)(packet.ptr);

	// TODO
}

//! registry packets

struct RegistryPacket_B0_Info
{ align(1):
	RegistryPacket!(0) p;
	
	enum Information : ubyte {
		Success, // yay
		Heartbeat,
		
		ErrorInternal, // we fucked up
		ErrorExternal, // your recieved data sucks (malformed)
		RateLimit,
	}
}

struct RegistryPacket_S4_Advertise
{ align(1):
	RegistryPacket!(4) p;
}



struct RegistryPacket_C10_Account
{ align(1):
	RegistryPacket!(PACKET_FLAGS.User | 10) p;
	enum UserOperation : byte {
		Create,
		Modify,
		Remove
	}
	
	UserOperation operation;
	
	union {
		struct CreateArg {
			// metadata about user
		};
		CreateArg create;
		
		struct ModifyArg {
			ulong accountid;
			Key accountkey;

			// metadata about user
		};
		ModifyArg modify;
		
		struct RemoveArg {
			ulong accountid;
			Key accountkey;
		};
		RemoveArg remove;
	}
	
	void[] Serialize() {
		void[] ret;
		p.Serialize(ret);
		operation.Serialize(ret);
		switch(operation)
		{
			case UserOperation.Create:
				break;
			case UserOperation.Modify:
				modify.accountid.Serialize(ret);
				modify.accountkey.Serialize(ret);
				break;
			case UserOperation.Remove:
				remove.accountid.Serialize(ret);
				remove.accountkey.Serialize(ret);
				break;
				default: assert(0);
		}
		return ret;
	}

	RegistryPacket_C10_Account Deserialize(void[] input) {
		RegistryPacket_C10_Account ret;
		
		input.Deserialize(ret.p);
		input.Deserialize(ret.operation);

		switch(operation) {
			case UserOperation.Create:
				break;
			case UserOperation.Modify:
				input.Deserialize(ret.modify.accountid);
				input.Deserialize(ret.modify.accountkey);
				break;
			case UserOperation.Remove:
				input.Deserialize(ret.remove.accountid);
				input.Deserialize(ret.remove.accountkey);
				break;
				default: assert(0);
		}
		return ret;
	}
}

struct RegistryPacket_R10_Account // Response
{ align(1):
	RegistryPacket!(10) p;
	RegistryPacket_B0_Info.Information info;
	
	ulong accountid;
	Key accountkey;
}

struct RegistryPacket_C18_NewSession
{ align(1):
	RegistryPacket!(PACKET_FLAGS.User | 18) p;
	ulong userkey;
}

struct RegistryPacket_C19_EndSession
{ align(1):
	RegistryPacket!(PACKET_FLAGS.User | 19) p;
}



//! end registry packets

