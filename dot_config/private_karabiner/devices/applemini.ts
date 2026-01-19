import { Device } from "../utils.ts";

export default (): Device => ({
	identifiers: {
		is_keyboard: true,
		product_id: 801,
		vendor_id: 76,
	},
	ignore: false,
});
