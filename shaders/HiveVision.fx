struct VS_INPUT
{
    float3 ssPosition   : POSITION;
    float2 texCoord     : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4 ssPosition	: POSITION;
    float2 texCoord     : TEXCOORD0;
};

struct PS_INPUT
{
    float2 texCoord     : TEXCOORD0;
};

texture     inputTexture;
texture     inputTexture1;
texture     inputTexture2;
texture 	hiveVisionTexture;
texture		depthTexture;

texture		noiseTexture;
texture		smokeTexture;

float		screenwidth;
float		screenheight;
float		time;

float 		maxDistance;	// Maximum distance objects are visible through the walls

sampler depthTextureSampler = sampler_state
    {
        texture       = (depthTexture);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };

sampler inputTextureSampler = sampler_state
    {
        texture       = (inputTexture);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };
	
sampler inputTextureSampler1 = sampler_state
    {
        texture       = (inputTexture1);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };	

sampler inputTextureSampler2 = sampler_state
    {
        texture       = (inputTexture2);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };	

sampler hiveVisionTextureSampler = sampler_state
    {
        texture       = (hiveVisionTexture);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };

sampler noiseTextureSampler = sampler_state
    {
        texture       = (noiseTexture);
        AddressU      = Wrap;
        AddressV      = Wrap;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };

sampler smokeTextureSampler = sampler_state
    {
        texture       = (smokeTexture);
        AddressU      = Wrap;
        AddressV      = Wrap;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Linear;
		SRGBTexture   = False;
    };
	
	
/**
 * Vertex shader.
 */  
VS_OUTPUT SFXBasicVS(VS_INPUT input)
{

    VS_OUTPUT output;

    output.ssPosition = float4(input.ssPosition, 1);
    output.texCoord   = input.texCoord;

    return output;

}

float4 MaskPS(PS_INPUT input) : COLOR0
{
    float4 hiveVision = tex2D(hiveVisionTextureSampler, input.texCoord);
	if (hiveVision.r > 0 && hiveVision.r * 100 < maxDistance * 2)
	{
		return float4(1, 1, 1, 1);
	}
	return float4(0, 0, 0, 0);
}
 
float4 DownSamplePS(PS_INPUT input) : COLOR0
{
	return tex2D( inputTextureSampler, input.texCoord );
 }

float4 CompositePS(PS_INPUT input) : COLOR0
{
	return tex2D( inputTextureSampler1, input.texCoord) + tex2D( inputTextureSampler2, input.texCoord);
}

float4 FinalCompositePS(PS_INPUT input) : COLOR0
{

	float4 result = tex2D(inputTextureSampler, input.texCoord);

	// Blend in the outlines of objects visible through the walls.
    float4 glow = tex2D(inputTextureSampler1,  input.texCoord);
    if (glow.r > 0)
	{
        float4 smoke = tex2D(noiseTextureSampler, input.texCoord * 4 + time * 0.12);
        float opacity = 1.5 - tex2D( inputTextureSampler2, input.texCoord).a;
		result += glow * smoke * float4(15, 0, 0, 1) * opacity;
	}

	return result;

}

technique Mask
{
    pass p0
    {
        ZEnable             = False;
        ZWriteEnable        = False;	
        VertexShader        = compile vs_2_0 SFXBasicVS();
        PixelShader         = compile ps_2_0 MaskPS();
        CullMode            = None;
    }
}

technique DownSample
{
    pass p0
    {
        ZEnable             = False;
        ZWriteEnable        = False;	
        VertexShader        = compile vs_2_0 SFXBasicVS();
        PixelShader         = compile ps_2_0 DownSamplePS();
        CullMode            = None;
    }
}

technique Composite
{
    pass p0
    {
        ZEnable             = False;
        ZWriteEnable        = False;	
        VertexShader        = compile vs_2_0 SFXBasicVS();
        PixelShader         = compile ps_2_0 CompositePS();
        CullMode            = None;
    }
}

technique FinalComposite
{
    pass p0
    {
        ZEnable             = False;
        ZWriteEnable        = False;	
        VertexShader        = compile vs_2_0 SFXBasicVS();
        PixelShader         = compile ps_2_0 FinalCompositePS();
        CullMode            = None;
    }
}
