#version 450

layout(local_size_x = 16, local_size_y = 16)in;

uniform int uWidth;
uniform int uHeight;
uniform float uScale;
uniform int uSeed;
uniform int uOctaves;
uniform float uLacunarity;
uniform float uGain;
uniform float uWavelength;
uniform float uValley;
uniform int uMountainInverse;

layout(binding = 0, std430) buffer Heights {
    float heights[];
};

// Função de ruído simples (para exemplo)
float hash(vec3 p) {
    return fract(sin(dot(p ,vec3(12.9898,78.233, 54.53))) * 43758.5453);
}

float noise(vec3 p) {
    vec3 ip = floor(p);
    vec3 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(
            mix(hash(ip + vec3(0.0,0.0,0.0)), hash(ip + vec3(1.0,0.0,0.0)), u.x),
            mix(hash(ip + vec3(0.0,1.0,0.0)), hash(ip + vec3(1.0,1.0,0.0)), u.x), u.y),
        mix(
            mix(hash(ip + vec3(0.0,0.0,1.0)), hash(ip + vec3(1.0,0.0,1.0)), u.x),
            mix(hash(ip + vec3(0.0,1.0,1.0)), hash(ip + vec3(1.0,1.0,1.0)), u.x), u.y), u.z);
    return res;
}

float fbm(vec3 pos, int octaves, float gain, float lacunarity, float wavelength){
    float total = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0 / wavelength;    for(int i = 0; i < octaves; i++){
        total += amplitude * noise(pos * frequency);
        frequency *= lacunarity;
        amplitude *= gain;
    }

    return total;
}

void main() {
    uint x = gl_GlobalInvocationID.x;
    uint y = gl_GlobalInvocationID.y;

    if (x >= uint(uWidth) || y >= uint(uHeight))
        return;

    int index = int(y * uint(uWidth) + x);

    vec3 pos = vec3(float(x) * uScale, 0.0, float(y) * uScale);

    float sn = fbm(pos, uOctaves, uGain, uLacunarity, uWavelength);

    // Aplicar transformações conforme necessário
    if (uMountainInverse == 0) { // MONTANHA
        // Nenhuma alteração necessária
    } else if (uMountainInverse == 1) { // INVERSO
        sn = 1.0 - sn;
    }

    if (sn < 0.0 && uValley >= 1.0) {
        sn = abs(sn);
        sn = pow(sn, uValley);
    } else {
        sn = pow(sn, uValley);
    }

    heights[index] = sn;
}
