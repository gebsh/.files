use std/util 'path add'
use modules/theme.nu [ catppuccin_mocha palette ]

$env.PNPM_HOME = ('~/Library/pnpm' | path expand)
$env.CARGO_HOME = ('~/.cargo/bin' | path expand)

path add '/usr/local/sbin'
path add '/usr/local/bin'
path add '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
path add $env.PNPM_HOME
path add $env.CARGO_HOME

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

$env.GPG_TTY = (tty)

$env.HOMEBREW_PREFIX = '/usr/local'
$env.HOMEBREW_CELLAR = '/usr/local/Cellar'
$env.HOMEBREW_REPOSITORY = '/usr/local/Homebrew'
$env.HOMEBREW_NO_ANALYTICS = 1

$env.STARSHIP_SHELL = 'nu'
$env.STARSHIP_SESSION_KEY = (random chars -l 16)
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
