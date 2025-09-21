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
		(INPUT_FONT=$font_file.name ^fontforge
			--script $patcher_path
			$font_file.name
			--mono
			--complete
			--postprocess $renamer_path
			--outputdir $out_dir_path)
	}
}
