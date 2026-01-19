import type {
	KarabinerConfig,
	KarabinerProfile,
	KeyboardType,
	DeviceIdentifier,
} from "@karabiner";

export interface Device {
	identifiers: DeviceIdentifier;
	ignore: boolean;
	ignore_vendor_events?: boolean;
}

interface ExtendedKarabinerProfile extends KarabinerProfile {
	virtual_hid_keyboard: { keyboard_type_v2: KeyboardType };
	devices: Device[];
}
interface ExtendedKarabinerConfig extends KarabinerConfig {
	profiles: [ExtendedKarabinerProfile];
}

export const MakeConfig = (
	profile: string,
	selected: boolean,
	keyboardType: KeyboardType,
	devices: Device[],
): ExtendedKarabinerConfig => ({
	profiles: [
		{
			name: profile,
			selected,
			complex_modifications: { parameters: {}, rules: [] },
			virtual_hid_keyboard: { keyboard_type_v2: keyboardType },
			devices,
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
