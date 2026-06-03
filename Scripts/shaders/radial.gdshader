shader_type canvas_item;

uniform sampler2D fill_texture_overlay;
uniform sampler2D bg_texture;
uniform float fill_ratio:hint_range(0., 1.) = 1.;
uniform float start_angle:hint_range(0., 360.) = 0.;
uniform float max_angle:hint_range(0., 360.) = 360.;
uniform bool invert_fill = false;
uniform bool reflect_x = false;
uniform bool reflect_y = false;
uniform vec2 offset = vec2(0., 0.);

// NUEVO: Control de opacidad para la parte del fondo/vacía
uniform float bg_opacity:hint_range(0., 1.) = 0.5;

mat2 tex_rotate(float _angle){
	return mat2(vec2(cos(_angle), -sin(_angle)), vec2(sin(_angle), cos(_angle)));
}

void fragment() {
	float fill_angle = radians(fill_ratio * max_angle);
	vec2 uv = ((UV * 2. - 1.) + offset) * tex_rotate(-radians(start_angle));
	
	if (reflect_x) {
		uv *= mat2(vec2(-1., 0.), vec2(0., 1.));
	}
	if (reflect_y) {
		uv *= mat2(vec2(1., 0.), vec2(0., -1.));
	}
	
	vec4 base_tex = texture(TEXTURE, UV);
		
	if ((!invert_fill && atan(uv.x, uv.y) + PI < fill_angle) || (invert_fill && atan(uv.x, uv.y) + PI > fill_angle)) {
		COLOR = base_tex * texture(fill_texture_overlay, UV);
	} else {
		vec4 bg_color = texture(bg_texture, UV);
		
		// Multiplicamos el canal alfa por nuestro nuevo parámetro 'bg_opacity'
		COLOR = vec4(bg_color.rgb, bg_color.a * base_tex.a * bg_opacity);
	}
}