
/*******************************************************************************
 * Uniform Data -- Global variables for terrain rendering
 */
layout(std140, column_major, binding = BUFFER_BINDING_TERRAIN_VARIABLES)
uniform PerFrameVariables {
    mat4 u_ModelMatrix;
    mat4 u_ModelViewMatrix;
    mat4 u_ViewMatrix;
    mat4 u_CameraMatrix;
    mat4 u_ViewProjectionMatrix;
    mat4 u_ModelViewProjectionMatrix;
    vec4 u_FrustumPlanes[6];
};

uniform vec3 u_CamPosition;
uniform bool u_Freeze;

// Variáveis para configurar as alturas do terreno
uniform float u_Height0;
uniform float u_Height1;
uniform float u_Height2;
uniform float u_Height3;

// Variáveis para atribuir cores baseadas na altura do terreno
uniform vec3 u_ColorH0;
uniform vec3 u_ColorH1;
uniform vec3 u_ColorH2;
uniform vec3 u_ColorH3;

// Variáveis para definir alterar o ruído em diferentes níveis de altura
uniform float u_NoiseH0;
uniform float u_NoiseH1;
uniform float u_NoiseH2;
uniform float u_NoiseH3;

// Não usa, mas seria para definir se as derivadas analíticas das normais serão utilizadas em booleano
uniform int u_DerivativeNormals;
uniform float u_TargetEdgeLength;
uniform float u_LodFactor;

#if FLAG_DISPLACE
uniform sampler2D u_DmapSampler;
uniform sampler2D u_SmapSampler;
uniform sampler2D u_DmapRockSampler;
uniform sampler2D u_SmapRockSampler;
uniform float u_DmapFactor;
uniform float u_MinLodVariance;
#endif


/*******************************************************************************
 * DecodeTriangleVertices -- Decodes the triangle vertices in local space
 *
 */
vec4[3] DecodeTriangleVertices(in const cbt_Node node)
{
    vec3 xPos = vec3(0, 0, 1), yPos = vec3(1, 0, 0);
    mat2x3 pos = leb_DecodeNodeAttributeArray_Square(node, mat2x3(xPos, yPos));
    vec4 p1 = vec4(pos[0][0], pos[1][0], 0.0, 1.0);
    vec4 p2 = vec4(pos[0][1], pos[1][1], 0.0, 1.0);
    vec4 p3 = vec4(pos[0][2], pos[1][2], 0.0, 1.0);

    

#if FLAG_DISPLACE

    p1.z = u_DmapFactor * texture(u_DmapSampler, p1.xy).r;
    p2.z = u_DmapFactor * texture(u_DmapSampler, p2.xy).r;
    p3.z = u_DmapFactor * texture(u_DmapSampler, p3.xy).r;    

#endif

    return vec4[3](p1, p2, p3);
}

/*******************************************************************************
 * TriangleLevelOfDetail -- Computes the LoD assocaited to a triangle
 *
 * This function is used to garantee a user-specific pixel edge length in
 * screen space. The reference edge length is that of the longest edge of the
 * input triangle.In practice, we compute the LoD as:
 *      LoD = 2 * log2(EdgePixelLength / TargetPixelLength)
 * where the factor 2 is because the number of segments doubles every 2
 * subdivision level.
 */
float TriangleLevelOfDetail_Perspective(in const vec4[3] patchVertices)
{
    vec3 v0 = (u_ModelViewMatrix * patchVertices[0]).xyz;
    vec3 v2 = (u_ModelViewMatrix * patchVertices[2]).xyz;

#if 0 //  human-readable version
    vec3 edgeCenter = (v0 + v2); // division by 2 was moved to u_LodFactor
    vec3 edgeVector = (v2 - v0);
    float distanceToEdgeSqr = dot(edgeCenter, edgeCenter);
    float edgeLengthSqr = dot(edgeVector, edgeVector);

    return u_LodFactor + log2(edgeLengthSqr / distanceToEdgeSqr);
#else // optimized version
    float sqrMagSum = dot(v0, v0) + dot(v2, v2);
    float twoDotAC = 2.0f * dot(v0, v2);
    float distanceToEdgeSqr = sqrMagSum + twoDotAC;
    float edgeLengthSqr     = sqrMagSum - twoDotAC;

    return u_LodFactor + log2(edgeLengthSqr / distanceToEdgeSqr);
#endif
}

/*
    In Orthographic Mode, we have
        EdgePixelLength = EdgeViewSpaceLength / ImagePlaneViewSize * ImagePlanePixelResolution
    and so using some identities we get:
        LoD = 2 * (log2(EdgeViewSpaceLength)
            + log2(ImagePlanePixelResolution / ImagePlaneViewSize)
            - log2(TargetPixelLength))

            = log2(EdgeViewSpaceLength^2)
            + 2 * log2(ImagePlanePixelResolution / (ImagePlaneViewSize * TargetPixelLength))
    so we precompute:
    u_LodFactor = 2 * log2(ImagePlanePixelResolution / (ImagePlaneViewSize * TargetPixelLength))
*/

