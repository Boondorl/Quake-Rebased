// Try and inline math functions as much as possible to reduce their overhead in normal computations. Functions
// in QuakeC are quite expensive since the VM is very old so inlines and, if needed, macros are preferred

const float M_E			= 2.71828183;
const float M_LOG2E		= 1.44269504;
const float M_LOG10E	= 0.43429448;
const float M_LN2		= 0.69314718;
const float M_LN10		= 2.30258509;
const float M_1_LN2		= 1.44269504;
const float M_1_LN10	= 0.43429448;
const float M_PI		= 3.14159265;
const float M_PI_2		= 1.57079633;
const float M_PI_4		= 0.78539816;
const float M_1_PI		= 0.31830989;
const float M_2_PI		= 0.63661977;
const float M_2_SQRTPI	= 1.12837917;
const float M_SQRT2		= 1.41421356;
const float M_SQRT1_2	= 0.70710678;
const float M_1_3		= 0.33333333;	// Pretty commonly needed number for things
const float RAD_2_DEG	= 180.0 / M_PI;
const float DEG_2_RAD	= M_PI / 180.0;

enum : int_t
{
	AXIS_FORWARD,
	AXIS_RIGHT,
	AXIS_UP,
};

// For storing the globals locally
typedef struct
{
	vector axes[3];
} matrix_t;

void AngsToMatrix(angles_t angs, __out matrix_t res)
{
	SetLocalAxes(angs);
	res.axes[AXIS_FORWARD] = v_forward;
	res.axes[AXIS_RIGHT] = v_right;
	res.axes[AXIS_UP] = v_up;
}

inline void FixedAngsToMatrix(angles_t angs, __out matrix_t res)
{
	AngsToMatrix([-angs.x, angs.y, angs.z], res);
}

inline void VecToMatrix(vector dir, __out matrix_t res)
{
	angles_t angs = ToAngles(dir);
	AngsToMatrix([-angs.x, angs.y, angs.z], res);
}

inline vector Unit(vector v, float length)
{
	return Normalize(v) * length;
}

inline vector Diff(vector a, vector b)
{
	return b - a;
}

inline vector Diff2D(vector a, vector b)
{
	vector v = b - a;
	return [v.x, v.y, 0.0];
}

inline float Distance(vector a, vector b)
{
	return Length(b - a);
}

inline float DistanceSq(vector a, vector b)
{
	vector v = b - a;
	return v.x*v.x + v.y*v.y + v.z*v.z;
}

inline float Distance2D(vector a, vector b)
{
	vector v = b - a;
	return Length([v.x, v.y, 0.0]);
}

inline float Distance2DSq(vector a, vector b)
{
	vector v = b - a;
	return v.x*v.x + v.y*v.y;
}

inline float LengthSq(vector v)
{
	return v.x*v.x + v.y*v.y + v.z*v.z;
}

inline float Length2D(vector v)
{
	return Length([v.x, v.y, 0.0]);
}

inline float Length2DSq(vector v)
{
	return v.x*v.x + v.y*v.y;
}

inline vector AbsV(vector v)
{
	return [AbsF(v.x), AbsF(v.y), AbsF(v.z)];
}

inline float CRandom()
{
	return 2.0 * (Random() - 0.5);
}

inline float RandomF(float f)
{
	return f * Random();
}

inline int_t RandomI(int_t i = 255)
{
	return Round(i * Random());
}

// Guarantees a non-zero value for random time offsets
inline float RandomTime(float f)
{
	return TIME_EPSILON + (f - TIME_EPSILON) * Random();
}

inline float RandomRangeF(float min, float max)
{
	return min + (max - min) * Random();
}

inline int_t RandomRangeI(int_t min, int_t max)
{
	return min + Round((max - min) * Random());
}

inline vector RandomV(float length = 1.0)
{
	return [Random(), Random(), Random()] * length;
}

inline vector CRandomV(float length = 1.0)
{
	return [2.0*(Random()-0.5), 2.0*(Random()-0.5), 2.0*(Random()-0.5)] * length;
}

inline vector RandomDir(float length = 1.0)
{
	return Normalize([2.0*(Random()-0.5), 2.0*(Random()-0.5), 2.0*(Random()-0.5)]) * length;
}

inline float LerpF(float a, float b, float t)
{
	return a * (1.0 - t) + b * t;
}

inline vector LerpV(vector a, vector b, float t)
{
	return a * (1.0 - t) + b * t;
}

