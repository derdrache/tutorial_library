shader_type canvas_item;

uniform float skew = 0;

void vertex() {
   	VERTEX.x += (1.0-UV.y) * skew;
}