float TriangleLevelOfDetail_Orthographic(in const vec4[3] patchVertices)
{
    vec3 v0 = (u_ModelViewMatrix * patchVertices[0]).xyz;
    vec3 v2 = (u_ModelViewMatrix * patchVertices[2]).xyz;
    vec3 edgeVector = (v2 - v0);
    float edgeLengthSqr = dot(edgeVector, edgeVector);

    return u_LodFactor + log2(edgeLengthSqr);
}

vec3 Inverse(vec3 x) {return x / dot(x, x);}
vec3 StereographicProjection(vec3 x, vec3 center) {
    return 2.0f * Inverse(x - center) + center;
}
vec3 StereographicProjection(vec3 x) {
    const vec3 center = vec3(0.0f, 0.0f, 1.0f);

    return StereographicProjection(x, center);
}

vec3 ViewSpaceToScreenSpace(vec3 x)
{
    // project onto unit sphere
    float nrmSqr = dot(x, x);
    float nrm = inversesqrt(nrmSqr);
    vec3 xNrm = x * nrm;

    // project onto screen
    vec2 xNdc = StereographicProjection(xNrm).xy;
    return vec3(xNdc, nrmSqr);
}
vec3 WorldToScreenSpace(vec3 x)
{
    // project onto unit sphere
    vec3 camPos = u_CameraMatrix[3].xyz;
    vec3 xStd = x - camPos;
    float nrm = sqrt(dot(xStd, xStd));
    vec3 xStdNrm = xStd / nrm;

    // project onto screen
    vec3 camX = u_CameraMatrix[0].xyz;
    vec3 camY = u_CameraMatrix[1].xyz;
    vec3 camZ = u_CameraMatrix[2].xyz;
    vec3 tmp = StereographicProjection(xStdNrm, camZ);
    return vec3(dot(camX, tmp), dot(camY, tmp), nrm);
}

float TriangleLevelOfDetail_Fisheye(in const vec4[3] patchVertices)
{
    vec3 v0 = (u_ModelViewMatrix * patchVertices[0]).xyz;
    vec3 v2 = (u_ModelViewMatrix * patchVertices[2]).xyz;
    vec3 edgeVector = (v2 - v0);
    float edgeLengthSqr = dot(edgeVector, edgeVector);

    return u_LodFactor + log2(edgeLengthSqr);
}

float TriangleLevelOfDetail(in const vec4[3] patchVertices)
{
    vec3 v0 = (u_ModelViewMatrix * patchVertices[0]).xyz;
    vec3 v2 = (u_ModelViewMatrix * patchVertices[2]).xyz;
#if defined(PROJECTION_RECTILINEAR)
    return TriangleLevelOfDetail_Perspective(patchVertices);
#elif defined(PROJECTION_ORTHOGRAPHIC)
    return TriangleLevelOfDetail_Orthographic(patchVertices);
#elif defined(PROJECTION_FISHEYE)
    return TriangleLevelOfDetail_Perspective(patchVertices);
#else
    return 0.0;
#endif
}

#if FLAG_DISPLACE
/*******************************************************************************
 * DisplacementVarianceTest -- Checks if the height variance criteria is met
 *
 * Terrains tend to have locally flat regions, which don't need large amounts
 * of polygons to be represented faithfully. This function checks the
 * local flatness of the terrain.
 *
 */
bool DisplacementVarianceTest(in const vec4[3] patchVertices)
{
#define P0 patchVertices[0].xy
#define P1 patchVertices[1].xy
#define P2 patchVertices[2].xy
    vec2 P = (P0 + P1 + P2) / 3.0;
    vec2 dx = (P0 - P1);
    vec2 dy = (P2 - P1);
    vec2 dmap = textureGrad(u_DmapSampler, P, dx, dy).rg;
    float dmapVariance = clamp(dmap.y - dmap.x * dmap.x, 0.0, 1.0);

    return (dmapVariance >= u_MinLodVariance);
#undef P0
#undef P1
#undef P2
}
#endif

/*******************************************************************************
 * FrustumCullingTest -- Checks if the triangle lies inside the view frutsum
 *
 * This function depends on FrustumCulling.glsl
 *
 */
bool FrustumCullingTest(in const vec4[3] patchVertices)
{
    vec3 bmin = min(min(patchVertices[0].xyz, patchVertices[1].xyz), patchVertices[2].xyz) - vec3(0.01);
    vec3 bmax = max(max(patchVertices[0].xyz, patchVertices[1].xyz), patchVertices[2].xyz) + vec3(0.01);

    return FrustumCullingTest(u_FrustumPlanes, bmin, bmax);
}

/*******************************************************************************
 * LevelOfDetail -- Computes the level of detail of associated to a triangle
 *
 * The first component is the actual LoD value. The second value is 0 if the
 * triangle is culled, and one otherwise.
 *
 */
