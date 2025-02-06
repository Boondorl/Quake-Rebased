
// This is mostly for serializing data between levels. Some serious bitpacking will be needed to handle something
// like Hexen 2's inventory with only 16 parameter fields. It also has a safety net to make sure there's never more than
// 24 bits packed and will correctly encode the sign bit of floats.

void PackBits(__out int_t res, int_t val, uint_t bits, __inout uint_t bitOfs, bool_t unsigned = 0)
{
	if (bits < 1)
		ThrowAbortException("Values require at least 1 bit");
	
	bits = Floor(bits);
	if (bitOfs + bits > FLT_MANT_DIG)
		ThrowAbortException("Tried to pack more than 24 bits into a float field");
	
	int_t realVal;
	int_t shift = Pow(2, bits - 1);
	// Treat bools as unsigned by default
	if (bits >= 2 && !unsigned)
	{
		// Intentionally clear the leading bit
		realVal = val & (shift - 1);
		if (val < 0)
			realVal |= shift;
	}
	else
	{
		realVal = val & (shift * 2 - 1);
	}
	
	res |= realVal * Pow(2, bitOfs);
	bitOfs += bits;
}

// Simple wrapper for flag fields
inline void PackFlags(__out flags_t res, uint_t val, uint_t bits = 24, __inout uint_t bitOfs = 0)
{
	PackBits(res, val, bits, bitOfs, TRUE);
}

// A way to preserve floating point values with some degree of accuracy
void PackFixed(__out int_t res, float val, uint_t wholeBits, uint_t fracBits, __inout uint_t bitOfs, bool_t unsigned = 0)
{
	if (fracBits < 1)
		ThrowAbortException("Fixed values require at least 1 fractional bit");
	if (wholeBits < 0)
		ThrowAbortException("Number of whole bits cannot be negative");
	if (!unsigned && wholeBits < 1)
		ThrowAbortException("Signed fixed values require at least 1 whole bit");
	
	fracBits = Floor(fracBits);
	wholeBits = Floor(wholeBits);
	uint_t totalBits = wholeBits + fracBits;
	if (bitOfs + totalBits > FLT_MANT_DIG)
		ThrowAbortException("Tried to pack more than 24 bits into a float field");
	
	int_t realVal;
	int_t fracShift = Pow(2, fracBits - 1);
	int_t truncated = Floor(val);
	if (wholeBits >= 1)
	{
		int_t wholeNum;
		int_t wholeShift = Pow(2, wholeBits - 1);
		if (!unsigned)
		{
			wholeNum = truncated & (wholeShift - 1);
			if (val < 0.0)
				wholeNum |= wholeShift;
		}
		else
		{
			wholeNum = truncated & (wholeShift * 2 - 1);
		}
		
		realVal |= wholeNum * fracShift;
	}
	
	realVal |= Floor((val - truncated) * fracShift);
	
	res |= realVal * Pow(2, bitOfs);
	bitOfs += totalBits;
}

float UnpackBits(int_t packed, uint_t bits, __inout uint_t bitOfs, bool_t unsigned = 0)
{
	if (bits < 1)
		ThrowAbortException("Values require at least 1 bit");
	
	bits = Floor(bits);
	if (bitOfs + bits > FLT_MANT_DIG)
		ThrowAbortException("Tried to read more than 24 bits from a float field");
	
	int_t shift = Pow(2, bits - 1);
	int_t value = Floor(packed * Pow(2, -bitOfs)) & (shift * 2 - 1);
	if (bits >= 2 && !unsigned && (value & shift))
	{
		value &= shift - 1;
		value = -value;
	}
	
	bitOfs += bits;
	return value;
}

inline float UnpackFlags(int_t packed, uint_t bits = 24, __inout uint_t bitOfs = 0)
{
	return UnpackBits(packed, bits, bitOfs, TRUE);
}

float UnpackFixed(int_t packed, uint_t wholeBits, uint_t fracBits, __inout uint_t bitOfs, bool_t unsigned = 0)
{
	
}
