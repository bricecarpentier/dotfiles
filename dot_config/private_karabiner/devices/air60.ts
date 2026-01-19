import { Device } from "../utils.ts";

export default (): Device => ({
	identifiers: {
		is_keyboard: true,
		is_pointing_device: true,
		product_id: 12870,
		vendor_id: 6645,
	},
	ignore: false,
});
