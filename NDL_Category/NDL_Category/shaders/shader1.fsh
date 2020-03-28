varying lowp vec2 varyTextCoord;
uniform sampler2D colorMap;

void main()
{
    gl_FragColor = texture2D(colorMap, varyTextCoord);
    
}

// 方法3
//varying lowp vec2 varyTextCoord;
//uniform sampler2D colorMap;
//
//void main()
//{
//    gl_FragColor = texture2D(colorMap, vec2(varyTextCoord.x,1.0-varyTextCoord.y));
//}
