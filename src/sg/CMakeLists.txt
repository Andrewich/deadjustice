project(
    sg
    VERSION 0.65
    DESCRIPTION
        "Scene graph library"
    LANGUAGES CXX
)

add_library(sg STATIC)

include_directories(internal)

target_sources(sg 
    PRIVATE
        internal/BoundVolume.cpp
        internal/GdUtil.cpp
        internal/TextureCache.cpp
        BaseTexture.cpp
        Camera.cpp
        Context.cpp
        ContextObject.cpp
        CubeTexture.cpp
        Curve.cpp
        DirectLight.cpp
        Dummy.cpp
        EdgeHash.cpp
        Effect.cpp
        Font.cpp
        Light.cpp
        LineList.cpp
        LOD.cpp
        Material.cpp
        Mesh.cpp
        Model.cpp
        Morpher.cpp
        MorphTarget.cpp
        Node.cpp
        PatchList.cpp
        PointLight.cpp
        PolygonAdjacency.cpp
        Primitive.cpp
        Scene.cpp
        Shader.cpp
        ShadowShader.cpp
        ShadowVolume.cpp
        SpotLight.cpp
        Sprite.cpp
        Texture.cpp
        TriangleList.cpp
        VertexFormat.cpp
        ViewFrustum.cpp)
