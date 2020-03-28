attribute vec4 position;
attribute vec2 textCoordinate;
varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    gl_Position = position;
}


// 解决纹理翻转(方法1)
//attribute vec4 position;
//attribute vec2 textCoordinate;
//uniform mat4 rotateMatrix;
//
//varying lowp vec2 varyTextCoord;
//
//void main()
//{
//    varyTextCoord = textCoordinate;
//
//    vec4 vPos = position;
//    vPos = vPos * rotateMatrix;
//
//    gl_Position = vPos;
//}

// 方法4
//attribute vec4 position;
//attribute vec2 textCoordinate;
//varying lowp vec2 varyTextCoord;
//
//void main()
//{
//    varyTextCoord = vec2(textCoordinate.x,1.0-textCoordinate.y);
//    gl_Position = position;
//}
