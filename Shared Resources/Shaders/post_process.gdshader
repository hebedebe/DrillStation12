shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Controls
uniform float desaturation = 0.7; // 0 = full color, 1 = grayscale
uniform float noise_strength = 0.05;
uniform float vignette_strength = 0.6;
uniform float vignette_radius = 1.0;
uniform float contrast = 1.2;

// Grain controls
uniform float grain_luminance_factor = 0.8; // How much luminance affects grain (0 = no effect, 1 = full effect)
uniform float grain_response_curve = 2.0; // Response curve for luminance (higher = more aggressive reduction in bright areas)

// Chromatic aberration controls
uniform float aberration_strength = 0.002; // Strength of the aberration effect
uniform float aberration_falloff = 1.5; // How quickly aberration falls off from center (higher = more concentrated at edges)

// Motion blur controls
uniform vec2 motion_blur_direction = vec2(0.001, 0.0); // Direction and strength of motion blur
uniform int motion_blur_samples = 8; // Number of samples for motion blur (higher = smoother but more expensive)

float random(vec2 uv) {
	return fract(sin(dot(uv * TIME, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
	vec2 centered = uv - vec2(0.5);
	float distance_from_center = length(centered);
	
	// Motion blur - sample multiple times along motion direction
	vec3 color = vec3(0.0);
	float total_weight = 0.0;
	
	for (int i = 0; i < motion_blur_samples; i++) {
		float offset_factor = (float(i) / float(motion_blur_samples - 1)) - 0.5; // Range from -0.5 to 0.5
		vec2 sample_uv = uv + motion_blur_direction * offset_factor;
		
		// Check if sample is within bounds
		if (sample_uv.x >= 0.0 && sample_uv.x <= 1.0 && sample_uv.y >= 0.0 && sample_uv.y <= 1.0) {
			// Calculate chromatic aberration for this sample
			vec2 sample_centered = sample_uv - vec2(0.5);
			float sample_distance = length(sample_centered);
			float aberration_amount = pow(sample_distance, aberration_falloff) * aberration_strength;
			vec2 aberration_offset = normalize(sample_centered) * aberration_amount;
			
			// Sample each color channel with chromatic aberration
			float r = texture(screen_texture, sample_uv - aberration_offset).r;
			float g = texture(screen_texture, sample_uv).g;
			float b = texture(screen_texture, sample_uv + aberration_offset).b;
			
			// Weight samples towards center (gaussian-like)
			float weight = 1.0 - abs(offset_factor * 2.0); // Linear falloff
			weight = weight * weight; // Square for more gaussian-like curve
			
			color += vec3(r, g, b) * weight;
			total_weight += weight;
		}
	}
	
	// Normalize by total weight
	if (total_weight > 0.0) {
		color /= total_weight;
	} else {
		// Fallback if no valid samples (shouldn't happen normally)
		color = texture(screen_texture, uv).rgb;
	}
	
	// Calculate luminance before desaturation for grain calculation
	float luminance = dot(color, vec3(0.299, 0.587, 0.114));
	
	// Desaturation
	float gray = luminance;
	color = mix(color, vec3(gray), desaturation);
	
	// Luminance-modulated flickering noise
	// Reduce grain strength in brighter areas using a power curve
	float luminance_factor = 1.0 - pow(luminance, grain_response_curve) * grain_luminance_factor;
	float modulated_noise_strength = noise_strength * luminance_factor;
	
	float noise = (random(uv) - 0.5) * modulated_noise_strength;
	color += vec3(noise);
	
	// Vignette
	float vignette = 1.0 - smoothstep(0.0, vignette_radius, distance_from_center);
	color *= mix(1.0, vignette, vignette_strength);
	
	// Contrast (basic)
	color = (color - 0.5) * contrast + 0.5;
	
	// Clamp final color
	color = clamp(color, 0.0, 1.0);
	
	COLOR = vec4(color, 1.0);
}