shader_type spatial;

render_mode unshaded, cull_disabled, depth_test_disabled,
    depth_draw_never, blend_mix;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float thickness : hint_range(0.5, 5.0) = 1.0;
uniform float threshold : hint_range(0.001, 1.0) = 0.05;

// QuadMesh size must be 2 x 2
void vertex() {
    POSITION = vec4(VERTEX.xy, 0.0, 1.0);
}

float linear_depth(vec2 uv, mat4 inv_proj) {
    float raw = texture(DEPTH_TEXTURE, uv).r;
    vec3 ndc = vec3(uv * 2.0 - 1.0, raw * 2.0 - 1.0);
    vec4 view = inv_proj * vec4(ndc, 1.0);
    view.xyz /= view.w;
    return -view.z;
}

void fragment() {
    vec2 px = thickness / VIEWPORT_SIZE;

    float c = linear_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
    float u = linear_depth(SCREEN_UV + vec2(0.0, px.y), INV_PROJECTION_MATRIX);
    float d = linear_depth(SCREEN_UV - vec2(0.0, px.y), INV_PROJECTION_MATRIX);
    float l = linear_depth(SCREEN_UV - vec2(px.x, 0.0), INV_PROJECTION_MATRIX);
    float r = linear_depth(SCREEN_UV + vec2(px.x, 0.0), INV_PROJECTION_MATRIX);

    float diff = abs(c - u) + abs(c - d) + abs(c - l) + abs(c - r);
    float edge = smoothstep(threshold, threshold * 2.0, diff);

    ALBEDO = outline_color.rgb;
    ALPHA = edge * outline_color.a;
}