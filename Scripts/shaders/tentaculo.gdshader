shader_type canvas_item;

// 0.0 = El sprite está completo. 1.0 = Totalmente borrado.
uniform float progreso : hint_range(0.0, 1.0) = 0.0;

// Opcional: Un color brillante justo en la línea donde se está borrando
uniform vec4 color_borde : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float grosor_borde : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    // Leemos el píxel normal de tu imagen
    vec4 color_original = texture(TEXTURE, UV);
    
    // En Godot, UV.y es 0.0 en la parte de ARRIBA del sprite, y 1.0 en la parte de ABAJO.
    // Invertimos el progreso para que el corte empiece desde abajo (1.0) hacia arriba (0.0).
    float altura_corte = 1.0 - progreso;
    
    // 1. Si el píxel está por debajo de la línea de corte, lo hacemos transparente
    if (UV.y > altura_corte) {
        COLOR = vec4(0.0);
    }
    // 2. Si el píxel está justo en el borde del barrido (para darle un efecto chulo de energía)
    else if (UV.y > altura_corte - grosor_borde && progreso > 0.0 && progreso < 1.0) {
        // Mezclamos el color original con el color del borde, respetando la transparencia (alpha) del sprite
        COLOR = mix(color_original, color_borde, color_original.a);
    }
    // 3. Si está por encima del corte, se dibuja normal
    else {
        COLOR = color_original;
    }
}