const XDG_CONFIG_HOME = '~/Library/Application Support'

let configs = [
	[target, link];
	['.global.gitattributes', '~/.global.gitattributes']
	['.global.gitignore', '~/.global.gitignore']
	['.global.gitconfig', '~/.gitconfig']
	['.private.gitconfig', '~/.private.gitconfig']
	['bat/config', ($XDG_CONFIG_HOME | path join 'bat' 'config')]
	['biome/config.jsonc', '~/biome.jsonc']
	['clang/.clang-format', '~/.clang-format']
	['dust/config.toml', '~/.config/dust/config.toml']
	['ghostty/config', ($XDG_CONFIG_HOME | path join 'com.mitchellh.ghostty' 'config')]
	['npm/.npmrc', ($XDG_CONFIG_HOME | path join 'npm' '.npmrc')]
	['nushell/env.nu', ($XDG_CONFIG_HOME | path join 'nushell' 'env.nu')]
	['nushell/config.nu', ($XDG_CONFIG_HOME | path join 'nushell' 'config.nu')]
	['nushell/modules', ($XDG_CONFIG_HOME | path join 'nushell' 'modules')]
	['ruff/ruff.toml', '~/.ruff.toml']
	['starship/starship.toml', ($XDG_CONFIG_HOME | path join 'starship' 'starship.toml')]
	['vscodium/snippets', ($XDG_CONFIG_HOME | path join 'VSCodium' 'User' 'snippets')]
	['vscodium/settings.jsonc', ($XDG_CONFIG_HOME | path join 'VSCodium' 'User' 'settings.json')]
]

for $config in $configs {
	let target = ($config.target | path expand --no-symlink)
	let link = ($config.link | path expand --no-symlink)
	let target_exists = ($target | path exists)
	let link_exists = ($link | path exists)

	if $target_exists and not $link_exists {
		mkdir ($link | path dirname)
		^ln -s $target $link

		print $'(ansi green)created link ($config.link) -> ($config.target)(ansi reset)'
	} else {
		let reason = if not $target_exists {
			"target doesn't exist"
		} else {
			'link already exists'
		}

		print $'(ansi yellow)skipping link ($config.link) -> ($config.target):(ansi reset) ($reason)'
	}
}
