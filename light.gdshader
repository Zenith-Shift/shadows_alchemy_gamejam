shader_type spatial;
render_mode blend_mix, cull_back, depth_prepass_alpha, diffuse_burley, specular_schlick_ggx, unshaded;

uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 0.5); // Base color with transparency
uniform float light_intensity : hint_range(0.0, 10.0) = 0.0; // Intensity of the light effect
uniform float transparency : hint_range(0.0, 1.0) = 0.5; // Transparency control

void fragment() {
    // Calculate the base color with transparency
    vec4 base_color = albedo_color;
    base_color.a = albedo_color.a * transparency;
    
    // Calculate light visibility
    vec3 light_accum = vec3(0.0);
    vec3 normal = normalize(NORMAL);
    vec3 view_dir = normalize(VIEW);
    
    // Apply light visibility with intensity
    vec3 light_effect = light_accum * light_intensity;
    
    // Combine the base color and the light effect
    vec4 final_color = vec4(base_color.rgb + light_effect, base_color.a);
    
    // Output the final color
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}