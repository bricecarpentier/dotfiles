import { duoLayer, map, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	duoLayer("a", "s").manipulators([
		map("h").to("left_arrow"),
		map("j").to("down_arrow"),
		map("k").to("up_arrow"),
		map("l").to("right_arrow"),

		map("j", ["shift"]).to("page_down"),
		map("k", ["shift"]).to("page_up"),
	]);
