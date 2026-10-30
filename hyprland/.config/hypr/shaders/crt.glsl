#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);
    float scanline = sin(v_texcoord.y * 800.0) * 0.05;
    color.rgb -= scanline;
    fragColor = vec4(clamp(color.rgb, 0.0, 1.0), color.a);
}
