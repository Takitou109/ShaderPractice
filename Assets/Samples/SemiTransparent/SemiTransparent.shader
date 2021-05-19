Shader "Unlit/SemiTransparent"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Alpha("Alpha", Range(0,1)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        //レンダーキューの数値は大きいものから　後に描写される
        // "Queue" = "Transparent"を追加しないばあいは, レンダーキューはGeometryとなり2500となる
        // "Queue" = "Transparent"を追加した場合は, レンダーキューの値は3000となる


        Blend SrcAlpha OneMinusSrcAlpha 
        //ブレンドモード
        //Blend [SrcFactor] [DstFactor]
        //出力される色 = フラグメントシェーダの出力 * SrcFactor + レンダーターゲットに描画されている色(画面上の色) * DstFactor
        //描画する場合はすぐに出力しない, レンダーターゲットは1枚のテクスチャ(レンダーターゲット)に, 画面に出力する色を一気に書き込んでから, 画面に出力する
        //ex.) Blend One Zero フラグメントシェーダの出力をそのまま
        //SrcAlphaについては, フラグメントシェーダから出力されたalpha値
        //OneMinusSrcAlphaについては, (1 - SrcFactor)の値 Lerpの様 つまり, フラグメントシェーダのalpha値が小さくなると見えなくなる

        //Unity公式から(https://docs.unity3d.com/jp/current/Manual/SL-Blend.html)////////////////////////////////////////
        // One	One の値 - これでソースあるいは目的の色をそのまま使用したい場合に使用します。
        // Zero	Zero の値 - これでソースあるいは目的の色をそのまま削除したい場合に使用します。
        // SrcColor	このステージの値はソースカラー値を乗算する。
        // SrcAlpha	このステージの値はソースα値を乗算する。
        // DstColor	このステージの値はフレームバッファの Source Color
        // DstAlpha	このステージの値はフレームバッファの Source Alpha の値を乗算します。
        // OneMinusSrcColor	このステージの値はフレームバッファの(1 - Source Color)を乗算します。
        // OneMinusSrcAlpha	このステージの値はフレームバッファの(1 - Source Alpha)を乗算します。
        // OneMinusDstColor	このステージの値はフレームバッファの(1 - Destination Color)を乗算します。
        // OneMinusDstAlpha	このステージの値はフレームバッファの(1 - Destination Alpha)を乗算します。
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //レンダーターゲットについての補足
        //レンダーターゲットには, カラーバッファ(色保存)とZバッファ(Unity5.5以下 0に近いほどFar, 1に近いほどNear)のメモリ領域がある.
        //Zバッファは0で初期化される
        //CameraのClearFlagsは二つのバッファの初期化の仕方の違い
        //何も触らないとskyboxで初期化されている

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
            half _Alpha; 

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= _Alpha; //出力する色のalpha値を操作
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
