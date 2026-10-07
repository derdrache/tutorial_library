shader_type spatial;

uniform float borderWidth = .01;
uniform vec2 gridSize = vec2(10, 10);
uniform vec4 borderColor: source_color = vec4(1);
uniform vec4 cellColor: source_color = vec4(0, 0, 0, 1);

void fragment() {
	vec2 uvGrid = fract(UV * gridSize);

	vec2 borderLinesTopRight = step(uvGrid, vec2(borderWidth));
	vec2 borderLinesBottomLeft = step(vec2(1.0) - vec2(borderWidth), uvGrid);
	
	vec2 borderLines = borderLinesTopRight + borderLinesBottomLeft;
	float borderLinesFloat = borderLines.x + borderLines.y;
	
	bool isBorder = borderLinesFloat > 0.0;
	
	if(isBorder){
		ALBEDO.rgb = borderColor.rgb;
		ALPHA = borderColor.a;
	}else{
		ALBEDO.rgb = cellColor.rgb;
		ALPHA = cellColor.a;
	}
	
}
