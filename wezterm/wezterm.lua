local wezterm = require 'wezterm'

return {
	color_scheme = 'Dracula (Official)',
	enable_tab_bar = false,
	font_size = 16,
	font = wezterm.font('JetBrains Mono'),	
	window_background_image = os.getenv( "HOME" ) .. '/.config/assets/wezterm-background-image.gif',
	window_background_image_hsb = {
		brightness = 0.1,
	},
	window_background_opacity = 0.9,
	window_decorations = 'RESIZE',
	keys = {
		{
			key = 'f',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
	  -- Ctrl-click will open the link under the mouse cursor
	  {
	    event = { Up = { streak = 1, button = 'Left' } },
	    mods = 'CTRL',
	    action = wezterm.action.OpenLinkAtMouseCursor,
	  },
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
}