vec2 LevelOfDetail(in const vec4[3] patchVertices)
{
    // culling test
    if (!FrustumCullingTest(patchVertices))
#if FLAG_CULL
        return vec2(0.0f, 0.0f);
#else
        return vec2(0.0f, 1.0f);
#endif

#   if FLAG_DISPLACE
    // variance test
    if (!DisplacementVarianceTest(patchVertices))
        return vec2(0.0f, 1.0f);
#endif

    // compute triangle LOD
    return vec2(TriangleLevelOfDetail(patchVertices), 1.0f);
}


/*******************************************************************************
 * BarycentricInterpolation -- Computes a barycentric interpolation
 *
 */
vec2 BarycentricInterpolation(in vec2 v[3], in vec2 u)
{
    return v[1] + u.x * (v[2] - v[1]) + u.y * (v[0] - v[1]);
}

vec4 BarycentricInterpolation(in vec4 v[3], in vec2 u)
{
    return v[1] + u.x * (v[2] - v[1]) + u.y * (v[0] - v[1]);
}

float LOD2(vec3 posV){
    const float BASE_SIZE = 100.0;   // Tamanho base do patch
    const float MAX_LOD = 7.0;     // log2(32) máximo
    
    vec4 wPos = u_ModelMatrix * vec4(posV, 1.0);
    float dist = distance(wPos.xyz, u_CamPosition);
    
    return exp2(int(floor(MAX_LOD - floor(log2(max(dist, BASE_SIZE)/BASE_SIZE)) + 0.5)));
}

//do Simplex.h, com adaptações
int perm[512] = {151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
		151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
		129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
	};

    float grad2lut[8][2] = {
		{ -1.0f, -1.0f }, { 1.0f, 0.0f } , { -1.0f, 0.0f } , { 1.0f, 1.0f } ,
		{ -1.0f, 1.0f } , { 0.0f, -1.0f } , { 0.0f, 1.0f } , { 1.0f, -1.0f }
	};
	
	/*
	 * Gradient directions for 3D.
	 * These vectors are based on the midpoints of the 12 edges of a cube.
	 * A larger array of random unit length vectors would also do the job,
	 * but these 12 (including 4 repeats to make the array length a power
	 * of two) work better. They are not random, they are carefully chosen
	 * to represent a small, isotropic set of directions.
	 */
	
	float grad3lut[16][3] = {
		{ 1.0f, 0.0f, 1.0f }, { 0.0f, 1.0f, 1.0f }, // 12 cube edges
		{ -1.0f, 0.0f, 1.0f }, { 0.0f, -1.0f, 1.0f },
		{ 1.0f, 0.0f, -1.0f }, { 0.0f, 1.0f, -1.0f },
		{ -1.0f, 0.0f, -1.0f }, { 0.0f, -1.0f, -1.0f },
		{ 1.0f, -1.0f, 0.0f }, { 1.0f, 1.0f, 0.0f },
		{ -1.0f, 1.0f, 0.0f }, { -1.0f, -1.0f, 0.0f },
		{ 1.0f, 0.0f, 1.0f }, { -1.0f, 0.0f, 1.0f }, // 4 repeats to make 16
		{ 0.0f, 1.0f, -1.0f }, { 0.0f, -1.0f, -1.0f }
	};
	
	float grad4lut[32][4] = {
		{ 0.0f, 1.0f, 1.0f, 1.0f }, { 0.0f, 1.0f, 1.0f, -1.0f }, { 0.0f, 1.0f, -1.0f, 1.0f }, { 0.0f, 1.0f, -1.0f, -1.0f }, // 32 tesseract edges
		{ 0.0f, -1.0f, 1.0f, 1.0f }, { 0.0f, -1.0f, 1.0f, -1.0f }, { 0.0f, -1.0f, -1.0f, 1.0f }, { 0.0f, -1.0f, -1.0f, -1.0f },
		{ 1.0f, 0.0f, 1.0f, 1.0f }, { 1.0f, 0.0f, 1.0f, -1.0f }, { 1.0f, 0.0f, -1.0f, 1.0f }, { 1.0f, 0.0f, -1.0f, -1.0f },
		{ -1.0f, 0.0f, 1.0f, 1.0f }, { -1.0f, 0.0f, 1.0f, -1.0f }, { -1.0f, 0.0f, -1.0f, 1.0f }, { -1.0f, 0.0f, -1.0f, -1.0f },
		{ 1.0f, 1.0f, 0.0f, 1.0f }, { 1.0f, 1.0f, 0.0f, -1.0f }, { 1.0f, -1.0f, 0.0f, 1.0f }, { 1.0f, -1.0f, 0.0f, -1.0f },
		{ -1.0f, 1.0f, 0.0f, 1.0f }, { -1.0f, 1.0f, 0.0f, -1.0f }, { -1.0f, -1.0f, 0.0f, 1.0f }, { -1.0f, -1.0f, 0.0f, -1.0f },
		{ 1.0f, 1.0f, 1.0f, 0.0f }, { 1.0f, 1.0f, -1.0f, 0.0f }, { 1.0f, -1.0f, 1.0f, 0.0f }, { 1.0f, -1.0f, -1.0f, 0.0f },
		{ -1.0f, 1.0f, 1.0f, 0.0f }, { -1.0f, 1.0f, -1.0f, 0.0f }, { -1.0f, -1.0f, 1.0f, 0.0f }, { -1.0f, -1.0f, -1.0f, 0.0f }
	};
	
	/*
	 * For 3D, we define two orthogonal vectors in the desired rotation plane.
	 * These vectors are based on the midpoints of the 12 edges of a cube,
	 * they all rotate in their own plane and are never coincident or collinear.
	 * A larger array of random vectors would also do the job, but these 12
	 * (including 4 repeats to make the array length a power of two) work better.
	 * They are not random, they are carefully chosen to represent a small
	 * isotropic set of directions for any rotation angle.
	 */
	
	/* a = sqrt(2)/sqrt(3) = 0.816496580 */
    #define a 0.81649658f

	
	void grad3( int hash, out float gx, out float gy, out float gz ) {
		int h = hash & 15;
		gx = grad3lut[h][0];
		gy = grad3lut[h][1];
		gz = grad3lut[h][2];
		return;
	}

