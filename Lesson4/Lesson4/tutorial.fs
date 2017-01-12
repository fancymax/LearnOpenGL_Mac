#version 330 core
in vec3 ourColor;
in vec2 TexCoord;

out vec4 color;

uniform sampler2D ourTexture1;
uniform sampler2D ourTexture2;

vec2 flipTexCoord;

void main()
{
    //use vec2(TexCoord.x, 1.0f - TexCoord.y) to flip texture2
    flipTexCoord = vec2(TexCoord.x, 1.0f - TexCoord.y);
    color = mix(texture(ourTexture1, TexCoord),texture(ourTexture2, flipTexCoord),0.2);
}
