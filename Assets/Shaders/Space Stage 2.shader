Shader "Unlit/Space Stage 2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Octaves("Octaves", int) = 1
        _Multiplier("Multiplier", float) = 1.0
        _Frequency("Frequency", float) = 1.0
        
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Multiplier;
            float _Frequency;
            int _Octaves;
            
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float random(float2 p)
            {
                float d = dot(p, float2(11.52, 51.63));
                float s = sin(d);
                return frac(s * 65124.6234125); 
            }
            
            float noise (float2 p)
            {
                float2 i = floor(p);
                float2 f = frac(p);

                float a = random(i);
                float b = random(i + float2(1.0, 0.0));
                float c = random(i + float2(0.0, 1.0));
                float d = random(i + float2(1.0, 1.0));

                float v1 = lerp(a, b, f.x);
                float v2 = lerp(c, d, f.x);

                return lerp(v1, v2, f.y);
            }
            
            float fbm(float2 p)
            {
                float result = 0;
                float amplitude = 0.5;
                float2 offset = 50.0;
                float2x2 rot = float2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
                for (int i = 0; i < _Octaves; i++)
                {
                    result += amplitude * noise(p);
                    p = mul(rot, p) * 2.0 + offset;
                    amplitude *= _Multiplier;
                }
                return result;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float4 col = 0.0;

                float q = fbm(uv);
                float r = fbm(uv + q + _Time.y * 0.5);
                float f = fbm(uv + r);
                
                return r;
            }
            ENDCG
        }
    }
}
