import { layer, map, type RuleBuilder } from "@karabiner";

export default (): RuleBuilder[] => [
    layer("f11").manipulators([
		map("f10").toConsumerKey("mute"),
    ]),
	layer("f10").manipulators([
		map("f11").toConsumerKey("volume_decrement"),
		map("f12").toConsumerKey("volume_increment"),
	]),
	layer("f3")
		.manipulators([
			map("f1").toConsumerKey("display_brightness_decrement"),
			map("f2").toConsumerKey("display_brightness_increment"),
		])
		.description("Functions layer"),
];
