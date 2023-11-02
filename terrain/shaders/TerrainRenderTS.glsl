/* render.glsl - public domain
by Jonathan Dupuy

    This code has dependencies on the following GLSL sources:
    - TerrainRenderCommon.glsl
    - LongestEdgeBisection.glsl
*/

/*******************************************************************************
 * Vertex Shader
 *
 * The vertex shader is empty
 */
#ifdef VERTEX_SHADER
void main()
{ }
#endif

/*******************************************************************************
 * Tessellation Control Shader
 *
 * This tessellaction control shader is responsible for updating the
 * subdivision buffer and sending geometry to the rasterizer.
 */
#ifdef TESS_CONTROL_SHADER
layout (vertices = 1) out;
out PatchData {
    vec2 texCoords[3];
} o_Patch[];

float LOD(vec3 posV){
    vec3 cam = vec3(inverse(u_ViewProjectionMatrix)[3]);
    float dist = distance(posV, cam);
    return pow(2,int(max(1, log2(dist))));  
}

void main()
{
    const int cbtID = 0;

    // get threadID (each triangle is associated to a thread)
    // and extract triangle vertices
    cbt_Node node = cbt_DecodeNode(cbtID, gl_PrimitiveID);
    vec4 triangleVertices[3] = DecodeTriangleVertices(node);
/* 
    vec3 edgeP1P0 = (triangleVertices[1] - triangleVertices[0]).xyz;
    vec3 edgeP2P0 = (triangleVertices[2] - triangleVertices[0]).xyz;
    vec3 normal = dot(edgeP2P0, edgeP1P0); */

    // texture coordinates
        glm::vec2 uv1(0.0f, 1.0f);
        glm::vec2 uv2(0.0f, 0.0f);
        glm::vec2 uv3(1.0f, 0.0f);
        glm::vec2 uv4(1.0f, 1.0f);
        // normal vector
        glm::vec3 nm(0.0f, 1.0f, 0.0f);

        // calculate tangent/bitangent vectors of both triangles
        glm::vec3 tangent1, bitangent1;
        glm::vec3 tangent2, bitangent2;
        // triangle 1
        // ----------
        glm::vec3 edge1 = pos2 - pos1;
        glm::vec3 edge2 = pos3 - pos1;
        glm::vec2 deltaUV1 = uv2 - uv1;
        glm::vec2 deltaUV2 = uv3 - uv1;

        float f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

        tangent1.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
        tangent1.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
        tangent1.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
        tangent1 = glm::normalize(tangent1);

        bitangent1.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
        bitangent1.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
        bitangent1.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
        bitangent1 = glm::normalize(bitangent1);

        // triangle 2
        // ----------
        edge1 = pos3 - pos1;
        edge2 = pos4 - pos1;
        deltaUV1 = uv3 - uv1;
        deltaUV2 = uv4 - uv1;

        f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

        tangent2.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
        tangent2.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
        tangent2.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
        tangent2 = glm::normalize(tangent2);


        bitangent2.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
        bitangent2.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
        bitangent2.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);
        bitangent2 = glm::normalize(bitangent2);
        
    // compute target LoD
    vec2 targetLod = LevelOfDetail(triangleVertices);

    // splitting pass
#if FLAG_SPLIT
    if (targetLod.x > 1.0) {
        leb_SplitNode_Square(cbtID, node);
    }
#endif

    // merging pass
#if FLAG_MERGE
    if (true) {
        leb_DiamondParent diamond = leb_DecodeDiamondParent_Square(node);
        bool shouldMergeBase = LevelOfDetail(DecodeTriangleVertices(diamond.base)).x < 1.0;
        bool shouldMergeTop = LevelOfDetail(DecodeTriangleVertices(diamond.top)).x < 1.0;

        if (shouldMergeBase && shouldMergeTop) {
            leb_MergeNode_Square(cbtID, node, diamond);
        }
    }
#endif

#if FLAG_CULL
    if (targetLod.y > 0.0) {
#else
    if (true) {
#endif
        // set output data
        o_Patch[gl_InvocationID].texCoords  = vec2[3](
            triangleVertices[0].xy,
            triangleVertices[1].xy,
            triangleVertices[2].xy
        );


        // set tess levels
  
        gl_TessLevelInner[0] =
        gl_TessLevelOuter[0] =
        gl_TessLevelOuter[1] =
        gl_TessLevelOuter[2] = LOD((triangleVertices[0].xyz + triangleVertices[1].xyz + triangleVertices[2].xyz)/3.f);
        //gl_TessLevelOuter[2] = TERRAIN_PATCH_TESS_FACTOR;
   
    }
    else {
        gl_TessLevelInner[0] =
        gl_TessLevelInner[1] =
        gl_TessLevelOuter[0] =
        gl_TessLevelOuter[1] =
        gl_TessLevelOuter[2] = 0.0;
    }
}
#endif

/*******************************************************************************
 * Tessellation Evaluation Shader
 *
 * This tessellaction evaluation shader is responsible for placing the
 * geometry properly on the input mesh (here a terrain).
 */
#ifdef TESS_EVALUATION_SHADER
layout (triangles, ccw, equal_spacing) in;
in PatchData {
    vec2 texCoords[3];
} i_Patch[];

layout(location = 0) out vec2 o_TexCoord;
layout(location = 1) out vec3 o_WorldPos;

void main()
{
    // compute final vertex attributes
    VertexAttribute attrib = TessellateTriangle(
        i_Patch[0].texCoords,
        gl_TessCoord.xy
    );

    // set varyings
    gl_Position = u_ModelViewProjectionMatrix * attrib.position;
    o_TexCoord  = attrib.texCoord;
    
    o_WorldPos  = (u_ModelMatrix * attrib.position).xyz;
}
#endif

/*******************************************************************************
 * Fragment Shader -- Shades the terrain
 *
 */
#ifdef FRAGMENT_SHADER
layout(location = 0) in vec2 i_TexCoord;
layout(location = 1) in vec3 i_WorldPos;
layout(location = 0) out vec4 o_FragColor;

void main()
{
    o_FragColor = ShadeFragment(i_TexCoord, i_WorldPos);
}
#endif
