Shader "Unlit/ToonShader"
{
    Properties
    {
        _MainTex ("MainTexture", 2D) = "white" {}
        //最も暗い色に当たる色を決める
        _DarkColor ("DarkestColor", Color) = (0, 0, 0, 1)
        //色の区切りる場所を変える(内積-1 ~ 1の値を変更している)
        _LuminanceLevel0 ("LuminanceLevel0", Float) = 0.5
        _LuminanceLevel1 ("LuminanceLevel1", Float) = 0
        //暗い色のrgbにどれくらい値を足していくか(小さくするほど変わらない)
        _ColorRange ("ColorRange0", Range(0.01, 0.3)) = 0.3
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
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float luminance : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _DarkColor;
            float _ColorRange;
            float _LuminanceLevel0;
            float _LuminanceLevel1;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //ライトのベクトルを取得
                float3 lightDir = normalize(ObjSpaceLightDir(v.vertex));
                //ライトのベクトルと頂点のベクトルの内積を取得
                o.luminance = dot(v.normal, lightDir);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                fixed4 col = tex2D(_MainTex, i.uv); 
                fixed sahdow = _DarkColor;
                //それぞれのレベルで色を加算していく
                sahdow += _ColorRange * (1.0 - step(i.luminance, _LuminanceLevel0));
                sahdow += _ColorRange * (1.0 - step(i.luminance, _LuminanceLevel1));
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col * sahdow;
            }
            ENDCG
        }
    }
}
