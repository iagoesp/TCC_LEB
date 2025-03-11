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



void main()
{
    const int cbtID = 0;

    // get threadID (each triangle is associated to a thread)
    // and extract triangle vertices
    cbt_Node node = cbt_DecodeNode(cbtID, gl_PrimitiveID);
    vec4 triangleVertices[3] = DecodeTriangleVertices(node);
        
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

        if(!u_Freeze){
            // Calcula o ponto médio de cada borda do triângulo
            vec3 edgeMid0 = (triangleVertices[0].xyz + triangleVertices[1].xyz) / 2.0;
            vec3 edgeMid1 = (triangleVertices[1].xyz + triangleVertices[2].xyz) / 2.0;
            vec3 edgeMid2 = (triangleVertices[2].xyz + triangleVertices[0].xyz) / 2.0;

            // Usa os pontos médios das bordas para os outer levels e define níveis de tesselação usando LOD2()
            gl_TessLevelOuter[0] = LOD2(edgeMid0); // Borda entre vértices 0 e 1
            gl_TessLevelOuter[1] = LOD2(edgeMid1); // Borda entre vértices 1 e 2
            gl_TessLevelOuter[2] = LOD2(edgeMid2); // Borda entre vértices 2 e 0

            // Para o Inner, usa o centro do triângulo
            vec3 center = (triangleVertices[0].xyz + triangleVertices[1].xyz + triangleVertices[2].xyz) / 3.0;
            gl_TessLevelInner[0] = LOD2(center);
        }
        else{
            gl_TessLevelInner[0] =
            gl_TessLevelOuter[0] =
            gl_TessLevelOuter[1] =
            gl_TessLevelOuter[2] = TERRAIN_PATCH_TESS_FACTOR;
        }

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
layout(location = 2) out vec3 o_Normal;

void main()
{
    // compute final vertex attributes
    VertexAttribute attrib = TessellateTriangle(
        i_Patch[0].texCoords,
        gl_TessCoord.xy
    );

    gl_Position = u_ModelViewProjectionMatrix * attrib.position;
    o_TexCoord  = attrib.texCoord;
    o_WorldPos  = (u_ModelMatrix * attrib.position).xyz;
    o_Normal = vec3(1.0);

    if(ComputeDerivateNormals()){
        o_Normal = fbmd_7(attrib.position.xyz, 7).yzw;
        o_Normal = normalize(o_Normal);
    }
}
#endif

/*******************************************************************************
 * Fragment Shader -- Shades the terrain
 *
 */
#ifdef FRAGMENT_SHADER
layout(location = 0) in vec2 i_TexCoord;
layout(location = 1) in vec3 i_WorldPos;
layout(location = 2) in vec3 i_Normal;

layout(location = 0) out vec4 o_FragColor;

void main()
{
    o_FragColor = ShadeFragment(i_TexCoord, i_WorldPos, i_Normal);
}
#endif
