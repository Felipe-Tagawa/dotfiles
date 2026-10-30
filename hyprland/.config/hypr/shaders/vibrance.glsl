#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec3 c = color.rgb;
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    float max_c = max(c.r, max(c.g, c.b));
    float min_c = min(c.r, min(c.g, c.b));
    float sat = max_c - min_c;
    float vibrance = 0.40;
    vec3 res = mix(vec3(luma), c, 1.0 + (vibrance * (1.0 - sat)));
    fragColor = vec4(clamp(res, 0.0, 1.0), color.a);
}
