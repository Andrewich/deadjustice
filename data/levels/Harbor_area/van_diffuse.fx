//
// hemisphere diffuse bump /w point light
//
// COLUMN MAJOR MATRICES
//


// -------------------------------------------- 
// Input parameters
// -------------------------------------------- 

// transforms
float4x4		mWorld; 	 // model->world tm
float4x4		mTotal; 	 // model->world->view->projection tm

// world space params
float3			pLight1;	// position of Light1
float3			pCamera;	// position of camera

// texture resources (from 3dsmax)
texture 		tDiffuse;	// glossy term in alpha channel
texture 		tBump;

// constants
float3			SKY_COLOR = float3( 120.0/255.0, 120.0/255.0, 125.0/255.0 );
float3			GROUND_COLOR = float3( 30.0/255.0, 30.0/255.0, 35.0/255.0 );

// -------------------------------------------- 
// Data formats
// -------------------------------------------- 

struct VS_INPUT
{
	float3 pos		 : POSITION;
	float3 normal	 : NORMAL;
	float2 tc0		 : TEXCOORD0;
	float3 tanS 	 : TEXCOORD1;
};

struct VS_OUTPUT
{
	float4 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float2 tc1		 : TEXCOORD1;
	float3 halfv	 : COLOR0;
	float3 lightv	 : COLOR1;
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


// -------------------------------------------- 
// Vertex shaders
// -------------------------------------------- 

/** Transforms vector by affine column-major matrix. */
float4 transform( float4x3 tm, float3 v )
{
	return float4( dot(tm[0],v)+tm[3].x, dot(tm[1],v)+tm[3].y, dot(tm[2],v)+tm[3].z, 1 );
}

VS_OUTPUT bumpDiffuseVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// transform vertex position
	o.pos = mul( mTotal, float4(v.pos,1) );
	float3 worldPos = mul( mWorld, float4(v.pos,1) );

	// transform normal and tangent
	float3 worldNormal = mul( mWorld, v.normal );
	float3 worldTanS = mul( mWorld, v.tanS );
	float3 worldTanT = cross( worldNormal, worldTanS );

	// compute view, light and half angle vectors
	float3 worldView = normalize( pCamera - worldPos );
	float3 worldLight = normalize( pLight1 - worldPos );
	float3 worldHalfv = normalize( worldView + worldLight );

	// compute tangent space light vector
	float3 tanLight = float3( dot(worldTanS,worldLight), dot(worldTanT,worldLight), dot(worldNormal,worldLight) );

	o.tc0 = v.tc0;
	o.tc1 = v.tc0;
	o.halfv = 0;
	o.lightv = tanLight*0.5 + 0.5;
	return o;
}

VS_OUTPUT bumpSpecularVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// transform vertex position
	o.pos = mul( mTotal, float4(v.pos,1) );
	float3 worldPos = mul( mWorld, float4(v.pos,1) );

	// transform normal and tangent
	float3 worldNormal = mul( mWorld, v.normal );
	float3 worldTanS = mul( mWorld, v.tanS );
	float3 worldTanT = cross( worldNormal, worldTanS );

	// compute view, light and half angle vectors
	float3 worldView = normalize( pCamera - worldPos );
	float3 worldLight = normalize( pLight1 - worldPos );
	float3 worldHalfv = normalize( worldView + worldLight );

	// transform half angle to tangent space
	float3 tanHalfv = float3( dot(worldTanS,worldHalfv), dot(worldTanT,worldHalfv), dot(worldNormal,worldHalfv) );

	o.tc0 = v.tc0;
	o.tc1 = v.tc0;
	o.halfv = tanHalfv*0.5 + 0.5;
	o.lightv = 0;
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
	//d *= d; // = d^2
	//d *= d; // = d^4

	dif *= lerp( GROUND_COLOR, SKY_COLOR, d );
	return float4( dif, 1 );
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 bumpDiffuseVS();
		PixelShader = compile ps_1_1 bumpDiffusePS();
	}
}
