# UnlitShader
## SemiTransparent  
α値(0 ~ 1)によって, 透明 ~ 不透明
## Binarization
しきい値(0 ~ 1)より, textureのrgb値(0 ~ 1)と比較しテクスチャから色をとる  
しきい値(0.2)　画像ではテクスチャから出力した部分に色を塗っている  
<img src="https://user-images.githubusercontent.com/53201254/119251033-2bb02f80-bbdf-11eb-97dc-8c68c6b19837.png" width="320">  
しきい値(0.5)  
<img src="https://user-images.githubusercontent.com/53201254/119251183-2c959100-bbe0-11eb-8595-e6651cb33659.png" width="320">  
## ToonShader  
ライトと頂点ベクトルの内積によって, 影を表現  
影の位置, 濃さをプロパティから変更可能  
<img src="https://user-images.githubusercontent.com/53201254/119465630-cf841180-bd7e-11eb-80dc-a87ab1aaf45d.png" width="320">  
<img src="https://user-images.githubusercontent.com/53201254/119465749-edea0d00-bd7e-11eb-8dd7-23547cdd1af2.png" width="320">  

