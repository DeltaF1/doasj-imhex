enum RecordType : u8 {
	SerializedStreamHeader = 0,
	ClassWithId,
	SystemClassWithMembers,
	ClassWithMembers,
	SystemClassWithMembersAndTypes,
	ClassWithMembersAndTypes,
	BinaryObjectString,
	BinaryArray,
	MemberPrimitiveTyped,
	MemberReference,
	ObjectNull,
	MessageEnd,
	BinaryLibrary,
	ObjectNullMultiple256,
	ObjectNullMultiple,
	ArraySinglePrimitive,
	ArraySingleObject,
	ArraySingleString,
	MethodCall = 21,
	MethodReturn = 22,
};

enum BinaryType : u8 {
	Primitive = 0,
	String,
	Object,
	SystemClass,
	Class,
	ObjectArray,
	StringArray,
	PrimitiveArray
};

enum PrimitiveType : u8 {
	Boolean = 1,
	Byte,
	Char,
	// Unused
	Decimal = 5,
	Double,
	Int16,
	Int32,
	Int64,
	SByte,
	Single,
	TimeSpan,
	DateTime,
	UInt16,
	UInt32,
	UInt64,
	Null,
	String
};

// TODO: Support lengths > 128
struct LengthPrefixedString {
	u8 length;
	char bytes[length];	
};

struct Primitive<auto ty>{
	if (ty == PrimitiveType::Boolean) {
		bool b;	
	} else if (ty == PrimitiveType::Byte) {
		u8 byte;
	} else if (ty == PrimitiveType::Char) {
		//
	} else if (ty == PrimitiveType::Decimal) {
		LengthPrefixedString s;
	} else if (ty == PrimitiveType::Double) {
		double d;
	} else if (ty == PrimitiveType::Int16) {
		s16 int;
	} else if (ty == PrimitiveType::Int32) {
		s32 int;
	} else if (ty == PrimitiveType::Int64) {
		s64 int;
	} else if (ty == PrimitiveType::SByte) {
		s8 byte;
	} else if (ty == PrimitiveType::Single) {
		float f;
	} else if (ty == PrimitiveType::TimeSpan) {
		//
	} else if (ty == PrimitiveType::DateTime) {
		//
	} else if (ty == PrimitiveType::UInt16) {
		u16 int;
	} else if (ty == PrimitiveType::UInt32) {
		u32 int;
	} else if (ty == PrimitiveType::UInt64) {
		u64 int;
	} else if (ty == PrimitiveType::Null) {
		//
	} else if (ty == PrimitiveType::String) {
		LengthPrefixedString string;
	}
};

enum BinaryArrayType : u8 {
	Single = 0,
	Jagged,
	Rectangular,
	SingleOffset,
	JaggedOffset,
	RectangularOffset
};

struct SerializedStreamHeader {
	s32 rootId;
	s32 headerId;
	s32 minorVersion;
	s32 majorVersion;
};

struct BinaryLibrary {
	s32 libraryId;
	LengthPrefixedString libraryName;
};

struct ClassInfo {
	s32 objectId;
	LengthPrefixedString name;
	s32 memberCount;
	LengthPrefixedString memberNames[memberCount];
};


// TODO: Pad properly for all additional type info
// as per the table in 2.3.1.2
struct AdditionalInfos<auto memberTypes> {
	// FIXME: Hard-coded for spaceport janitor
	PrimitiveType prims[15];	
};

struct AdditionalInfo<auto memberType> {
	if (memberType == BinaryType::Primitive) {
		PrimitiveType primitiveType;
	} else if (memberType == BinaryType::SystemClass) {
		LengthPrefixedString name;
	} else if (memberType == BinaryType::Class) {
		ClassInfo classInfo;
	} else if (memberType == BinaryType::PrimitiveArray) {
		PrimitiveType primitiveType;
	}
};

struct MemberTypeInfo<auto count> {
	BinaryType types[count];
	AdditionalInfos<types> additional;	
};

using Record;

