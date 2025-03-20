const CONFIG_DIR = '~/.config'
const APP_SUPPORT_DIR = '~/Library/Application Support'
const NU_DIR = ($APP_SUPPORT_DIR | path join 'nushell')

let configs = [
	[target, link];
	['.global.gitattributes', '~/.global.gitattributes']
	['.global.gitignore', '~/.global.gitignore']
	['.global.gitconfig', '~/.gitconfig']
	['.private.gitconfig', '~/.private.gitconfig']
	['dust/config.toml', ($CONFIG_DIR | path join 'dust/config.toml')]
	['starship/starship.toml', ($CONFIG_DIR | path join 'starship.toml')]
	['nushell/env.nu', ($NU_DIR | path join 'env.nu')]
	['nushell/config.nu', ($NU_DIR | path join 'config.nu')]
	['nushell/modules', ($NU_DIR | path join 'modules')]
	['ghostty/config', ($APP_SUPPORT_DIR | path join 'com.mitchellh.ghostty/config')]
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
