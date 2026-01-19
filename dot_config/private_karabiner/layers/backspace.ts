import { layer, map, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	layer("equal_sign")
		.manipulators([map("delete_or_backspace").to("delete_forward")])
		.description("Backspace layer");
