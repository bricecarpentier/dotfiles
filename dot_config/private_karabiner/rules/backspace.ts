import { map, rule, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder =>
	rule("Shift backspace => Delete forward").manipulators([
		map("delete_or_backspace", ["⇧"]).to("delete_forward"),
	]);
