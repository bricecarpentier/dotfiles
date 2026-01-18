import { duoLayer, map, RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	duoLayer("q", "w").manipulators([
		map("j").to("1"),
		map("k").to("2"),
		map("l").to("3"),
		map("u").to("4"),
		map("i").to("5"),
		map("o").to("6"),
        map("tab").to("left_shift")
]);
