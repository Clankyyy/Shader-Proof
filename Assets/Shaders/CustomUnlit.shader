Shader "Unlit/CustomUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DistortionRate("Rate", Range(1,50)) = 30
        _RotationSpeed("Speed", Range(1,15)) = 30
        _DistortionColor("Color", Color) = (0, 0, 0, 0)
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
            float _DistortionRate;
            float _RotationSpeed;
            fixed4 _DistortionColor;
            float4 _MainTex_ST;
            float2 _PointOffset;

            v2f vert (appdata v)
            {
                v2f o;
                //v.vertex.y += sin(v.vertex.z + _Time.y);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv - 0.5;
                float2 distort = uv + _PointOffset;
                float distance = length(distort);
                float interpolation = smoothstep(0.1, 0.04, distance);
                distort *= interpolation * _DistortionRate;
                float angle = _Time.y * _RotationSpeed;
                float2x2 rotation =
                    float2x2(cos(angle), - sin(angle), sin(angle), cos(angle));
                distort = mul(rotation, distort);
                i.uv += distort;
                fixed4 col = tex2D(_MainTex, i.uv);
                _DistortionColor *= 3;
                col.rgb += _DistortionColor * interpolation;
                return col;
            }
            ENDCG
        }
    }
}
