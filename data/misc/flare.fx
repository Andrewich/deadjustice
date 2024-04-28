//
// flare shader (not for generic usage)
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
texture 		tDiffuse;


// -------------------------------------------- 
// Data formats
// -------------------------------------------- 

struct VS_INPUT
{
	float3 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float2 fade		 : TEXCOORD1;
};

struct VS_OUTPUT
{
	float4 pos		 : POSITION;
	float2 tc0		 : TEXCOORD0;
	float3 fade		 : COLOR0;
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

VS_OUTPUT flareVS( const VS_INPUT v )
{
	VS_OUTPUT o = (VS_OUTPUT)0;

	// transform vertex position
	o.pos = mul( mTotal, float4(v.pos,1) );

	// pass through texture coordinates
	o.tc0 = v.tc0;
	o.fade.rgb = v.fade.x;
	return o;
}


// -------------------------------------------- 
// Pixel shaders
// -------------------------------------------- 

float4 flarePS( VS_OUTPUT p ) : COLOR
{
	float4 texc = tex2D( diffuseSampler, p.tc0 );
	//texc *= p.fade.x;
	return texc;
}


// -------------------------------------------- 
// Techniques
// -------------------------------------------- 

technique T0
{
	pass P0
	{
		VertexShader = compile vs_1_1 flareVS();
		PixelShader = compile ps_1_1 flarePS();

		CullMode = NONE;
		AlphaBlendEnable = true;
		SrcBlend = ONE;
		DestBlend = ONE;

		ZWriteEnable = false;
		ZFunc = ALWAYS;
	}
}
