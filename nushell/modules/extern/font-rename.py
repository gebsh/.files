#!/usr/bin/env python3
import fontforge
import os
from pathlib import Path
from sys import argv

filepath = Path(argv[1])
in_font = fontforge.open(os.environ.get('INPUT_FONT'))
out_font = fontforge.open(argv[1])

# Copy the original font's metadata to the patched font.
out_font.persistent = {
    "fontname": in_font.fontname,
    "fullname": in_font.fullname,
    "familyname": in_font.familyname,
}
out_font.fontname = in_font.fontname
out_font.familyname = in_font.familyname
out_font.fullname = in_font.fullname
out_font.version = in_font.version
out_font.sfntRevision = in_font.sfntRevision
out_font.copyright = in_font.copyright
out_font.sfnt_names = ()
out_font.os2_panose = in_font.os2_panose
out_font.comment = in_font.comment

for (lang, strid, string) in in_font.sfnt_names:
    out_font.appendSFNTName(lang, strid, string)

out_font.generate(str(filepath.parent.joinpath(in_font.fontname + filepath.suffix)))
filepath.unlink()
