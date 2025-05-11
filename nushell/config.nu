use std/util 'path add'
use modules/theme.nu [ catppuccin_mocha palette ]

const HOME_DIR = ('~' | path expand)

# Add some XDG environment variables because there are tools that unconditionally use them instead
# of OS-specific directories leading to inconsistencies and polluting the home directory.
#
# These paths are taken from https://docs.rs/dirs/6.0.0/dirs/ with an exception for the
# `XDG_STATE_HOME` variable (used for example by pnpm), which is set to the cache directory.
$env.XDG_CACHE_HOME = ($HOME_DIR | path join 'Library' 'Caches')
$env.XDG_CONFIG_HOME = ($HOME_DIR | path join 'Library' 'Application Support')
$env.XDG_DATA_HOME = $env.XDG_CONFIG_HOME
$env.XDG_DESKTOP_DIR = ($HOME_DIR | path join 'Desktop')
$env.XDG_DOCUMENTS_DIR = ($HOME_DIR | path join 'Documents')
$env.XDG_DOWNLOAD_DIR = ($HOME_DIR | path join 'Downloads')
$env.XDG_MUSIC_DIR = ($HOME_DIR | path join 'Music')
$env.XDG_PICTURES_DIR = ($HOME_DIR | path join 'Pictures')
$env.XDG_PUBLICSHARE_DIR = ($HOME_DIR | path join 'Public')
$env.XDG_STATE_HOME = $env.XDG_CACHE_HOME
$env.XDG_VIDEOS_DIR = ($HOME_DIR | path join 'Movies')

$env.PNPM_HOME = ($env.XDG_DATA_HOME | path join 'pnpm')
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join 'cargo')
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join 'rustup')

path add '/usr/local/sbin'
path add '/usr/local/bin'
path add '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
path add $env.PNPM_HOME
path add ($env.CARGO_HOME | path join 'bin')

def --env --wrapped j [...rest: string] {
	let path = match $rest {
		[] => '~',
		['-'] => '-',
		[$arg] if ($arg | path type) == 'dir' => $arg,
		_ => {
			^zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n"
		}
	}

	cd $path
}

def --env --wrapped ji [...rest: string] {
	cd $'(^zoxide query --interactive -- ...$rest | str trim -r -c "\n")'
}

alias tree = ^dust

$env.VISUAL = 'code'
$env.LS_COLORS = (
	[
		[type, fg];
		['*', $palette.text]
		[di, $palette.yellow]
		[ln, $palette.blue]
		[so, $palette.mauve]
		[pi, $palette.pink]
		[ex, $palette.text]
		[bd, $palette.peach]
		[cd, $palette.maroon]
		[su, $palette.text]
		[sg, $palette.text]
		[tw, $palette.yellow]
		[ow, $palette.yellow]
	]
	| each {|row|
		let rgb = (
			$row.fg
			| str substring 1..
			| decode hex
			| chunks 1
			| each {|byte| $byte | into int }
			| str join ';'
		)

		$'($row.type)=38;2;($rgb)'
	}
	| str join ':'
)

$env.GNUPGHOME = ($env.XDG_CONFIG_HOME | path join 'gnupg')
$env.GPG_TTY = (tty)

$env.HOMEBREW_PREFIX = '/usr/local'
$env.HOMEBREW_CELLAR = '/usr/local/Cellar'
$env.HOMEBREW_REPOSITORY = '/usr/local/Homebrew'
$env.HOMEBREW_NO_ANALYTICS = 1
$env.HOMEBREW_NO_ENV_HINTS = 1

$env.NODE_REPL_HISTORY = ($env.XDG_CACHE_HOME | path join 'node' 'repl_history')
$env.NPM_CONFIG_USERCONFIG = ($env.XDG_CONFIG_HOME | path join 'npm' '.npmrc')

$env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join 'starship' 'starship.toml')
$env.STARSHIP_SHELL = 'nu'
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
$env.STARSHIP_CACHE = ($env.XDG_CACHE_HOME | path join 'starship')
$env.PROMPT_COMMAND = {||
	(^starship prompt
		--cmd-duration $env.CMD_DURATION_MS
		$"--status=($env.LAST_EXIT_CODE)"
		--terminal-width (term size).columns)
}
$env.PROMPT_COMMAND_RIGHT = {||
	(^starship prompt
		--right
		--cmd-duration $env.CMD_DURATION_MS
		$"--status=($env.LAST_EXIT_CODE)"
		--terminal-width (term size).columns)
}
$env.PROMPT_INDICATOR = ''
$env.PROMPT_INDICATOR_VI_INSERT = ''
$env.PROMPT_INDICATOR_VI_NORMAL = ''
$env.PROMPT_MULTILINE_INDICATOR = (^starship prompt --continuation)
$env.TRANSIENT_PROMPT_COMMAND = {||
	$'(^starship module directory)(^starship module character)'
}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ''
$env.TRANSIENT_PROMPT_INDICATOR = ''
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ''
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ''
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ''

$env.config.buffer_editor = 'code'
$env.config.color_config = $catppuccin_mocha
$env.config.display_errors.termination_signal = false
$env.config.filesize.precision = 2
$env.config.footer_mode = 'auto'
$env.config.highlight_resolved_externals = true
$env.config.history.file_format = 'sqlite'
$env.config.history.isolation = true
$env.config.history.max_size = 1_000_000
$env.config.hooks.env_change = {
	PWD: [{ |_, dir| ^zoxide add -- $dir }]
}
$env.config.render_right_prompt_on_last_line = true
$env.config.show_banner = false
$env.config.table.missing_value_symbol = '<empty>'
