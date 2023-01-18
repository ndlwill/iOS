#version 330 core
out vec4 FragColor;

in vec3 LightingColor;

uniform vec3 objectColor;

void main()
{
   FragColor = vec4(LightingColor * objectColor, 1.0);
}

/*
So what do we see?
You can see (for yourself or in the provided image) the clear distinction of the two triangles at the front of the
cube. This 'stripe' is visible because of fragment interpolation. From the example image we can see that the top-right
vertex of the cube's front face is lit with specular highlights. Since the top-right vertex of the bottom-right triangle is
lit and the other 2 vertices of the triangle are not, the bright values interpolates to the other 2 vertices. The same
happens for the upper-left triangle. Since the intermediate fragment colors are not directly from the light source
but are the result of interpolation, the lighting is incorrect at the intermediate fragments and the top-left and
bottom-right triangle collide in their brightness resulting in a visible stripe between both triangles.

This effect will become more apparent when using more complicated shapes.
*/