/* Skewing factors for 2D simplex grid:
 * F2 = 0.5*(sqrt(3.0)-1.0)
 * G2 = (3.0-Math.sqrt(3.0))/6.0
 */
#define F2 0.366025403f
#define G2 0.211324865f
/* Skewing factors for 3D simplex grid:
 * F3 = 1/3
 * G3 = 1/6 */
#define F3 0.333333333f
#define G3 0.166666667f

// The skewing and unskewing factors are hairy again for the 4D case
#define F4 0.309016994f // F4 = (sqrt(5.0)-1.0)/4.0
#define G4 0.138196601f // G4 = (5.0-sqrt(5.0))/20.0

#define FASTFLOOR(x) ( ((x)>0) ? (int(x)) : ((int(x))-1) )

// Simplex.h
vec4 DerivateNoise(vec3 v)
{
	float n0, n1, n2, n3; /* Noise contributions from the four simplex corners */
	float noise;          /* Return value */
	float gx0, gy0, gz0, gx1, gy1, gz1; /* Gradients at simplex corners */
	float gx2, gy2, gz2, gx3, gy3, gz3;
	
	/* Skew the input space to determine which simplex cell we're in */
	float s = (v.x+v.y+v.z)*F3; /* Very nice and simple skew factor for 3D */
	float xs = v.x+s;
	float ys = v.y+s;
	float zs = v.z+s;
	int i = FASTFLOOR(xs);
	int j = FASTFLOOR(ys);
	int k = FASTFLOOR(zs);
	
	float t = float(i+j+k)*G3;
	float X0 = i-t; /* Unskew the cell origin back to (x,y,z) space */
	float Y0 = j-t;
	float Z0 = k-t;
	float x0 = v.x-X0; /* The x,y,z distances from the cell origin */
	float y0 = v.y-Y0;
	float z0 = v.z-Z0;
	
	/* For the 3D case, the simplex shape is a slightly irregular tetrahedron.
	 * Determine which simplex we are in. */
	int i1, j1, k1; /* Offsets for second corner of simplex in (i,j,k) coords */
	int i2, j2, k2; /* Offsets for third corner of simplex in (i,j,k) coords */
	
	/* TODO: This code would benefit from a backport from the GLSL version! */
	if(x0>=y0) {
		if(y0>=z0)
		{ i1=1; j1=0; k1=0; i2=1; j2=1; k2=0; } /* X Y Z order */
		else if(x0>=z0) { i1=1; j1=0; k1=0; i2=1; j2=0; k2=1; } /* X Z Y order */
		else { i1=0; j1=0; k1=1; i2=1; j2=0; k2=1; } /* Z X Y order */
	}
	else { // x0<y0
		if(y0<z0) { i1=0; j1=0; k1=1; i2=0; j2=1; k2=1; } /* Z Y X order */
		else if(x0<z0) { i1=0; j1=1; k1=0; i2=0; j2=1; k2=1; } /* Y Z X order */
		else { i1=0; j1=1; k1=0; i2=1; j2=1; k2=0; } /* Y X Z order */
	}
	
	/* A step of (1,0,0) in (i,j,k) means a step of (1-c,-c,-c) in (x,y,z),
	 * a step of (0,1,0) in (i,j,k) means a step of (-c,1-c,-c) in (x,y,z), and
	 * a step of (0,0,1) in (i,j,k) means a step of (-c,-c,1-c) in (x,y,z), where
	 * c = 1/6.   */
	
	float x1 = x0 - i1 + G3; /* Offsets for second corner in (x,y,z) coords */
	float y1 = y0 - j1 + G3;
	float z1 = z0 - k1 + G3;
	float x2 = x0 - i2 + 2.0f * G3; /* Offsets for third corner in (x,y,z) coords */
	float y2 = y0 - j2 + 2.0f * G3;
	float z2 = z0 - k2 + 2.0f * G3;
	float x3 = x0 - 1.0f + 3.0f * G3; /* Offsets for last corner in (x,y,z) coords */
	float y3 = y0 - 1.0f + 3.0f * G3;
	float z3 = z0 - 1.0f + 3.0f * G3;
	
	/* Wrap the integer indices at 256, to avoid indexing perm[] out of bounds */
	int ii = i & 0xff;
	int jj = j & 0xff;
	int kk = k & 0xff;
	
	/* Calculate the contribution from the four corners */
	float t0 = 0.6f - x0*x0 - y0*y0 - z0*z0;
	float t20, t40;
	if(t0 < 0.0f) n0 = t0 = t20 = t40 = gx0 = gy0 = gz0 = 0.0f;
	else {
		grad3( perm[ii + perm[jj + perm[kk]]], gx0, gy0, gz0 );
		t20 = t0 * t0;
		t40 = t20 * t20;
		n0 = t40 * ( gx0 * x0 + gy0 * y0 + gz0 * z0 );
	}
	
	float t1 = 0.6f - x1*x1 - y1*y1 - z1*z1;
	float t21, t41;
	if(t1 < 0.0f) n1 = t1 = t21 = t41 = gx1 = gy1 = gz1 = 0.0f;
	else {
		grad3( perm[ii + i1 + perm[jj + j1 + perm[kk + k1]]], gx1, gy1, gz1 );
		t21 = t1 * t1;
		t41 = t21 * t21;
		n1 = t41 * ( gx1 * x1 + gy1 * y1 + gz1 * z1 );
	}
	
	float t2 = 0.6f - x2*x2 - y2*y2 - z2*z2;
	float t22, t42;
	if(t2 < 0.0f) n2 = t2 = t22 = t42 = gx2 = gy2 = gz2 = 0.0f;
	else {
		grad3( perm[ii + i2 + perm[jj + j2 + perm[kk + k2]]], gx2, gy2, gz2 );
		t22 = t2 * t2;
		t42 = t22 * t22;
		n2 = t42 * ( gx2 * x2 + gy2 * y2 + gz2 * z2 );
	}
	
	float t3 = 0.6f - x3*x3 - y3*y3 - z3*z3;
	float t23, t43;
	if(t3 < 0.0f) n3 = t3 = t23 = t43 = gx3 = gy3 = gz3 = 0.0f;
	else {
		grad3( perm[ii + 1 + perm[jj + 1 + perm[kk + 1]]], gx3, gy3, gz3 );
		t23 = t3 * t3;
		t43 = t23 * t23;
		n3 = t43 * ( gx3 * x3 + gy3 * y3 + gz3 * z3 );
	}
	
	/*  Add contributions from each corner to get the final noise value.
	 * The result is scaled to return values in the range [-1,1] */
#ifdef SIMPLEX_DERIVATIVES_RESCALE
	noise = 34.525277436f * (n0 + n1 + n2 + n3);
#else
	noise = 28.0f * (n0 + n1 + n2 + n3);
#endif
	
	/* Compute derivative, if requested by supplying non-null pointers
	 * for the last three arguments */
	/*  A straight, unoptimised calculation would be like:
	 *     *dnoise_dx = -8.0f * t20 * t0 * x0 * dot(gx0, gy0, gz0, x0, y0, z0) + t40 * gx0;
	 *    *dnoise_dy = -8.0f * t20 * t0 * y0 * dot(gx0, gy0, gz0, x0, y0, z0) + t40 * gy0;
	 *    *dnoise_dz = -8.0f * t20 * t0 * z0 * dot(gx0, gy0, gz0, x0, y0, z0) + t40 * gz0;
	 *    *dnoise_dx += -8.0f * t21 * t1 * x1 * dot(gx1, gy1, gz1, x1, y1, z1) + t41 * gx1;
	 *    *dnoise_dy += -8.0f * t21 * t1 * y1 * dot(gx1, gy1, gz1, x1, y1, z1) + t41 * gy1;
	 *    *dnoise_dz += -8.0f * t21 * t1 * z1 * dot(gx1, gy1, gz1, x1, y1, z1) + t41 * gz1;
	 *    *dnoise_dx += -8.0f * t22 * t2 * x2 * dot(gx2, gy2, gz2, x2, y2, z2) + t42 * gx2;
	 *    *dnoise_dy += -8.0f * t22 * t2 * y2 * dot(gx2, gy2, gz2, x2, y2, z2) + t42 * gy2;
	 *    *dnoise_dz += -8.0f * t22 * t2 * z2 * dot(gx2, gy2, gz2, x2, y2, z2) + t42 * gz2;
	 *    *dnoise_dx += -8.0f * t23 * t3 * x3 * dot(gx3, gy3, gz3, x3, y3, z3) + t43 * gx3;
	 *    *dnoise_dy += -8.0f * t23 * t3 * y3 * dot(gx3, gy3, gz3, x3, y3, z3) + t43 * gy3;
	 *    *dnoise_dz += -8.0f * t23 * t3 * z3 * dot(gx3, gy3, gz3, x3, y3, z3) + t43 * gz3;
	 */
	float temp0 = t20 * t0 * ( gx0 * x0 + gy0 * y0 + gz0 * z0 );
	float dnoise_dx = temp0 * x0;
	float dnoise_dy = temp0 * y0;
	float dnoise_dz = temp0 * z0;
	float temp1 = t21 * t1 * ( gx1 * x1 + gy1 * y1 + gz1 * z1 );
	dnoise_dx += temp1 * x1;
	dnoise_dy += temp1 * y1;
	dnoise_dz += temp1 * z1;
	float temp2 = t22 * t2 * ( gx2 * x2 + gy2 * y2 + gz2 * z2 );
	dnoise_dx += temp2 * x2;
	dnoise_dy += temp2 * y2;
	dnoise_dz += temp2 * z2;
	float temp3 = t23 * t3 * ( gx3 * x3 + gy3 * y3 + gz3 * z3 );
	dnoise_dx += temp3 * x3;
	dnoise_dy += temp3 * y3;
	dnoise_dz += temp3 * z3;
	dnoise_dx *= -8.0f;
	dnoise_dy *= -8.0f;
	dnoise_dz *= -8.0f;
	dnoise_dx += t40 * gx0 + t41 * gx1 + t42 * gx2 + t43 * gx3;
	dnoise_dy += t40 * gy0 + t41 * gy1 + t42 * gy2 + t43 * gy3;
	dnoise_dz += t40 * gz0 + t41 * gz1 + t42 * gz2 + t43 * gz3;
	dnoise_dx *= 28.0f; /* Scale derivative to match the noise scaling */
	dnoise_dy *= 28.0f;
	dnoise_dz *= 28.0f;
	
	return vec4( noise, dnoise_dx, dnoise_dy, dnoise_dz );
}

