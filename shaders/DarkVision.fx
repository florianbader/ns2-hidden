//const float PI = 3.14159265359;

struct VS_INPUT
{
   float3 ssPosition   : POSITION;
   float2 texCoord     : TEXCOORD0;
   float4 color        : COLOR0;
};

struct VS_OUTPUT
{
   float4 ssPosition    : POSITION;
   float2 texCoord     : TEXCOORD0;
   float4 color        : COLOR0;
};

struct PS_INPUT
{
   float2 texCoord     : TEXCOORD0;
   float4 color        : COLOR0;
};

texture     baseTexture;
texture      depthTexture;
float        time;
float        startTime;
float        amount;

sampler baseTextureSampler = sampler_state
   {
       texture       = (baseTexture);
       AddressU      = Wrap;
       AddressV      = Wrap;
       MinFilter     = Linear;
       MagFilter     = Linear;
       MipFilter     = Linear;
        SRGBTexture   = False;
   };
   
sampler depthTextureSampler = sampler_state
   {
       texture       = (depthTexture);
       AddressU      = Clamp;
       AddressV      = Clamp;
       MinFilter     = Linear;
       MagFilter     = Linear;
       MipFilter     = None;
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
   output.color      = input.color;

   return output;

}

float4 SFXDarkVisionPS(PS_INPUT input) : COLOR0
{


    // This is an exponent which is used to make the pulse front move faster when it gets
    // farther away from the viewer so that the effect doesn't take too long to complete.
    const float frontMovementPower     = 2.0;
    const float frontSpeed            = 8.0;
    const float pulseWidth            = 20.0;

    float2 texCoord = input.texCoord;

    float2 depth1    = tex2D(depthTextureSampler, input.texCoord).rg;
    float4 inputPixel = tex2D(baseTextureSampler, input.texCoord);

    float x     = (input.texCoord.x - 0.5) * 2;
    float y     = (input.texCoord.y - 0.5) * 2;	
	float distanceSq	= x * x + y * y;
	
	float fadeout = exp(-depth1.r * 0.23 + 0.23);
	
    const float offset = 0.0005 + distanceSq * 0.005 * (1 + depth1.g);
	float  depth2 = tex2D(depthTextureSampler, input.texCoord + float2( offset, 0)).rg;
	float  depth3 = tex2D(depthTextureSampler, input.texCoord + float2(-offset, 0)).rg;
	float  depth4 = tex2D(depthTextureSampler, input.texCoord + float2( 0,  offset)).rg;
	float  depth5 = tex2D(depthTextureSampler, input.texCoord + float2( 0, -offset)).rg;


	float edge;
    float4 edgeColor;
   	
			edge = clamp(abs(depth2.r - depth1.r) +
					abs(depth3.r - depth1.r) +
					abs(depth4.r - depth1.r) +
					abs(depth5.r - depth1.r),
					0, 8);
					
    if (depth1.g > 0.5)
    {
		/*edge = depth1.g * 0.5 +  (abs(depth2.g - depth1.g) +
							abs(depth3.g - depth1.g) +
							abs(depth4.g - depth1.g) +
							abs(depth5.g - depth1.g)) * 0;
		*/
		
		edge = clamp(pow(edge * 0.1, 2), 0.01, 2.0);
		
        if (depth1.r < 0.15){
            edgeColor = float4(0.3, 0.01, 0, 0);
        }
        else
        {
			
            edgeColor = float4(0, 0, 0, 0) + float4(0.1, 0.1, 0.0, 0) * (fadeout * 4); //clamp(1 - depth1.r * 0.01, 0.2, 1);
           
        }		
        
    }
    else
    {
		//edge = edge + fadeout;
		if (depth1.r == 0){
			edgeColor = float4(0.0, 0.0, 0.0, 0);
		}
		else{
			edgeColor = float4(0.1, 0.2, 0.0, 0) * fadeout;  //float4(0.32, 0.48, 0.2, 0);
		}
		
    }
   
   
    /*float edge = (abs(depth2 - depth1.r) +
                 abs(depth3 - depth1.r) +
                 abs(depth4 - depth1.r) +
                 abs(depth5 - depth1.r)
                 +
                 abs(depth6 - depth1.r) +
                 abs(depth7 - depth1.r) +
                 abs(depth8 - depth1.r) +
                 abs(depth9 - depth1.r)) * 0.5;
    */
	   

    // Compute a pulse "front" that sweeps out from the viewer when the effect is activated.

    float wave  = cos(4 * x) + sin(4 * x);
   
    float front = pow( (time - startTime) * frontSpeed, frontMovementPower) + wave;
    float pulse = saturate((front - depth1.r * 1) / pulseWidth);
   
    if (pulse > 0)
    {
		//float fadeout = 1.0/(depth1.r + 0.01);//clamp(exp(-depth1.r * 0.3), 0.01, 1);
       
        //float heartbeat = 1.0 + cos(2.0 * time%(PI*0.8));// clamp(pow(time%1, 2), 0, 1);
		
		const float kPulseFreq = 4;
		const float kEntityPulseSpeed = 1.5;
		const float kBaseMotionScalar = 0.5;
		const float kEntityMotionScalar = 1;
		
		float movement = (sin(time * kPulseFreq * (1.0 - depth1.g * kEntityPulseSpeed) - depth1.r * (kBaseMotionScalar + depth1.g * kEntityMotionScalar)) + 2) * 0.2;
		float saturation = max( max(abs(inputPixel.r - inputPixel.g), abs(inputPixel.r - inputPixel.b)), abs(inputPixel.b - inputPixel.g) );

       
        //return lerp(inputPixel, lerp(inputPixel, edgeColor * edge * movement, edge + movement), amount);
		
		//return lerp(inputPixel, edgeColor * edge * (inputPixel + max(saturation, 0.1)), amount);
		
		//return max(edge * edgeColor, inputPixel * 0.5); 
		
		return max(inputPixel, edge) * edgeColor;
       
    }
    else
    {
        return inputPixel;
    }
   
}

technique SFXDarkVision
{
   pass p0
   {
        ZEnable             = False;
       ZWriteEnable        = False;   
       VertexShader        = compile vs_2_0 SFXBasicVS();
       PixelShader         = compile ps_2_0 SFXDarkVisionPS();
       CullMode            = None;
   }
}