inline vector QuadraticBezierCurve(vector a, vector b, vector c, float t)
{
	float u = 1.0 - t;
	return a * (u*u) + b * (2.0*u*t) + c * (t*t);
}

// Use a simple approximation for this since high precision isn't needed
inline float QuadraticBezierLength(vector a, vector b, vector c)
{
	float chord = Length(c - a);
	float perimeter = Length(b-a) + Length(c-b);
	return (2.0 * chord + perimeter) * M_1_3;
}

inline vector CubicBezierCurve(vector a, vector b, vector c, vector d, float t)
{
	float u = 1.0 - t;
	float u2 = u * u;
	float t2 = t * t;
	return a * (u2*u) + b * (3.0*u2*t) + c * (3.0*u*t2) + d * (t2*t);
}

// Cubic Beziers are a lot harder to approximate, so just sum up the lengths of its
// segments. This gets more expensive the more steps there are, so only use more steps
// if higher precision is needed
float CubicBezierLength(vector a, vector b, vector c, vector d, int_t steps = 10)
{
	float dist;
	vector lastPos = a;
	for (float i = 1.0; i < steps; ++i)
	{
		vector pos = CubicBezierCurve(a, b, c, d, i / steps);
		dist += Length(pos - lastPos);
		lastPos = pos;
	}
	
	return dist + Length(d - lastPos);
}

inline float NormalizeAngle360(float ang)
{
	return ((ang % 360.0) + 360.0) % 360.0;
}

float NormalizeAngle180(float ang)
{
	float norm = NormalizeAngle360(ang);
	if (norm > 180.0)
		norm -= 360.0;
	
	return norm;
}

inline int_t Sign(float f)
{
	return (0.0 < f) - (f < 0.0);
}

float Min(float f, float a)
{
	return f < a ? f : a;
}

float Max(float f, float a)
{
	return f > a ? f : a;
}

float Clamp(float f, float a, float b)
{
	if (f < a)
		return a;
	if (f > b)
		return b;
	return f;
}

// Returns values in degrees similar to the builtins
float Acos(float x)
{
	float negate = Sign(x) < 0;
	x = AbsF(x);
	float res = (((-0.0187293 * x + 0.0742610) * x - 0.2121144) * x + 1.5707288) * Sqrt(1.0 - x);
	res = res - 2.0 * negate * res;
	return (negate * M_PI + res) * RAD_2_DEG;
}

float Asin(float x)
{
	float negate = Sign(x) < 0;
	x = AbsF(x);
	float res = ((-0.0187293 * x + 0.0742610) * x - 0.2121144) * x + 1.5707288;
	res = M_PI_2 - Sqrt(1.0 - x) * res;
	return (res - 2.0 * negate * res) * RAD_2_DEG;
}

// Unlike the built-in this one doesn't clamp the range to integers. Has precision
// out to 3 decimal places
float Atan2(vector vec)
{
	float absX = AbsF(vec.x);
	float absY = AbsF(vec.y);
	
	float min, max;
	if (absX < absY)
	{
		min = absX;
		max = absY;
	}
	else
	{
		min = absY;
		max = absX;
	}
	
	float a = max == 0.0 ? 0.0 : min / max;
	float s = a * a;
	float r = ((-0.0464964749 * s + 0.15931422) * s - 0.327622764) * s * a + a;
	if (absY > absX)
		r = M_PI_2 - r;
	if (Sign(vec.x) < 0)
		r = M_PI - r;
	if (Sign(vec.y) < 0)
		r = -r;
	
	return r * RAD_2_DEG;
}

inline float Atan(float x)
{
	return Atan2([x, 1.0, 0.0]);
}

// Like Atan2, doesn't clamp the angles to integers. Pitch is purposely
// not inverted since it's commonly used with .angles which expects the
// pitch to be inverted
vector ToAngles(vector vec)
{
	vector res;
	res.x = Atan2([Length2D(vec), vec.z, 0.0]);
	res.y = Atan2(vec);
	return res;
}

// This is very expensive and should be used sparingly. Use precalculated
// Euler angles instead of converting if at all possible
vector CosSinTan(float ang)
{
	vector curForward = v_forward;
	vector curRight = v_right;
	vector curUp = v_up;
	
	SetLocalAxes([0.0, ang, 0.0]);
	vector cst = v_forward;
	cst.z = cst.x ? cst.y / cst.x : FLT_MAX; // No infinity to put here, so use FLT_MAX instead
	
	v_forward = curForward;
	v_right = curRight;
	v_up = curUp;
	
	return cst;
}