// Derivada analítca do fBm
vec4 DerivativeFBM(vec3 v, int octaves, float lacunarity, float gain )
{
	vec4 sum	= vec4(0.0f);
	float freq		= 1.0f;
	float amp		= 0.5f;
	
	for( int i = 0; i < octaves; i++ ){
		vec4 n	= DerivateNoise( v * freq );
		sum        += n*amp;
		freq       *= lacunarity;
		amp        *= gain;
	}
	
	return sum;
}

/*******************************************************************************
 * GenerateVertex -- Computes the final vertex position
 *
 */
struct VertexAttribute {
    vec4 position;
    vec2 texCoord;
};

VertexAttribute TessellateTriangle(
    in const vec2 texCoords[3],
    in vec2 tessCoord
) {
    vec2 texCoord = BarycentricInterpolation(texCoords, tessCoord);
    vec4 position = vec4(texCoord, 0, 1);

#if FLAG_DISPLACE
    position.z = u_DmapFactor * textureLod(u_DmapSampler, texCoord, 0.0).r;
    
#endif

    return VertexAttribute(position, texCoord);
}


float hash(float n) { return fract(sin(n) * 1e4); }
float hash1(float n) { return fract(sin(n) * 1e4); }
float hash(vec2 p) { return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x)))); }

// de Ricardo
float fnoise(vec3 x) {
	const vec3 step = vec3(110, 241, 171);

	vec3 i = floor(x);
	vec3 f = fract(x);

	// For performance, compute the base input to a 1D hash from the integer part of the argument and the
	// incremental change to the 1D based on the 3D -> 1D wrapping
    float n = dot(i, step);

	vec3 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(mix( hash(n + dot(step, vec3(0, 0, 0))), hash(n + dot(step, vec3(1, 0, 0))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 0))), hash(n + dot(step, vec3(1, 1, 0))), u.x), u.y),
               mix(mix( hash(n + dot(step, vec3(0, 0, 1))), hash(n + dot(step, vec3(1, 0, 1))), u.x),
                   mix( hash(n + dot(step, vec3(0, 1, 1))), hash(n + dot(step, vec3(1, 1, 1))), u.x), u.y), u.z);
}

