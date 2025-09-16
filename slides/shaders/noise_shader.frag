// https://www.shadertoy.com/view/DdcfzH
// Modified to compile for Flutter and apply noise as an overlay effect

#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float filmGrainIntensity;
uniform sampler2D iChannel0;

out vec4 fragColor;

// Inspired by https://www.shadertoy.com/view/wdyczG
// Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License:
// https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(2127.1, 81.17)), dot(p, vec2(1269.5, 283.37)));
    return fract(sin(p)*43758.5453);
}

float filmGrainNoise(in vec2 uv) {
    return length(hash(vec2(uv.x, uv.y)));
}

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / iResolution.xy;
    
    // Get the original image/widget content
    vec3 originalColor = texture(iChannel0, uv).rgb;
    
    // Apply film grain
    float grain = filmGrainNoise(uv) * filmGrainIntensity;
    // Mix the grain with the original color instead of subtracting
    // This creates a more natural film grain effect
    vec3 finalColor = originalColor * (1.0 - grain * 0.5) + grain * 0.1;
    
    fragColor = vec4(finalColor, texture(iChannel0, uv).a);
}
