from pathlib import Path
from sys import argv

# This is implemented in C and it does not provide type information.
import fontforge  # ty: ignore[unresolved-import]

src_font = fontforge.open(argv[1])
dest_font = fontforge.open(argv[2])
dest_font_file = Path(argv[2])

# Copy the original font's metadata to the patched font.
dest_font.persistent = {
	"fontname": src_font.fontname,
	"fullname": src_font.fullname,
	"familyname": src_font.familyname,
}
dest_font.fontname = src_font.fontname
dest_font.familyname = src_font.familyname
dest_font.fullname = src_font.fullname
dest_font.version = src_font.version
dest_font.sfntRevision = src_font.sfntRevision
dest_font.copyright = src_font.copyright
dest_font.sfnt_names = ()
dest_font.os2_panose = src_font.os2_panose
dest_font.comment = src_font.comment

for lang, strid, string in src_font.sfnt_names:
	dest_font.appendSFNTName(lang, strid, string)

dest_font.generate(str(dest_font_file.parent.joinpath(src_font.fontname + dest_font_file.suffix)))
# Remove the file created by the font patcher.
dest_font_file.unlink()
