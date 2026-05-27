shader_type canvas_item;

uniform vec2 pixel_scale = vec2(15.0);

// 渐变颜色
uniform vec4 top_color = vec4(0.0, 0.6, 0.9, 1.0);
uniform vec4 bottom_color = vec4(0.0, 0.0, 0.0, 0.0);

// 波动参数
uniform float wave_amplitude : hint_range(0.0, 0.5) = 0.12;
uniform float wave_frequency = 4.0;
uniform float wave_speed = 1.2;

// 第二层波动（增加潮水细节）
uniform float wave2_amplitude : hint_range(0.0, 0.3) = 0.04;
uniform float wave2_frequency = 8.7;
uniform float wave2_speed = -1.8;

void fragment() {
	//直接替换原材质用这个
	//vec2 uv = UV;
	vec2 uv = floor(UV * pixel_scale)/pixel_scale;
	
    // 波动强度从 0 (顶部) 线性增长到 1 (底部)
    float intensity = uv.y;
    
    // 第一层波动：垂直方向位移
    float wave1 = sin(uv.x * wave_frequency + TIME * wave_speed) 
                  * wave_amplitude * intensity;
    
    // 第二层波动：更高频率，不同速度，相位沿 Y 变化
    float phase = uv.y * 3.0;
    float wave2 = sin(uv.x * wave2_frequency + phase + TIME * wave2_speed) 
                  * wave2_amplitude * intensity;
    
    // 合成扰动后的 Y 坐标
    float distorted_y = uv.y + wave1 + wave2;
    
    // 钳制在 0~1，避免出界
    distorted_y = clamp(distorted_y, 0.0, 1.0);
    
	//修改材质用这个
	//uv *= pixel_scale;
	//uv = floor(uv);
	//uv /=pixel_scale;
	//vec4 raw_texture = texture(TEXTURE,uv);
	
	COLOR = mix(top_color, bottom_color, distorted_y);
	//COLOR = raw_texture;
	

}