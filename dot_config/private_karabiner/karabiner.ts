import { parseArgs } from "@std/cli/parse-args";
import * as Path from "@std/path";
import * as Fs from "@std/fs";
import {
	type ManipulatorBuilder,
	map,
	type Rule,
	type RuleBuilder,
	writeToGlobal,
	writeToProfile,
} from "@karabiner";
import nav from "./layers/nav.ts";
import { MakeConfig, overwriteConfig } from "./utils.ts";
import backspace from "./layers/backspace.ts";
import numbers from "./layers/numbers.ts";
import functions from "./layers/functions.ts";
import air60 from "./devices/air60.ts";
import stopCmdShiftITriggeringMailApp from "./rules/stop-mail-app.ts";

const args = parseArgs(Deno.args);
const [outputFile] = args._;

function help(): string {
	return "Usage: deno --allow-end --allow-read --allow-write karabiner.ts <outputFile>";
}

if (typeof outputFile === "undefined" || typeof outputFile === "number") {
	console.error(help());
	console.error();
	console.error("Missing file name");
	Deno.exit(1);
}

const parentDir = Path.dirname(outputFile);
await Fs.ensureDir(parentDir);

const simple_modifications: ManipulatorBuilder[] = [
	map("caps_lock").to("escape"),
	map("escape").to("caps_lock"),
];

const rules: Array<Rule | RuleBuilder> = [
	stopCmdShiftITriggeringMailApp(),
	backspace(),
	nav(),
	numbers(),
	...functions(),
];

const profileName = "Default";
const config = MakeConfig(profileName, true, "ansi", [air60()]);

await overwriteConfig(outputFile, config);

writeToGlobal(
	{
		check_for_updates_on_startup: false,
		show_in_menu_bar: true,
		show_profile_name_in_menu_bar: false,
	},
	outputFile,
);

writeToProfile(
	{
		name: profileName,
		karabinerJsonPath: outputFile,
	},
	rules,
	{
		"duo_layer.threshold_milliseconds": 25,
	},
	{ simple_modifications },
);
