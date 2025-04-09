#version 450 core

layout(local_size_x = 16, local_size_y = 16) in;

layout(binding = 0, std430) buffer HeightmapBuffer {
    vec2 heightmap[];  // RG16 format (height, height²)
};

uniform int size;
uniform int seed;
uniform float elevation;
uniform int octaves;
uniform float wavelength;
uniform float lacunarity;
uniform float gain;

const int PERM_SIZE = 256;
int perm[PERM_SIZE * 2];

void initPermutationTable(int seed) {
    for (int i = 0; i < PERM_SIZE; i++) {
        perm[i] = i;
    }

    for (int i = PERM_SIZE - 1; i > 0; i--) {
        int j = ((seed * 1664525 + 1013904223) ^ (i * 467)) % (i + 1);
        if (j < 0) j += (i + 1);
        
        int temp = perm[i];
        perm[i] = perm[j];
        perm[j] = temp;
    }
    
    for (int i = 0; i < PERM_SIZE; i++) {
        perm[i + PERM_SIZE] = perm[i];
    }
}

float grad(int hash, float x, float y) {
    int h = hash & 7;      // Convert low 3 bits of hash code
    float u = h<4 ? x : y;  // into 8 simple gradient directions,
    float v = h<4 ? y : x;  // and compute the dot product with (x,y).
    return (bool(h&1)? -u : u) + (bool(h&2)? -2.0f*v : 2.0f*v);
}

int hash(int x, int y) {
    int h = perm[(x + seed * 3) & 0xFF];
    return perm[(h + y + seed) & 0xFF];
}

#define FASTFLOOR(x) (int(floor(x)))
#define F2 0.366025403f  // 0.5*(sqrt(3.0)-1.0)
#define G2 0.211324865f  // (3.0-sqrt(3.0))/6.0

// Simplex noise 2D
float noise(vec2 v) {
	float n0, n1, n2; // Noise contributions from the three corners
	
	// Skew the input space to determine which simplex cell we're in
	float s = (v.x+v.y)*F2; // Hairy factor for 2D
    float xs = v.x + s;
    float ys = v.y + s;
    int i = FASTFLOOR(xs);
    int j = FASTFLOOR(ys);
    
    float t = float(i+j)*G2;
    float X0 = i-t; // Unskew the cell origin back to (x,y) space
    float Y0 = j-t;
    float x0 = v.x-X0; // The x,y distances from the cell origin
    float y0 = v.y-Y0;

	// For the 2D case, the simplex shape is an equilateral triangle.
	// Determine which simplex we are in.
	int i1, j1; // Offsets for second (middle) corner of simplex in (i,j) coords
	if(x0>y0) {i1=1; j1=0;} // lower triangle, XY order: (0,0)->(1,0)->(1,1)
	else {i1=0; j1=1;}      // upper triangle, YX order: (0,0)->(0,1)->(1,1)
    
    // A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
    // a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
    // c = (3-sqrt(3))/6
    
    float x1 = x0 - i1 + G2; // Offsets for middle corner in (x,y) unskewed coords
    float y1 = y0 - j1 + G2;
    float x2 = x0 - 1.0f + 2.0f * G2; // Offsets for last corner in (x,y) unskewed coords
    float y2 = y0 - 1.0f + 2.0f * G2;
    
    // Wrap the integer indices at 256, to avoid indexing perm[] out of bounds
    int ii = i & 0xff;
    int jj = j & 0xff;
    
    // Calculate the contribution from the three corners
    float t0 = 0.5f - x0*x0-y0*y0;
    if(t0 < 0.0f) n0 = 0.0f;
    else {
        t0 *= t0;
        n0 = t0 * t0 * grad(perm[ii+perm[jj]], x0, y0);
    }
    
    float t1 = 0.5f - x1*x1-y1*y1;
    if(t1 < 0.0f) n1 = 0.0f;
    else {
        t1 *= t1;
        n1 = t1 * t1 * grad(perm[ii+i1+perm[jj+j1]], x1, y1);
    }
    
    float t2 = 0.5f - x2*x2-y2*y2;
    if(t2 < 0.0f) n2 = 0.0f;
    else {
        t2 *= t2;
        n2 = t2 * t2 * grad(perm[ii+1+perm[jj+1]], x2, y2);
    }
    
    // Add contributions from each corner to get the final noise value.
    // The result is scaled to return values in the interval [-1,1].
    return 40.0f * (n0 + n1 + n2); // Increased scaling factor for more pronounced features
}

