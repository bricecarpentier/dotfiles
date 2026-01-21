import { duoLayer, map, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	duoLayer("a", "s")
		.manipulators([
			map("h", [], ["option", "command"]).to("left_arrow"),
			map("j", [], ["option", "command"]).to("down_arrow"),
			map("k", [], ["option", "command"]).to("up_arrow"),
			map("l", [], ["option", "command"]).to("right_arrow"),

			map("4", [], ["shift"]).to("e", ["control"]),
			map("6", [], ["shift"]).to("a", ["control"]),

			map("w", [], ["shift"]).to("right_arrow", ["option"]),
			map("b", [], ["shift"]).to("left_arrow", ["option"]),

			map("j", ["left_shift"]).to("page_down"),
			map("k", ["left_shift"]).to("page_up"),
		])
		.description("Nav layer");