// função do fBm adaptada para a GPU
float ffbm(vec3 x) {
    float v = 0.0f;
    float amplitude = 0.5f;
    float freq = 1.0;
    float gain = 0.5f;
    float lacunarity = 1.95f;
    for (int i = 0; i < 5; ++i) {
        v += amplitude * fnoise(x*freq);
        freq       *= lacunarity;
        amplitude *= gain;
    }
    return v;
}

float hash3(vec3 p) {
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453123);
}

vec4 noiseDS(vec3 x) {
    vec3 p = floor(x);
    vec3 w = fract(x);
    
    // Quintic interpolation
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);

    // Random hash values at cube corners
    float b = hash3(p+vec3(1,0,0));
    float c = hash3(p+vec3(0,1,0));
    float d = hash3(p+vec3(1,1,0));
    float e = hash3(p+vec3(0,0,1));
    float f = hash3(p+vec3(1,0,1));
    float g = hash3(p+vec3(0,1,1));
    float h = hash3(p+vec3(1,1,1));
	float aa = hash3(p+vec3(0,0,0));
	
    // Coefficients calculation
    float k0 = aa;
    float k1 = b - aa;
    float k2 = c - aa;
    float k3 = e - aa;
    float k4 = aa - b - c + d;
    float k5 = aa - c - e + g;
    float k6 = aa - b - e + f;
    float k7 = -aa + b + c - d + e - f - g + h;

    return vec4(
        k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z,
        du * vec3(
            k1 + k4*u.y + k6*u.z + k7*u.y*u.z,
            k2 + k5*u.z + k4*u.x + k7*u.z*u.x,
            k3 + k6*u.x + k5*u.y + k7*u.x*u.y
        )
    );
}