float fbm(vec2 pos, int octaves, float gain, float lacunarity)
{    
    float f = 1.0f;
    float a = 0.5f;
    float sum = 0.0;
    for( int i=0; i<octaves; i++ )
    {
        sum += a*noise(f*pos);
        f *= lacunarity;
        a *= gain;
    }
    return sum;
}

float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

float gx0, gy0, gx1, gy1, gx2, gy2;

float grad2lut[8][2] = {
    { -1.0f, -1.0f }, { 1.0f, 0.0f } , { -1.0f, 0.0f } , { 1.0f, 1.0f } ,
    { -1.0f, 1.0f } , { 0.0f, -1.0f } , { 0.0f, 1.0f } , { 1.0f, -1.0f }
};
void grad20( int hash) {
    int h = hash & 7;
    gx0 = grad2lut[h][0];
    gy0 = grad2lut[h][1];
    return;
}
void grad21( int hash) {
    int h = hash & 7;
    gx1 = grad2lut[h][0];
    gy1 = grad2lut[h][1];
    return;
}
void grad22( int hash) {
    int h = hash & 7;
    gx2 = grad2lut[h][0];
    gy2 = grad2lut[h][1];
    return;
}
vec3 dnoise( vec2 v )
{
	float n0, n1, n2; // Noise contributions from the three corners
	
	// Skew the input space to determine which simplex cell we're in
	float s = (v.x+v.y)*F2; // Hairy factor for 2D
	float xs = v.x + s;
	float ys = v.y + s;
	int i = FASTFLOOR(xs);
	int j = FASTFLOOR(ys);
	
	float t = float(i+j)*G2;
	float X0 = i-t; // Unskew the cell origin back to (x,y) space
	float Y0 = j-t;
	float x0 = v.x-X0; // The x,y distances from the cell origin
	float y0 = v.y-Y0;
	
	// For the 2D case, the simplex shape is an equilateral triangle.
	// Determine which simplex we are in.
	int i1, j1; // Offsets for second (middle) corner of simplex in (i,j) coords
	if(x0>y0) {i1=1; j1=0;} // lower triangle, XY order: (0,0)->(1,0)->(1,1)
	else {i1=0; j1=1;}      // upper triangle, YX order: (0,0)->(0,1)->(1,1)
	
	// A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
	// a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
	// c = (3-sqrt(3))/6
	
	float x1 = x0 - i1 + G2; // Offsets for middle corner in (x,y) unskewed coords
	float y1 = y0 - j1 + G2;
	float x2 = x0 - 1.0f + 2.0f * G2; // Offsets for last corner in (x,y) unskewed coords
	float y2 = y0 - 1.0f + 2.0f * G2;
	
	// Wrap the integer indices at 256, to avoid indexing perm[] out of bounds
	int ii = i & 0xff;
	int jj = j & 0xff;
	

/* Calculate the contribution from the three corners */
	float t0 = 0.5f - x0 * x0 - y0 * y0;
	float t20, t40;
	if( t0 < 0.0f ) t40 = t20 = t0 = n0 = gx0 = gy0 = 0.0f; /* No influence */
	else {
		grad20( perm[ii + perm[jj]]);
		t20 = t0 * t0;
		t40 = t20 * t20;
		n0 = t40 * ( gx0 * x0 + gy0 * y0 );
	}
	
	float t1 = 0.5f - x1 * x1 - y1 * y1;
	float t21, t41;
	if( t1 < 0.0f ) t21 = t41 = t1 = n1 = gx1 = gy1 = 0.0f; /* No influence */
	else {
		grad21( perm[ii + i1 + perm[jj + j1]]);
		t21 = t1 * t1;
		t41 = t21 * t21;
		n1 = t41 * ( gx1 * x1 + gy1 * y1 );
	}
	
	float t2 = 0.5f - x2 * x2 - y2 * y2;
	float t22, t42;
	if( t2 < 0.0f ) t42 = t22 = t2 = n2 = gx2 = gy2 = 0.0f; /* No influence */
	else {
		grad22( perm[ii + 1 + perm[jj + 1]]);
		t22 = t2 * t2;
		t42 = t22 * t22;
		n2 = t42 * ( gx2 * x2 + gy2 * y2 );
	}
	
	/* Compute derivative, if requested by supplying non-null pointers
	 * for the last two arguments */
	/*  A straight, unoptimised calculation would be like:
	 *    *dnoise_dx = -8.0f * t20 * t0 * x0 * ( gx0 * x0 + gy0 * y0 ) + t40 * gx0;
	 *    *dnoise_dy = -8.0f * t20 * t0 * y0 * ( gx0 * x0 + gy0 * y0 ) + t40 * gy0;
	 *    *dnoise_dx += -8.0f * t21 * t1 * x1 * ( gx1 * x1 + gy1 * y1 ) + t41 * gx1;
	 *    *dnoise_dy += -8.0f * t21 * t1 * y1 * ( gx1 * x1 + gy1 * y1 ) + t41 * gy1;
	 *    *dnoise_dx += -8.0f * t22 * t2 * x2 * ( gx2 * x2 + gy2 * y2 ) + t42 * gx2;
	 *    *dnoise_dy += -8.0f * t22 * t2 * y2 * ( gx2 * x2 + gy2 * y2 ) + t42 * gy2;
	 */
	float temp0 = t20 * t0 * ( gx0* x0 + gy0 * y0 );
	float dnoise_dx = temp0 * x0;
	float dnoise_dy = temp0 * y0;
	float temp1 = t21 * t1 * ( gx1 * x1 + gy1 * y1 );
	dnoise_dx += temp1 * x1;
	dnoise_dy += temp1 * y1;
	float temp2 = t22 * t2 * ( gx2* x2 + gy2 * y2 );
	dnoise_dx += temp2 * x2;
	dnoise_dy += temp2 * y2;
	dnoise_dx *= -8.0f;
	dnoise_dy *= -8.0f;
	dnoise_dx += t40 * gx0 + t41 * gx1 + t42 * gx2;
	dnoise_dy += t40 * gy0 + t41 * gy1 + t42 * gy2;
	dnoise_dx *= 40.0f; /* Scale derivative to match the noise scaling */
	dnoise_dy *= 40.0f;
	
	// Add contributions from each corner to get the final noise value.
	// The result is scaled to return values in the interval [-1,1].
#ifdef SIMPLEX_DERIVATIVES_RESCALE
	return vec3( 70.175438596f * (n0 + n1 + n2), dnoise_dx, dnoise_dy ); // TODO: The scale factor is preliminary!
#else
	return vec3( 40.0f * (n0 + n1 + n2), dnoise_dx, dnoise_dy ); // TODO: The scale factor is preliminary!
#endif
}

vec3 dfBm( vec2 v, int octaves, float lacunarity, float gain )
{
	vec3 sum	= vec3( 0.0f );
	float freq		= 1.0f;
	float amp		= 0.5f;
	
	for( int i = 0; i < octaves; i++ ){
		vec3 n	= dnoise( v * freq );
		sum        += n*amp;
		freq       *= lacunarity;
		amp        *= gain;
	}
	
	return sum;
}

void main() {
    uint x = gl_GlobalInvocationID.x;
    uint y = gl_GlobalInvocationID.y;
    
    if (x >= uint(size) || y >= uint(size)) {
        return;
    }
    
    initPermutationTable(seed);
    
    vec2 pos = vec2(float(x), float(y));
    pos /= wavelength;
    
    float height = 0.0;
    height = abs(dfBm(pos, octaves, lacunarity, gain).x);
    height = pow(height, elevation);

    uint index = y * uint(size) + x;
    heightmap[index] = vec2(height, height * height);
}