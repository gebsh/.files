# The Catppuccin Mocha theme based on the official nushell integration:
#
# https://github.com/catppuccin/nushell/blob/82c31124b39294c722f5853cf94edc01ad5ddf34/themes/catppuccin_mocha.nu
#
# The integration is licensed under the following MIT License:
#
# > MIT License
# >
# > Copyright (c) 2021 Catppuccin
# >
# > Permission is hereby granted, free of charge, to any person obtaining a copy
# > of this software and associated documentation files (the "Software"), to deal
# > in the Software without restriction, including without limitation the rights
# > to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# > copies of the Software, and to permit persons to whom the Software is
# > furnished to do so, subject to the following conditions:
# >
# > The above copyright notice and this permission notice shall be included in all
# > copies or substantial portions of the Software.
# >
# > THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# > IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# > FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# > AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# > LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# > OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# > SOFTWARE.
export const palette = {
	rosewater: '#f5e0dc'
	flamingo: '#f2cdcd'
	pink: '#f5c2e7'
	mauve: '#cba6f7'
	red: '#f38ba8'
	maroon: '#eba0ac'
	peach: '#fab387'
	yellow: '#f9e2af'
	green: '#a6e3a1'
	teal: '#94e2d5'
	sky: '#89dceb'
	sapphire: '#74c7ec'
	blue: '#89b4fa'
	lavender: '#b4befe'
	text: '#cdd6f4'
	subtext1: '#bac2de'
	subtext0: '#a6adc8'
	overlay2: '#9399b2'
	overlay1: '#7f849c'
	overlay0: '#6c7086'
	surface2: '#585b70'
	surface1: '#45475a'
	surface0: '#313244'
	base: '#1e1e2e'
	mantle: '#181825'
	crust: '#11111b'
}

export const scheme = {
	# Code Editors > Language Defaults
	keyword: $palette.mauve
	string: $palette.green
	symbol: $palette.red
	escape_sequence: $palette.pink
	comment: $palette.overlay2
	constant: $palette.peach
	operator: $palette.sky
	delimiter: $palette.overlay2
	function: $palette.blue
	parameter: $palette.maroon
	builtin: $palette.red
	type: $palette.yellow
	enum_variant: $palette.teal
	property: $palette.blue
	attribute: $palette.yellow
	macro: $palette.rosewater

	# Code Editors > General
	error: $palette.red

	# Custom tokens
	datetime: $palette.pink # Follow what the official VS Code Catppuccin Mocha uses for datetime literals in TOML.
	file: $palette.pink
	variable: $palette.text
}

const TODO = '#ff0000'

export const catppuccin_mocha = {
	# Shapes
	shape_binary: $scheme.constant
	shape_block: $scheme.delimiter
	shape_bool: $scheme.constant
	shape_closure: $scheme.delimiter
	shape_custom: $TODO
	shape_datetime: $scheme.datetime
	shape_directory: $scheme.file
	shape_external: $palette.text
	shape_external_resolved: $scheme.function
	shape_externalarg: $palette.text
	shape_filepath: $scheme.file
	shape_flag: $scheme.parameter
	shape_float: $scheme.constant
	shape_garbage: $scheme.error
	shape_globpattern: $scheme.file
	shape_int: $scheme.constant
	shape_internalcall: $scheme.function
	shape_keyword: $scheme.keyword
	shape_list: $scheme.delimiter
	shape_literal: $scheme.constant
	shape_matching_brackets: { attr: u }
	shape_match_pattern: $scheme.constant
	shape_nothing: $scheme.keyword
	shape_operator: $scheme.operator
	shape_pipe: $scheme.operator
	shape_range: $TODO
	shape_raw_string: $scheme.string
	shape_record: $scheme.delimiter
	shape_redirection: $scheme.operator
	shape_signature: $scheme.type
	shape_string: $scheme.string
	shape_string_interpolation: $scheme.string
	shape_table: $scheme.delimiter
	shape_vardecl: $scheme.variable
	shape_variable: $scheme.variable

	# Values
	binary: $scheme.constant
	block: $scheme.delimiter
	bool: $scheme.constant
	cell-path: $TODO
	closure: $scheme.delimiter
	custom: $TODO
	date: $scheme.datetime
	duration: $scheme.datetime
	filesize: $scheme.file
	float: $scheme.constant
	glob: $scheme.file
	int: $scheme.constant
	list: $scheme.delimiter
	nothing: $scheme.keyword
	range: $TODO
	record: $scheme.delimiter
	string: $scheme.string

	# UI
	empty: { attr: n }
	header: { fg: $palette.text, attr: b }
	hints: $palette.surface2
	leading_trailing_space_bg: { attr: n }
	row_index: $scheme.comment
	search_result: $TODO
	separator: $scheme.delimiter
}
