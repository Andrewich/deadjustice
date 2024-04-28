//
// fresnel:
// 
// tex*(1-k) + env*k,
// f = vertex fresnel * tex.alpha
//
// COLUMN MAJOR MATRICES
//


// -------------------------------------------- 
// Input parameters
// -------------------------------------------- 

// transforms
float4x4		mWorld; 	// model->world tm
float4x4		mTotal; 	// model->world->view->projection tm

// world space params
float4			pCamera;	// position of camera
float4			pLight1;	// position of Light1

// texture resources (from 3dsmax)
texture 		tDiffuse;	// glossy term in alpha channel
texture 		tReflection;

// constants
float			FRESNEL_R0 = 0.1;
float			FRESNEL_MIN = 0;
float			FRESNEL_MAX = 1;
float3			AMBIENT_COLOR = float3(0.4,0.4,0.4);
float3			DIFFUSE_COLOR = float3(1,1,1);


// -------------------------------------------- 
// Data formats
// -------------------------------------------- 

struct VS_INPUT
{
	float3 pos		 : POSITION;
	float3 normal	 : NORMAL;
	float2 tc0		 : TEXCOORD0;
};

struct VS_OUTPUT
{
	float4 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float3 tc1		 : TEXCOORD1;
	float4 dif		 : COLOR0;
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

sampler reflectionSampler = sampler_state
{
	Texture   = (tReflection);
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;
};


// -------------------------------------------- 
// Vertex shaders
// -------------------------------------------- 

float fresnel( float3 light, float3 normal, float R0 )
{
	// Note: compute R0 on the CPU and provide as a
	// constant; it is more efficient than computing R0 in
	// the vertex shader. R0 is:
	// float const R0 = pow(1.0-refractionIndexRatio, 2.0) / pow(1.0+refractionIndexRatio, 2.0);
	// light and normal are assumed to be normalized
	return R0 + (1.0-R0) * pow(1.0-dot(light, normal), 5.0);
}

VS_OUTPUT fresnelVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// transform vertex position
	o.pos = mul( mTotal, float4(v.pos,1) );

	// transform normal
	float3 worldNormal = mul( mWorld, v.normal );

	// get direction from vertex toward the camera
	float4 worldPos = mul( mWorld, float4(v.pos,1) );
	float3 worldView = normalize( pCamera - worldPos );

	// compute light
	float3 worldLight = normalize( pLight1 - worldPos );
	o.dif.rgb = AMBIENT_COLOR + DIFFUSE_COLOR*saturate(dot(worldLight,worldNormal));

	// compute fresnel
	float f = fresnel( worldView, worldNormal, FRESNEL_R0 );
	o.dif.w = lerp( FRESNEL_MIN, FRESNEL_MAX, f );

	o.tc0 = v.tc0;
	o.tc1 = worldNormal;
	return o;
}


// -------------------------------------------- 
// Pixel shaders
// -------------------------------------------- 

float3 normalizeApprox( float3 v )
{
	return (1 - saturate(dot(v.xyz, v.xyz))) * (v*0.5) + v; // (1-step Newton-Raphson re-normalization correction)
}

float4 fresnelPS( VS_OUTPUT p ) : COLOR
{
	float4 texc = tex2D( diffuseSampler, p.tc0 );
	float3 envc = texCUBE( reflectionSampler, p.tc1 );
	float3 litc = texc * p.dif.rgb;
	float k = saturate( p.dif.w * texc.w );
	float3 c = lerp( litc, envc, k );
	return float4( c, 1 );
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 fresnelVS();
		PixelShader = compile ps_1_1 fresnelPS();
	}
}
