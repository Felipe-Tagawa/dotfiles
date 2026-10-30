#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    pixColor.r = min(1.0, pixColor.r * 1.05);
    pixColor.g = pixColor.g * 0.90;
    pixColor.b = pixColor.b * 0.65;
    fragColor = pixColor;
}
