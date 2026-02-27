// @name t
// @WARNING This file is a duplicate/redundant. Functionality overlaps with color_modifier.gdshaderinc (apply_color_strength). Consider removing or merging.
// @category Fragment
// @type Spatial
// @description Non-descriptive name "t" - unclear purpose, likely incomplete or dead code

uniform vec3 gdsl_source_color : source_color = vec3(1.0);
uniform float gdsl_strength : hint_range(0.0, 2.0) = 1.0;

vec3 gdsl_apply(vec3 color) {
	return color * gdsl_strength;
}
