//
// skinned hemisphere diffuse bump + specular*gloss /w point light
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
texture 		tDiffuse;	// glossy term in alpha channel
texture 		tBump;
//texture 		tNormalize;

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
	float3 tanS      : TEXCOORD1;
	float4 weights   : TEXCOORD2;
	float4 indices   : TEXCOORD3;
};

struct VS_OUTPUT
{
	float4 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float2 tc1		 : TEXCOORD1;
	float3 lightv	 : COLOR0;
	float3 halfv	 : COLOR1;
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

sampler bumpSampler = sampler_state
{
	Texture   = (tBump);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};

/*sampler normalizeSampler = sampler_state
{
	Texture   = (tNormalize);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};*/


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

VS_OUTPUT skinVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// compute world position, normal and tangent space S

	// apply influence of bone 1
	float i = v.indices.x;
	float w = v.weights.x;
	float4x3 bonetm = mWorldA[i];
	float3 worldPos = transform( bonetm, v.pos ) * w;
	float3 worldNormal = rotate( bonetm, v.normal ) * w;
	float3 worldTanS = rotate( bonetm, v.tanS ) * w;

	// apply influence of bone 2
	i = v.indices.y;
	w = v.weights.y;
	bonetm = mWorldA[i];
	worldPos += transform( bonetm, v.pos ) * w;
	worldNormal += rotate( bonetm, v.normal ) * w;
	worldTanS += rotate( bonetm, v.tanS ) * w;

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
	worldTanS = normalize( worldTanS );
	float3 worldTanT = cross( worldNormal, worldTanS );

	// compute view, light and half angle vectors
	float3 worldView = normalize( pCamera - worldPos );
	float3 worldLight = normalize( pLight1 - worldPos );
	float3 worldHalfv = normalize( worldView + worldLight );

	// compute tangent space light vector
	float3 tanLight = float3( dot(worldTanS,worldLight), dot(worldTanT,worldLight), dot(worldNormal,worldLight) );
	o.lightv = tanLight*0.5 + 0.5;

	// compute tangent space half angle vector
	float3 tanHalfv = float3( dot(worldTanS,worldHalfv), dot(worldTanT,worldHalfv), dot(worldNormal,worldHalfv) );
	o.halfv = tanHalfv*0.5 + 0.5;
	//o.halfv = tanHalfv;

	// pass through texture coordinates
	o.tc0 = v.tc0;
	o.tc1 = v.tc0;
	return o;
}


// -------------------------------------------- 
// Pixel shaders
// -------------------------------------------- 

float3 normalizeApprox( float3 v )
{
	return (1 - saturate(dot(v.xyz, v.xyz))) * (v*0.5) + v; // (1-step Newton-Raphson re-normalization correction)
}

float4 bumpDiffusePS( VS_OUTPUT p ) : COLOR
{
	float3 dif = tex2D( diffuseSampler, p.tc0 );
	float3 normv = ( tex2D( bumpSampler, p.tc1 ) - 0.5 ) * 2;
	float3 lightv = ( p.lightv - 0.5 ) * 2;
	
	normv = normalizeApprox( normv );
	lightv = normalizeApprox( lightv );

	float d = saturate( dot(normv,lightv) );
	//d *= d;     // = d^2
	//d *= d;     // = d^4

	dif *= lerp( GROUND_COLOR, SKY_COLOR, d );
	return float4( dif, 1 );
}

float4 bumpSpecularPS( VS_OUTPUT p ) : COLOR
{
	float3 gloss = SPECULAR_COLOR * (float3)tex2D( diffuseSampler, p.tc0 ).w;
	float3 normv = ( tex2D( bumpSampler, p.tc1 ) - (float3)0.5f ) * 2.f;
	float3 halfv = ( p.halfv - (float3)0.5f ) * 2.f;

	halfv = normalizeApprox( halfv );
	
	float spec = saturate( dot( normv, halfv ) );
	spec *= spec;
	spec *= spec;
	spec *= spec;
	spec *= spec;

	return float4( (float3)(spec*gloss), 1 );
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 skinVS();
		PixelShader = compile ps_1_1 bumpDiffusePS();
	}

	pass P1
	{
		VertexShader = compile vs_1_1 skinVS();
		PixelShader = compile ps_1_1 bumpSpecularPS();

		ZFunc = EQUAL;
		ZWriteEnable = false;
		AlphaBlendEnable = true;
		SrcBlend = ONE;
		DestBlend = ONE;
	}
}
