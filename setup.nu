const CONFIG_DIR = '~/Library/Application Support'

let configs = [
	[target, link];
	['.global.gitattributes', '~/.global.gitattributes']
	['.global.gitignore', '~/.global.gitignore']
	['.global.gitconfig', '~/.gitconfig']
	['.private.gitconfig', '~/.private.gitconfig']
	['bat/theme/themes/Catppuccin Mocha.tmTheme', ($CONFIG_DIR | path join 'bat' 'themes' 'Catppuccin Mocha.tmTheme')]
	['bat/config', ($CONFIG_DIR | path join 'bat' 'config')]
	['dust/config.toml', '~/.config/dust/config.toml']
	['ghostty/config', ($CONFIG_DIR | path join 'com.mitchellh.ghostty' 'config')]
	['npm/.npmrc', ($CONFIG_DIR | path join 'npm' '.npmrc')]
	['nushell/env.nu', ($CONFIG_DIR | path join 'nushell' 'env.nu')]
	['nushell/config.nu', ($CONFIG_DIR | path join 'nushell' 'config.nu')]
	['nushell/modules', ($CONFIG_DIR | path join 'nushell' 'modules')]
	['starship/starship.toml', ($CONFIG_DIR | path join 'starship' 'starship.toml')]
]

for $config in $configs {
	let target = ($config.target | path expand --no-symlink)
	let link = ($config.link | path expand --no-symlink)
	let target_exists = ($target | path exists)
	let link_exists = ($link | path exists)

	if $target_exists and not $link_exists {
		mkdir ($link | path dirname)
		^ln -s $target $link

		print $"(ansi green)created link ($config.link) -> ($config.target)(ansi reset)"
	} else {
		let reason = if not $target_exists {
			"target doesn't exist"
		} else {
			"link already exists"
		}

		print $"(ansi yellow)skipping link ($config.link) -> ($config.target):(ansi reset) ($reason)"
	}
}
