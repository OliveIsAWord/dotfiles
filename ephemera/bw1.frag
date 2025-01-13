precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 src = texture2D(tex, v_texcoord);
    float srcAlpha = src.a;
    vec3 color = src.rgb;
    float luminance = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
    // float luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
    // float luminance = sqrt(0.299 * color.r * color.r + 0.587 * color.g * color.g + 0.114 * color.b * color.b);
    gl_FragColor = vec4(vec3(luminance), srcAlpha);
}