vec4 fbmDS(vec3 x, int octaves, float lacunarity, float gain) {
    float amplitude = 1.0;
    float frequency = 1.0;
    vec4 total = vec4(0.0);
    mat3 rot = mat3(0.8,-0.6,0.0,
                    0.6,0.8,0.0,
                    0.0,0.0,1.0);
    
    for(int i = 0; i < octaves; i++) {
        vec4 n = noiseDS(x * frequency);
        total += vec4(n.xyz * amplitude, amplitude);
        
        // Accumulate derivatives with proper rotation
        total.xyz += n.yzw * amplitude * frequency;
        
        amplitude *= gain;
        frequency *= lacunarity;
        x = rot * x; // Rotate domain for better noise variation
    }
    return total;
}

vec4 noised(vec3 x )
{
    vec3 p = floor(x);
    vec3 w = fract(x);
    #if 1
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);
    #else
    vec3 u = w*w*(3.0-2.0*w);
    vec3 du = 6.0*w*(1.0-w);
    #endif

    float n = p.x + 317.0*p.y + 157.0*p.z;
    
    float aa = hash1(n+0.0);
    float b = hash1(n+1.0);
    float c = hash1(n+317.0);
    float d = hash1(n+318.0);
    float e = hash1(n+157.0);
	float f = hash1(n+158.0);
    float g = hash1(n+474.0);
    float h = hash1(n+475.0);

    float k0 =   aa;
    float k1 =   b - aa;
    float k2 =   c - aa;
    float k3 =   e - aa;
    float k4 =   aa - b - c + d;
    float k5 =   aa - c - e + g;
    float k6 =   aa - b - e + f;
    float k7 = - aa + b + c - d + e - f - g + h;

    return vec4( -1.0+2.0*(k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z), 
                      2.0* du * vec3( k1 + k4*u.y + k6*u.z + k7*u.y*u.z,
                                      k2 + k5*u.z + k4*u.x + k7*u.z*u.x,
                                      k3 + k6*u.x + k5*u.y + k7*u.x*u.y ) );
}

const mat3 m3  = mat3( 0.00,  0.80,  0.60,
                      -0.80,  0.36, -0.48,
                      -0.60, -0.48,  0.64 );
const mat3 m3i = mat3( 0.00, -0.80, -0.60,
                       0.80,  0.36, -0.48,
                       0.60, -0.48,  0.64 );

bool ComputeDerivateNormals(){
    return bool(u_DerivativeNormals);
}

vec4 fbmd_7( vec3 x, int octaves )
{
    float f = 1.92;
    float s = 0.5;
    float aa = 0.0;
    float b = 0.5;
    vec3  d = vec3(0.0);
    mat3  m = mat3(1.0,0.0,0.0,
                   0.0,1.0,0.0,
                   0.0,0.0,1.0);
    for( int i=0; i<octaves; i++ )
    {
        vec4 n = noised(x);
        aa += b*n.x;          // accumulate values		
        d += b*m*n.yzw;      // accumulate derivatives
        b *= s;
        x = f*m3*x;
        m = f*m3i*m;
    }
	return vec4( aa, d );
}

/*******************************************************************************
 * ShadeFragment -- Fragement shading routine
 *
 */
