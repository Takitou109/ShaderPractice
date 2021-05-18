﻿Shader "Unlit/Study"
{
    //基本を理解するためのスクリプト
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                //#define UNITY_FOG_COORDS(idx) float1 fogCoord : TEXCOORD##idx;
                //fogCoordにTEXDOORD1が割り当て
                float4 vertex : SV_POSITION; 
                //セマンティクス: SV_POSITIONは頂点シェーダで変換された頂点座標が入る
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //UnityObjectToClipPosについて
                //UNITY_MATRIX_MVPと3D空間座標の掛け算を行う, 関数
                //MVP = モデル変換(ワールド座標のどこにいるのか計算), ビュー変換(カメラから見た位置に変換), プロジェクト変換(座標をそれぞれ-1 ~ 1の値に変換)
                //三変換を一つにまとめた関数
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //TRANSFORM_TEXについて
                //#define TRANSFORM_TEX(tex, name) = (tex.xy * name##_ST.xy + name##_ST.zw)
                //x, yはTilingであり, テクスチャを縮めるイメージ
                //z, wはoffsetであり, テクスチャを左右上下にずらす
                //Tiling Offset いらないなら o.uv = v.uvで良い
                UNITY_TRANSFER_FOG(o,o.vertex);
                //UNITY_TRANSFER_FOGについて
                //#define UNITY_TRANSFER_FOG(o, outpos) o.fogCoord.x = outpos.z
                //つまり o.fogCoord.x = o.vertex.z
                // フラグメントシェーダに渡される前に,-1~1に変換されたo.vertexが画面サイズをもとに変換されてしまう(画面サイズ1280×720ならばx:0~1279, y:0~719)
                //vertex.zをo.fogCoord.xに退避させている
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
