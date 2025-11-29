# Various font commands.
export def main []: nothing -> nothing {}

# Patches font files in the specified directory with the Nerd Fonts patcher.
#
# By default all TTF files in the directory are processed and saved to the `patched` subdirectory.
export def patch [
	dir: directory # The directory containing font files to patch
	--ext (-e): string # The extension of input font files
	--out-dir (-o): directory # The directory where the patched font files will be saved
]: nothing -> nothing {
	let externs_path = ($nu.config-path | path expand | path dirname | path join 'modules' 'extern')
	let patcher_path = ($externs_path | path join 'nerd-fonts' 'font-patcher')
	let renamer_path = ($externs_path | path join 'font-rename.py')
	let in_ext = ($ext | default 'ttf')
	let in_pattern = ($dir | path join $'*.($in_ext)' | into glob)
	let out_dir_path = ($out_dir | default { $dir | path join 'patched' } )
	let dir_span = ($dir | metadata).span

	let font_files = try {
		ls $in_pattern
	} catch {
		ignore # https://github.com/nushell/nushell/issues/16600
		let dir_span = (metadata $dir).span

		error make {
			msg: 'No fonts found'
			label: {
				text: $'This directory does not contain any `.($in_ext)` files'
				span: {
					start: $dir_span.start
					end: $dir_span.end
				}
			}
		}
	}

	for font_file in $font_files {
		let stdout = (^fontforge
			--script $patcher_path
			$font_file.name
			--mono
			--complete
			--outputdir $out_dir_path)
		let out_file = (
			$stdout | lines | last | parse -r "\\===> '(?<path>.+?)'" | first | get path
		)

		^fontforge --script $renamer_path $font_file.name $out_file
	}
}

const COOKIE_SEPARATOR = '; '
const DEFAULT_VARIANTS = [
	{}
	{ suffix: 'Nerd Font' }
	{
		suffix: 'Preconfigured Ligatures Nerd Font'
		exclude: ['liga']
		freeze: ['zero', 'ss01', 'ss03', 'ss07', 'ss08', 'ss12', 'ss13', 'ss15', 'ss16']
	}
]

# Downloads the specified variants of the latest stable version of the MonoLisa font using the
# provided credentials.
#
# Unless the output directory is specified, the downloaded files are saved to the `XDG_DOWNLOAD_DIR`
# directory, or to the current directory if that environment variable is not set.
export def download [
	email: string # The user's e-mail
	order_id: string # The order number
	--out-dir (-o): directory # The directory where the downloaded fonts will be saved
	--variants (-v): list = $DEFAULT_VARIANTS # A list of font variants to download
]: nothing -> nothing {
	let out_dir_path = ($out_dir | default $env.XDG_DOWNLOAD_DIR | default './')
	let get_cookies = { |headers|
		$headers
			| where name == 'set-cookie'
			| get value
			| each { split row -n 2 $COOKIE_SEPARATOR | first }
	}
	let join_cookies = { |cookies| $cookies | str join $COOKIE_SEPARATOR }

	let credentials_url = (
		http get 'https://www.monolisa.dev/api/auth/providers'
			| get credentials.callbackUrl
	)

	let csrf_response = (
		http get --full 'https://www.monolisa.dev/api/auth/csrf'
			| get headers.response body
	)
	let csrf_cookies = do $get_cookies $csrf_response.0
	let csrf_token = $csrf_response.1.csrfToken

	let credentials_cookies = (
		http post
			--headers { Cookie: (do $join_cookies $csrf_cookies) }
			--content-type 'application/x-www-form-urlencoded'
			$credentials_url
			{
				email: $email
				order_id: $order_id
				redirect: false
				csrfToken: $csrf_token
				json: true
			}
			| metadata
			| get http_response.headers
			| do $get_cookies $in
	)

	let cookies = ($csrf_cookies | append $credentials_cookies | uniq)

	for $variant in $variants {
		let body = (
			$variant
				| merge {
					format: 'ttf'
					releaseType: 'stable'
					weights: [300 400 500 600 700]
				}
				| default '' suffix
				| default [] exclude freeze
				| insert fileName { |body|
					if ($body.suffix | is-empty) {
						$'MonoLisa-($body.releaseType).zip'
					} else {
						$'MonoLisa-($body.suffix)-($body.releaseType).zip'
					}
				}
		)
		let out_file_path = ($out_dir_path | path join $body.fileName)

		print --no-newline $'Downloading ($body.fileName)...'

		(http post
			--headers { Cookie: (do $join_cookies $cookies) }
			--content-type 'text/plain'
			'https://www.monolisa.dev/api/download/v2/desktop'
			($body | to json) out> $out_file_path)

		print ' done'
	}
}
