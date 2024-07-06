local wezterm = require 'wezterm'

return {
	color_scheme = 'Dracula',
	font_size = 16,
	font = wezterm.font('JetBrains Mono'),	
	window_background_image = os.getenv( "HOME" ) .. '/.config/assets/wezterm-background-image.gif',
	window_background_image_hsb = {
		brightness = 0.1,
	},
	window_background_opacity = 0.9,
}