#ifdef FRAGMENT_SHADER
#if FLAG_WIRE
vec4 ShadeFragment(vec2 texCoord, vec3 worldPos, vec3 vNormal, vec3 distance)
#else
vec4 ShadeFragment(vec2 texCoord, vec3 worldPos, vec3 vNormal)
#endif
{
#if FLAG_WIRE
    const float wireScale = 0.5; // scale of the wire in pixel
    vec4 wireColor = vec4(0.0);
    vec3 distanceSquared = distance * distance;
    float nearestDistance = min(min(distanceSquared.x, distanceSquared.y), distanceSquared.z);
    float blendFactor = exp2(-nearestDistance / wireScale);
#endif

#if FLAG_DISPLACE
    vec3 n;
    if(ComputeDerivateNormals()){
        n = vNormal;
    }
    // compute the slope from the dmap directly
    else{
        float filterSize = 1.0f / float(textureSize(u_DmapSampler, 0).x);
        float sx0 = textureLod(u_DmapSampler, texCoord - vec2(filterSize, 0.0), 0.0).r;
        float sx1 = textureLod(u_DmapSampler, texCoord + vec2(filterSize, 0.0), 0.0).r;
        float sy0 = textureLod(u_DmapSampler, texCoord - vec2(0.0, filterSize), 0.0).r;
        float sy1 = textureLod(u_DmapSampler, texCoord + vec2(0.0, filterSize), 0.0).r;
        float sx = sx1 - sx0;
        float sy = sy1 - sy0;

        n = normalize(vec3(u_DmapFactor * 0.03 / filterSize * 0.5f * vec2(-sx, -sy), 1));
    }
#else
    n = vec3(0, 0, 1);
#endif

#if SHADING_SNOWY
    float d = clamp(n.z, 0.0, 1.0);
    float slopeMag = dot(n.xy, n.xy);
    vec3 albedo = slopeMag > 0.5 ? vec3(0.75) : vec3(2);
    float z = 3.0 * gl_FragCoord.z / gl_FragCoord.w;

    return vec4(mix(vec3(albedo * d / 3.14159), vec3(0.5), 1.0 - exp2(-z)), 1);

#elif SHADING_DIFFUSE
    vec3 wi = normalize(vec3(1.0, 1.0, 1.0));
    float diffuse = dot(wi, n) * 0.5f + 1.0f;
    float peakLevel = u_Height3;
    float snowLevel = u_Height2;
    float rockLevel = u_Height1;
    float sandLevel = u_Height0;
    float waterLevel = 0.0;
    float height = worldPos.y;
    vec3 color;
    vec3 height0 = vec3(u_ColorH0[0],u_ColorH0[1],u_ColorH0[2]);
    vec3 height1 = vec3(u_ColorH1[0],u_ColorH1[1],u_ColorH1[2]);
    vec3 height2 = vec3(u_ColorH2[0],u_ColorH2[1],u_ColorH2[2]);
    vec3 height3 = vec3(u_ColorH3[0],u_ColorH3[1],u_ColorH3[2]);
    vec3 peakColor = height0;

    // Uso do fBm para atribuir cor e definição de mistura de cores para suavizar transições entre alturas
    float noisePeak = ffbm(worldPos * 1.f / u_NoiseH3);
    float noiseRock = ffbm(worldPos * 1.f / u_NoiseH2);
    float noiseSand = ffbm(worldPos * 1.f / u_NoiseH1);
    float noiseWater = ffbm(worldPos * 1.f / u_NoiseH0);
    vec3 snowColor = mix(height0, height1, noisePeak);
    vec3 rockColor = mix(height1, height2, noiseRock);
    vec3 sandColor = mix(height2, height3, noiseSand);
    vec3 waterColor = mix(height3, max(height3-0.55f, 0.0f), noiseWater);

    if (height > peakLevel) {
        color = peakColor; // Branco
    } else if (height > snowLevel) {
        float t = smoothstep(snowLevel, peakLevel, height);
        color = mix(snowColor, peakColor, t);
    } else if (height > rockLevel) {
        float t = smoothstep(rockLevel, snowLevel, height);
        color = mix(rockColor, snowColor, t);
    } else if (height > sandLevel) {    
        float t = smoothstep(sandLevel, rockLevel, height);
        color = mix(sandColor, rockColor, t);
    } else {    
        float t = smoothstep(waterLevel, sandLevel, height);
        color = mix(waterColor, sandColor, t);
    }

    // Atribuição de cor, código original
    vec3 albedo = color;

    vec3 camPos = u_CameraMatrix[3].xyz;
    vec3 extinction;
    vec3 inscatter = inScattering(camPos.zxy + earthPos,
                                  worldPos.zxy + earthPos,
                                  wi.zxy,
                                  extinction);

#if FLAG_WIRE
    vec3 shading = mix(vec3(1.0), wireColor.xyz, blendFactor);
    return vec4(shading, 0.0);
#else
    vec3 shading = (diffuse / 3.14159) * albedo;
#endif

    return vec4(shading * extinction, 1);
#elif SHADING_NORMALS

    return vec4(n*0.5 + 0.5, 1.0);
#elif SHADING_COLOR
    return vec4(vec3(distance(worldPos, u_CamPosition))/10000.f, 1);
#else
    return vec4(1, 0, 0, 1);
#endif
}
#endif
