#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;

out vec4 fragColor;

// CONFIGURATION

//Layers
float layerCount = 2.0;
float numberOfBlobsPerLayer = 3.0; // One side is hidden to make it more irregular

// Size
float circleSize = 0.9; // 0-1
float borderSize = 0.015; // 0-1

// Animations
float pulseAnimationStrength = 0.02; // 0-1
float pulseAnimationSpeed = 1.0;

#define PI 3.14159265358979323846264338327950288
#define positiveSin(number) (sin(number) + 1.0) / 2.0
#define remap(number, oldMin, oldMax, newMin, newMax) (number - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin

float saturate(float number){
    return clamp(number, 0.0, 1.0);
}

float radialGradient(vec2 uv){
    float distanceToCenter = distance(vec2(0.5, 0.5), uv);
    vec2 uvRadial = uv - vec2(0.5, 0.5);
    float angle = atan(uvRadial.y, uvRadial.x);
    float radialGradient = (angle + PI) / (2.0 * PI);
    return radialGradient;
}


float getNumberOfLayers(){
    return layerCount * positiveSin(iTime * PI);
}

float getCircleSize(){
    float circleAnimation01 = positiveSin(iTime * pulseAnimationSpeed); //This can be replaced with volume input
    float circleSizeWithoutBorder = circleSize - borderSize * 2.0;
    float pulseAnimationStrengthMapped = remap(pulseAnimationStrength, 0.0, 1.0, 0.0, circleSizeWithoutBorder);
    return remap(circleAnimation01, 0.0, 1.0, circleSizeWithoutBorder - pulseAnimationStrengthMapped, circleSizeWithoutBorder);
}

float circleMask(float distance){
    float circleSizeConfigured = 1.0 / (getCircleSize() * 0.5);
    return pow(saturate(distance * circleSizeConfigured), 50.0);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    // UV Map
    float aspectRatio = iResolution.x / iResolution.y;
    vec2 uv = fragCoord / iResolution.xy * vec2(aspectRatio, 1.0) + vec2(1.0 - aspectRatio, 0.0) * 0.5;

    // Color Gradient
    vec3 color = 0.5 + 0.5 * cos(iTime + uv.xyx + vec3(0,2,4));
    vec4 initialColor = vec4(color,1.0);
    
    // Radial UV Map
    float distanceToCenter = distance(vec2(0.5, 0.5), uv);
    float radial = radialGradient(uv);
        
    // Generate Circle Mask
    float innerCircleMask = circleMask(distanceToCenter);
    float outerCircleMask = 0.0;
    float layers = getNumberOfLayers();
    
    // Generate Moving Blobs
    for(int i = 0; i <= 3; i++){
        float x = float(i);
        float layerWeight = positiveSin(iTime * x * 0.572); //
        // float layerWeight = saturate(layers - x);

        float rotationSpeed = sin((x + 1.0) * 4.62843) * 0.4;
        float distance = (1.0 - getCircleSize()) / 2.0 * (layerWeight - borderSize);
        float distanceNoise = saturate(sin(mod(radial + iTime * rotationSpeed, 1.0) * PI * numberOfBlobsPerLayer) * distance);
        outerCircleMask += circleMask(distanceToCenter - distanceNoise - borderSize) / 3.0;
    }
    
    //Combine Masks
    outerCircleMask = saturate(outerCircleMask);
    fragColor = initialColor * (innerCircleMask - outerCircleMask) ;
}