struct ClassWithMembersAndTypes {
	ClassInfo members;
	MemberTypeInfo<members.memberCount> types;
	s32 libraryId;
	s32 weekDay;
	s32 trashBurnedNum;
	s32 questProgress;
	
	float municipalCredits;
	float luck;
	float lastPaycheck;
	float trashBurnedToday;
	
	Record diaryEntries;
	Record chestItems;
	Record invItems;
	
	Record goddessName;
	
	bool stormy;
	bool qAata;
	bool qOrloqq;
	bool qHeather;
	bool qSlimy;
	bool qRhiande;
	
	Record questConvs;
	
	float genderDeath;
};

struct BinaryArray {
	s32 objectId;
	BinaryArrayType arrayType;
	s32 rank;
	if (rank > 0) {
		//s32 lengths[rank];
	}
	if (arrayType != BinaryArrayType::SingleOffset &&
		arrayType != BinaryArrayType::JaggedOffset &&
		arrayType != BinaryArrayType::RectangularOffset) {
	//	s32 lowerBounds[rank];
	}
	BinaryType type;
	AdditionalInfo<type> additionalInfo;
};

struct BinaryObjectString {
	s32 objectId;
	LengthPrefixedString value;
};

struct MemberReference {
	s32 objectId;
};

struct ArrayInfo {
	s32 objectId;
	s32 length;
};

struct ArraySingleString {
	ArrayInfo info;
	Record strings[info.length];
};

struct ArraySinglePrimitive {
	ArrayInfo info;
	PrimitiveType type;
	Primitive<type> values[info.length];
};

struct Record {
	RecordType type;
	if (type == RecordType::SerializedStreamHeader) {
		SerializedStreamHeader serializedStreamHeader;
	}
	else if (type == RecordType::ClassWithId) {
		//ClassWithId classWithId;
	}
	else if (type == RecordType::SystemClassWithMembers) {
		//SystemClassWithMembers systemClassWithMembers;
	}
	else if (type == RecordType::ClassWithMembers) {
		//ClassWithMembers classWithMembers;
	}
	else if (type == RecordType::SystemClassWithMembersAndTypes) {
		//SystemClassWithMembersAndTypes systemClassWithMembersAndTypes;
	}
	else if (type == RecordType::ClassWithMembersAndTypes) {
		ClassWithMembersAndTypes classWithMembersAndTypes;
	}
	else if (type == RecordType::BinaryObjectString) {
		BinaryObjectString binaryObjectString;
	}
	else if (type == RecordType::BinaryArray) {
		BinaryArray binaryArray;
	}
	else if (type == RecordType::MemberPrimitiveTyped) {
		//MemberPrimitiveTyped memberPrimitiveTyped;
	}
	else if (type == RecordType::MemberReference) {
		MemberReference memberReference;
	}
	else if (type == RecordType::ObjectNull) {
		//ObjectNull objectNull;
	}
	else if (type == RecordType::MessageEnd) {
		//MessageEnd messageEnd;
	}
	else if (type == RecordType::BinaryLibrary) {
		BinaryLibrary binaryLibrary;
	}
	else if (type == RecordType::ObjectNullMultiple256) {
		//ObjectNullMultiple256 objectNullMultiple256;
	}
	else if (type == RecordType::ObjectNullMultiple) {
		//ObjectNullMultiple objectNullMultiple;
	}
	else if (type == RecordType::ArraySinglePrimitive) {
		ArraySinglePrimitive arraySinglePrimitive;
	}
	else if (type == RecordType::ArraySingleObject) {
		//ArraySingleObject arraySingleObject;
	}
	else if (type == RecordType::ArraySingleString) {
		ArraySingleString arraySingleString;
	}
	else if (type == RecordType::MethodCall) {
		//MethodCall methodCall;
	}
	else if (type == RecordType::MethodReturn) {
		//MethodReturn methodReturn;
	}

	if (type == RecordType::MessageEnd) {
		break;
	}
};

struct referenceable {};

struct NRBFStream {
	Record header;
	
	if (header.type != RecordType::SerializedStreamHeader) {return 0;}
	Record records[8];
};

NRBFStream stream @ 0x00;
