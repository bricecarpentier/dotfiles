import { map, rule, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	rule("Stop Cmd-Shift-i triggering Mail.app").manipulators([
		map("i", ["command", "shift"]).to("left_shift"),
	]);
