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

float		screenwidth;
float		screenheight;
texture     inputTexture;
texture     baseTexture;
float		time;
float       amount;

sampler inputTextureSampler = sampler_state
    {
        texture       = (inputTexture);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Point;
		SRGBTexture   = False;
    };

sampler baseTextureSampler = sampler_state
    {
        texture       = (baseTexture);
        AddressU      = Clamp;
        AddressV      = Clamp;
        MinFilter     = Linear;
        MagFilter     = Linear;
        MipFilter     = Point;
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

float4 DownSampleBoxPS(PS_INPUT input) : COLOR0
{
	float2 t1 = input.texCoord;
	return tex2D(inputTextureSampler, t1);
}

float4 SFXDistortionPS(PS_INPUT input) : COLOR0
{
	float4 result = float4(0, 0, 0, 1);
		
	float4 base = tex2D(inputTextureSampler, input.texCoord);
		
	if (sin(time * 20) < 0 && input.texCoord.y * 1000 % 4 >= 2
        || sin(time * 20) > 0 && input.texCoord.y * 1000 % 4 < 2)
        return base;
    float4 color = base + result;
    
    // Tint everything and blend over the original.
    const float4 tint = float4(amount, amount, amount, 1);
    float intensity = color.r * 0.0126f + color.g * 0.3152f + color.b * 0.0322f;
    return lerp(base, intensity * tint, 0.9);
		
}

technique SFXDistortion
{
    pass p0
    {
		ZEnable             = False;
        ZWriteEnable        = False;
        VertexShader        = compile vs_2_0 SFXBasicVS();
        PixelShader         = compile ps_2_0 SFXDistortionPS();
        CullMode            = None;
    }
}