//
// transparent cube reflection shader,
// requires material name SORT tag on export
//
// uses reflection vector instead normal,
// works better on flat surfaces
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

// texture resources (from 3dsmax)
texture 		tDiffuse;	// transparency in alpha channel
texture 		tReflection;


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

VS_OUTPUT windowVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// transform vertex position
	o.pos = mul( mTotal, float4(v.pos,1) );

	// transform normal
	float3 worldNormal = mul( mWorld, v.normal );

	// get direction from vertex toward the camera
	float4 worldPos = mul( mWorld, float4(v.pos,1) );
	float3 worldView = pCamera - worldPos;
	float3 worldRefl = normalize( -worldView + worldNormal*(dot(worldNormal,worldView)*2) );

	o.tc0 = v.tc0;
	o.tc1 = worldNormal;
	//o.tc1 = worldRefl;
	return o;
}


// -------------------------------------------- 
// Pixel shaders
// -------------------------------------------- 

float3 normalizeApprox( float3 v )
{
	return (1 - saturate(dot(v.xyz, v.xyz))) * (v*0.5) + v; // (1-step Newton-Raphson re-normalization correction)
}

float4 windowPS( VS_OUTPUT p ) : COLOR
{
	float4 texc = tex2D( diffuseSampler, p.tc0 );
	float3 envc = texCUBE( reflectionSampler, p.tc1 );
	return float4( envc, texc.w );
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 windowVS();
		PixelShader = compile ps_1_1 windowPS();

		CullMode = NONE;		
		AlphaBlendEnable = true;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;

		ZWriteEnable = false;
		ZFunc = LESSEQUAL;
	}
}
