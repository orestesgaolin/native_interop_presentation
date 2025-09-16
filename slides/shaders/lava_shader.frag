// https://www.shadertoy.com/view/DdcfzH
// Modified to compile for Flutter

#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;
uniform float filmGrainIntensity;

out vec4 fragColor;

// Inspired by https://www.shadertoy.com/view/wdyczG
// Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License:
// https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en
mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(2127.1, 81.17)), dot(p, vec2(1269.5, 283.37)));
    return fract(sin(p)*43758.5453);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = f*f*(3.0-2.0*f);

    float n = mix(mix(dot(-1.0+2.0*hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
    dot(-1.0+2.0*hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
    mix(dot(-1.0+2.0*hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
    dot(-1.0+2.0*hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
    return 0.5 + 0.5*n;
}

float filmGrainNoise(in vec2 uv) {
    return length(hash(vec2(uv.x, uv.y)));
}

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / iResolution.xy;
    float aspectRatio = iResolution.x / iResolution.y;
    
    // Transformed uv
    vec2 tuv = uv - .5;

    // Rotate with noise
    float degree = noise(vec2(iTime*.05, tuv.x*tuv.y));

    tuv.y *= 1./aspectRatio;
    tuv *= Rot(radians((degree-.5)*720.+180.));
    tuv.y *= aspectRatio;

    // Wave warp with sine
    float frequency = 5.;
    float amplitude = 30.;
    float speed = iTime * 2.;
    tuv.x += sin(tuv.y*frequency+speed)/amplitude;
    tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);
    
    // Light gradient colors
    vec3 amberYellow = vec3(299, 186, 137) / vec3(255);
    vec3 deepBlue = vec3(49, 98, 238) / vec3(255);
    vec3 pink = vec3(246, 146, 146) / vec3(255);
    vec3 blue = vec3(89, 181, 243) / vec3(255);
    
    // Dark gradient colors
    vec3 purpleHaze = vec3(105, 49, 245) / vec3(255);
    vec3 swampyBlack = vec3(32, 42, 50) / vec3(255);
    vec3 persimmonOrange = vec3(233, 51, 52) / vec3(255);
    vec3 darkAmber = vec3(233, 160, 75) / vec3(255);
    
    // Interpolate between light and dark gradient
    float cycle = sin(iTime * 0.5);
    float t = (sign(cycle) * pow(abs(cycle), 0.6) + 1.) / 2.;
    vec3 color1 = mix(amberYellow, purpleHaze, t);
    vec3 color2 = mix(deepBlue, swampyBlack, t);
    vec3 color3 = mix(pink, persimmonOrange, t);
    vec3 color4 = mix(blue, darkAmber, t);

    // Blend the gradient colors and apply transformations
    vec3 layer1 = mix(color3, color2, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));
    vec3 layer2 = mix(color4, color1, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));
    
    vec3 color = mix(layer1, layer2, smoothstep(.5, -.3, tuv.y));

    // Apply film grain
    color = color - filmGrainNoise(uv) * filmGrainIntensity;
    
    fragColor = vec4(color, 1.0);  
}