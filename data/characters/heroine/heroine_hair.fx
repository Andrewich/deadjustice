//
// skinned alpha diffuse shader /w point light
//
// COLUMN MAJOR MATRICES
//


// -------------------------------------------- 
// Input parameters
// -------------------------------------------- 

// transforms
float4x3		mWorldA[29];
float4x4		mViewProjection;

// world space params
float3			pLight1;	// position of Light1
float3			pCamera;	// position of camera

// texture resources (from 3dsmax)
texture 		tDiffuse;		// transparency in alpha channel

// DJ constants (modulated by lightmap r,g,b -> constants)
float3			SKY_COLOR_MIN = float3( 24.0/255.0, 24.0/255.0, 25.0/255.0 );
float3			SKY_COLOR_MAX = float3( 2*240.0/255.0, 2*240.0/255.0, 2*250.0/255.0 );
float3			GROUND_COLOR_MIN = float3( 9.0/255.0, 9.0/255.0, 10.5/255.0 );
float3			GROUND_COLOR_MAX = float3( 2*90.0/255.0, 2*90.0/255.0, 2*105.0/255.0 );
float3			SPECULAR_COLOR_MIN = float3( 0, 0, 0 );
float3			SPECULAR_COLOR_MAX = float3( 2, 2, 2 );

// constants (won't affect anything in DJ, see DJ constants)
float3			SKY_COLOR = float3( 240.0/255.0, 240.0/255.0, 250.0/255.0 );
float3			GROUND_COLOR = float3( 90.0/255.0, 90.0/255.0, 105.0/255.0 );
float3			SPECULAR_COLOR = float3( 1, 1, 1 );


// -------------------------------------------- 
// Data formats
// -------------------------------------------- 

struct VS_INPUT
{
	float3 pos		 : POSITION;
	float3 normal	 : NORMAL;
	float2 tc0		 : TEXCOORD0;
	float4 weights   : TEXCOORD1;
	float4 indices   : TEXCOORD2;
};

struct VS_OUTPUT
{
	float4 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float3 lightv	 : COLOR0;
	float3 normv	 : COLOR1;
};

struct PS_OUTPUT
{
	float4 col		 : COLOR0;
};


// -------------------------------------------- 
// Texture samplers
// -------------------------------------------- 

sampler diffuseSampler = sampler_state
{
	Texture   = (tDiffuse);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};


// -------------------------------------------- 
// Vertex shaders
// -------------------------------------------- 

/** Transforms vector by affine 4x3 column-major matrix. */
float4 transform( float4x3 tm, float3 v )
{
	return float4( dot(tm[0],v)+tm[3].x, dot(tm[1],v)+tm[3].y, dot(tm[2],v)+tm[3].z, 1 );
}

/** Rotates vector by affine column-major matrix. */
float3 rotate( float3x3 tm, float3 v )
{
	return float3( dot(tm[0],v), dot(tm[1],v), dot(tm[2],v) );
}

VS_OUTPUT skinAlphaVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// compute world position, normal and tangent space S

	// apply influence of bone 1
	float i = v.indices.x;
	float w = v.weights.x;
	float4x3 bonetm = mWorldA[i];
	float3 worldPos = transform( bonetm, v.pos ) * w;
	float3 worldNormal = rotate( bonetm, v.normal ) * w;

	// apply influence of bone 2
	i = v.indices.y;
	w = v.weights.y;
	bonetm = mWorldA[i];
	worldPos += transform( bonetm, v.pos ) * w;
	worldNormal += rotate( bonetm, v.normal ) * w;

	// apply influence of bone 3
	i = v.indices.z;
	w = v.weights.z;
	bonetm = mWorldA[i];
	worldPos += transform( bonetm, v.pos ) * w;

	// apply influence of bone 4
	i = v.indices.w;
	w = v.weights.w;
	bonetm = mWorldA[i];
	worldPos += transform( bonetm, v.pos ) * w;

	// transform projected vertex position
	o.pos = mul( mViewProjection, float4(worldPos,1) );

	// normalize world normal and tangent space S
	worldNormal = normalize( worldNormal );

	// compute view, light and half angle vectors
	float3 worldView = normalize( pCamera - worldPos );
	float3 worldLight = normalize( pLight1 - worldPos );
	float3 worldHalfv = normalize( worldView + worldLight );

	// store world space light and normal vectors
	o.lightv = worldLight*0.5 + 0.5;
	o.normv = worldNormal*0.5 + 0.5;

	// pass through texture coordinates
	o.tc0 = v.tc0;
	return o;
}


// -------------------------------------------- 
// Pixel shaders
// -------------------------------------------- 

float3 normalizeApprox( float3 v )
{
	return (1 - saturate(dot(v.xyz, v.xyz))) * (v*0.5) + v; // (1-step Newton-Raphson re-normalization correction)
}

float4 skinAlphaPS( VS_OUTPUT p ) : COLOR
{
	float4 dif = tex2D( diffuseSampler, p.tc0 );
	
	float3 lightv = normalizeApprox( (p.lightv - 0.5)*2 );
	float3 normv = normalizeApprox( (p.normv - 0.5)*2 );

	float d = saturate(dot(lightv,normv));
	float3 c = dif.xyz * lerp( GROUND_COLOR, SKY_COLOR, d );
	return float4(c,dif.w);
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 skinAlphaVS();
		PixelShader = compile ps_1_1 skinAlphaPS();

		AlphaBlendEnable = true;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		CullMode = NONE;

		ZWriteEnable = true;
		ZFunc = LESSEQUAL;
		
		AlphaRef = 10;
		AlphaFunc = GREATEREQUAL;
		AlphaTestEnable = true;
	}
}
