import { duoLayer, map, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	duoLayer("a", "s").manipulators([
		map("h", [], ["shift", "option", "command"]).to("left_arrow"),
		map("j", [], ["shift", "option", "command"]).to("down_arrow"),
		map("k", [], ["shift", "option", "command"]).to("up_arrow"),
		map("l", [], ["shift", "option", "command"]).to("right_arrow"),

		map("j", ["left_shift"]).to("page_down"),
		map("k", ["left_shift"]).to("page_up"),
	]);