// Also expensive, so avoid using commonly
float Sqrt(float f, float acc = 0.001)
{
	// No imaginary numbers allowed! You're not even real!
	if (f < 0.0)
		ThrowAbortException("Non-real answer in Sqrt");
	
	if (!f || f == 1.0)
		return f;
	
	float root;
	for (float x = 2.0;; x = root)
	{
		root = (x + (f / x)) * 0.5;
		if (AbsF(root - x) <= acc)
			break;
	}
	
	return root;
}

// Don't use this for simple operations where you know what the power will be;
// only use it if a dynamic power is needed. Note that currently it doesn't
// support fractional powers
float Pow(float f, int_t p)
{
	if (!p)
		return 1.0;
	
	bool_t inverse = p < 0;
	p = AbsF(p);
	for (int_t i = 1; i < p; ++i)
		f *= f;
	
	return inverse ? 1.0 / f : f;
}

// e^x
inline float Exp(int_t p)
{
	return Pow(M_E, p);
}

float Ln(float f)
{
	if (f <= 0.0)
		ThrowAbortException("Domain range error in Ln");
	
	float result;
	if (f >= 1.0)
	{
		// Normalize into [1, 2]
		uint_t log2;
		uint_t i = Floor(f);
		while ((i = Floor(i * 0.5)))
			++log2;
		
		float x = f / Pow(2.0, log2);
		result = -1.7417939 + (2.8212026 + (-1.4699568 + (0.44717955 - 0.056570851 * x) * x) * x) * x;
		result += log2 * M_LN2;
	}
	else
	{
		// This requires something a bit trickier, so do a log2 estimate instead
		// and then convert it to base e
		float f2 = f * f;
		result = (-5.83261 - 16.7012 * f + 22.394 * f2) / (1.0 + 11.2638 * f + 7.81124 * f2) * M_LN2;
	}
	
	return result;
}

inline float Logn(float f, float n)
{
	return Ln(f) / Ln(n);
}

inline float Log2(float f)
{
	return Ln(f) * M_1_LN2;
}

inline float Log10(float f)
{
	return Ln(f) * M_1_LN10;
}

// Returns two normalized values across a standard deviation range
// This has no clamping so values returned can be quite large if not
// properly clamped
vector CalculateGaussian(float standDev = 1.0)
{
	float x, y, s;
	do
	{
		x = CRandom();
		y = CRandom();
		s = x * x + y * y;
	} while (s >= 1.0 || !s);

	s = Sqrt(-2.0 * Ln(s) / s) * standDev;

	return [x * s, y * s, 0.0];
}

// Meant for grabbing the nearest point on an entity's bbox instead of
// always checking against its origin
vector GetNearestPoint(vector orig, vector min, vector max)
{
	vector nearest;
	nearest.x = Max(min.x, Min(orig.x, max.x));
	nearest.y = Max(min.y, Min(orig.y, max.y));
	nearest.z = Max(min.z, Min(orig.z, max.z));
	
	return nearest;
}

vector RotateVector(vector curDir, vector wishDir, float maxAng, float length = 1.0)
{
	if (curDir * wishDir >= maxAng)
		return wishDir * length;
	
	float c = maxAng;
	float s = Sqrt(1.0 - c * c);
	vector rot = Normalize(curDir >< wishDir);
	
	return Normalize(curDir * c + (rot >< curDir) * s + rot * (rot * curDir) * (1.0 - c)) * length;
}

// For projectiles that want to account for gravity
float GetZTrajectory(vector orig, vector destOrig, float grav, float spd)
{
	if (spd <= 0.0)
		return 0.0;
	
	float travelTime = Distance(orig, destOrig) / spd;
	float g = -GetCVarF("sv_gravity") * grav;
	return ((destOrig.z - orig.z) - 0.5*g*travelTime*travelTime) / travelTime;
}

vector ArcTrajectory(vector dir, float pitchOfs, float maxPitch = 90.0, float grav = 1.0)
{
	angles_t angs = ToAngles(dir);
	
	float realOfs = pitchOfs;
	if (maxPitch > 0.0)
		realOfs *= Max(0.0, 1.0 - AbsF(NormalizeAngle180(angs.x)) / maxPitch);
	if (grav)
		realOfs *= GetCVarF("sv_gravity") * 0.00125 * grav;
	
	FixedLocalAxes(angs);
	
	return Normalize(v_forward + v_up * realOfs);
}
