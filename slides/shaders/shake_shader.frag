#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;
uniform sampler2D iChannel0;

out vec4 fragColor;

const float YRES = 33.0 * 8.0;
const float INTERFERENCE1 = 1.0;
const float INTERFERENCE2 = 0.001;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

float peak(float x, float xpos, float scale) {
    return clamp((1.0 - x) * scale * log(1.0 / abs(x - xpos)), 0.0, 1.0);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord.xy / iResolution.xy;
    float scany = round(uv.y * YRES);
    
    // interference/shaking
    float r = random(vec2(scany, iTime));
    if (r > 0.995) {r *= 3.0;}
    float ifx1 = INTERFERENCE1 * 2.0 / iResolution.x * r;
    float ifx2 = INTERFERENCE2 * (r * peak(uv.y, 0.2, 0.2));
    uv.x += ifx1 + -ifx2;
    
    fragColor = texture(iChannel0, uv);
}
