// Flutter-compatible Bokeh Shader
// Decoded from: vec2 p=FC.xy/r.y;for(float i,f,g;i++<9.;o+=(cos(p.y+p.x/.6+g+vec4(0,1,2,0))+1.)*smoothstep(-9.,9.,(.3-length(cos(p++/.3+t*.2)))*r.y/exp(f=sin(i)*i+i))/exp(f/3.+sin(i+g+t))*(g=cos(p/.4).x)*g)p*=mat2(8,-6,6,8)/9.;o=sqrt(tanh(.2*o));

#version 460 core
precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;

out vec4 fragColor;

void main() {
    vec2 FC = FlutterFragCoord().xy;
    vec2 r = iResolution;
    float t = iTime;
    vec4 o = vec4(0.0);
    
    // Original algorithm decoded and made readable
    vec2 p = FC.xy / r.y;
    
    for (float i = 0.0; i < 11.0; i++) {
        float f, g;
        
        // Calculate oscillating values
        g = cos(p.x / 0.4).x;
        f = sin(i) * i + i;
        
        // Create bokeh circles with color variations
        vec4 colorShift = vec4(0, 1, 2, 0);
        vec4 cosColor = cos(p.y + p.x / 0.6 + g + colorShift) + 1.0;
        
        // Distance-based circle calculation
        float circleDistance = 0.3 - length(cos(p + i / 0.3 + t * 0.2));
        float circleValue = smoothstep(-9.0, 9.0, circleDistance * r.y / exp(f));
        
        // Brightness and fading
        float brightness = 1.0 / exp(f / 3.0 + sin(i + g + t));
        
        // Combine all components
        o += cosColor * circleValue * brightness * g * g;
        
        // Transform coordinates for next iteration
        p *= mat2(8, -6, 6, 8) / 9.0;
    }
    
    // Apply final color processing
    o = sqrt(tanh(0.4 * o));
    
    fragColor = vec4(o.rgb, 1.0);
}
