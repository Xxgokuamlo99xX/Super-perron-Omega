shader_type canvas_item;

uniform float health : hint_range(0.0, 1.0) = 0.75;
uniform vec4 liquid_color : source_color = vec4(0.8, 0.1, 0.2, 1.0);
uniform float wave_speed = 3.0;
uniform float wave_amplitude = 0.03;
uniform float wave_frequency = 5.0;
uniform float pixel_size = 64.0;

// NUEVO: Qué tan caótico o aleatorio queremos que sea el movimiento
uniform float randomness_strength : hint_range(0.0, 1.0) = 0.5; 

void fragment() {
    // 1. Pixelamos las coordenadas UV
    vec2 uv = round(UV * pixel_size) / pixel_size;
    
    // 2. Modulamos la amplitud con el tiempo (hace que las olas crezcan y se calmen de forma impredecible)
    // El "TIME * 2.5" hace que este pulso sea independiente de la velocidad de la ola.
    float dynamic_amplitude = wave_amplitude * (1.0 + sin(TIME * 2.5) * randomness_strength);
    
    // 3. Ola principal (la que ya teníamos)
    float wave1 = sin(uv.x * wave_frequency + TIME * wave_speed);
    
    // 4. Ola secundaria (va en otra dirección, a diferente velocidad y con otra frecuencia)
    // Usamos 'cos' y multiplicamos los valores para que nunca se sincronice con la primera
    float wave2 = cos(uv.x * (wave_frequency * 1.7) - TIME * (wave_speed * 1.3));
    
    // 5. Combinamos ambas olas
    float final_wave = (wave1 + (wave2 * randomness_strength)) * dynamic_amplitude;
    
    // 6. Calculamos el nivel de superficie con nuestra nueva ola caótica
    float liquid_level = 1.0 - health; 
    float current_surface = liquid_level + final_wave;
    
    // 7. Aplicamos el color
    if (uv.y > current_surface) {
        COLOR = liquid_color;
    } else {
        COLOR = vec4(0.0);
    }
    
    // 8. Enmascaramos con la forma del frasco
    COLOR.a *= texture(TEXTURE, UV).a;
}