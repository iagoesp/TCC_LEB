#version 450

layout(local_size_x = 16, local_size_y = 16) in;

// Uniformes para parâmetros de ruído
uniform int seeds;
uniform int mountain_inverse;
uniform int noise;

uniform int scaleTER;
uniform int octavesFBM;
uniform float wavelengthFBM;
uniform float lacunarityFBM;
uniform float gainFBM;
uniform int getValleyFBM;

uniform float ridgeOffset;
uniform int getValley;
uniform int octavesRMF;
uniform float wavelengthRMF;
uniform float lacunarityRMF;
uniform float gainRMF;

// Implementação das funções de ruído (implemente aqui suas funções de ruído)

float calcSurfaceNoise(vec3 pos) {
    // Implemente sua função de ruído aqui, similar ao calcSurfaceNoise em C++
    // Retorne o valor de altura
}

void main() {
    ivec2 coords = ivec2(gl_GlobalInvocationID.xy);
    ivec2 imageSize = imageSize(heightmapImage);

    if (coords.x >= imageSize.x || coords.y >= imageSize.y)
        return;

    int w = imageSize.x;
    int h = imageSize.y;

    float tamAmostra = 0.0005; // Ajuste conforme necessário

    float x = coords.x * tamAmostra;
    float z = coords.y * tamAmostra;

    vec3 pos = vec3(x, 0.0, z);

    float h = calcSurfaceNoise(pos);
    if (mountain_inverse == 0) // MONTANHA
        h = h;
    else if (mountain_inverse == 1) // INVERSO
        h = 1.0 - h;

    // Armazene a altura em heightmapImage
    imageStore(heightmapImage, coords, vec4(h, h*h, 0.0, 0.0));

    // Computar normais
    // Obtenha as alturas dos pixels vizinhos para calcular os gradientes
    // Compute as normais usando diferenças finitas

    // Exemplo simplificado:
    float hL = calcSurfaceNoise(vec3(x - tamAmostra, 0.0, z));
    float hR = calcSurfaceNoise(vec3(x + tamAmostra, 0.0, z));
    float hD = calcSurfaceNoise(vec3(x, 0.0, z - tamAmostra));
    float hU = calcSurfaceNoise(vec3(x, 0.0, z + tamAmostra));

    float dx = (hR - hL) / (2.0 * tamAmostra);
    float dz = (hU - hD) / (2.0 * tamAmostra);

    vec3 normal = normalize(vec3(-dx, 1.0, -dz));

    // Armazene a normal em normalMapImage
    imageStore(normalMapImage, coords, vec4(normal * 0.5 + 0.5, 1.0));
}
