

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib


psf2fnt funfont_4x8b.psf  funfont_4x8b.fon
psf2fnt funfont_8x16b.psf funfont_8x16b.fon
psf2fnt funfont_8x16i.psf funfont_8x16i.fon
psf2fnt funfont_8x16r.psf funfont_8x16r.fon

psf2bdf funfont_4x8b.psf  funfont_4x8b.bdf
psf2bdf funfont_8x16b.psf funfont_8x16b.bdf
psf2bdf funfont_8x16i.psf funfont_8x16i.bdf
psf2bdf funfont_8x16r.psf funfont_8x16r.bdf


fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont_4x8  -w Bold    -n funfont_4x8Bold    -N funfont_4x8Bold    -O funfont_4x8b.bdf

fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont_8x16 -w Bold    -n funfont_8x16Bold   -N funfont_8x16Bold   -O funfont_8x16b.bdf
fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont_8x16 -w Normal  -n funfont_8x16       -N funfont_8x16       -O funfont_8x16r.bdf
fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont_8x16 -w Italic  -n funfont_8x16Italic -N funfont_8x16Italic -O funfont_8x16i.bdf
