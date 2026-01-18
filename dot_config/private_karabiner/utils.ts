import type {
	KarabinerConfig,
	KarabinerProfile,
	KeyboardType,
} from "@karabiner";

interface ExtendedKarabinerProfile extends KarabinerProfile {
	virtual_hid_keyboard: { keyboard_type_v2: KeyboardType };
}
interface ExtendedKarabinerConfig extends KarabinerConfig {
	profiles: [ExtendedKarabinerProfile];
}

export const MakeConfig = (
	profile: string,
	selected: boolean,
	keyboardType: KeyboardType,
): ExtendedKarabinerConfig => ({
	profiles: [
		{
			name: profile,
			selected,
			complex_modifications: { parameters: {}, rules: [] },
			virtual_hid_keyboard: { keyboard_type_v2: keyboardType },
		},
	],
});

export async function overwriteConfig(
	outputFile: "--dry-run" | string,
	config: KarabinerConfig,
): Promise<void> {
	const encoder = new TextEncoder();
	await Deno.writeFile(outputFile, encoder.encode(JSON.stringify(config)));
}
