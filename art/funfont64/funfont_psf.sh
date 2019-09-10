

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib


psf2fnt funfont_4x8b.psf  funfont_4x8b.fon
psf2fnt funfont_8x16b.psf funfont_8x16b.fon
psf2fnt funfont_8x16i.psf funfont_8x16i.fon
psf2fnt funfont_8x16r.psf funfont_8x16r.fon

psf2bdf funfont_4x8b.psf  funfont_4x8b.bdf
psf2bdf funfont_8x16b.psf funfont_8x16b.bdf
psf2bdf funfont_8x16i.psf funfont_8x16i.bdf
psf2bdf funfont_8x16r.psf funfont_8x16r.bdf


fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont4 -w Bold    -n funfont4Bold   -N funfont4Bold   -O funfont_4x8b.bdf

fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont8 -w Bold    -n funfont8Bold   -N funfont8Bold   -O funfont_8x16b.bdf
fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont8 -w Normal  -n funfont8       -N funfont8       -O funfont_8x16r.bdf
fontforge -lang=py -script ./mkttf.py -V "" -A ' -a -1' -f funfont8 -w Italic  -n funfont8Italic -N funfont8Italic -O funfont_8x16i.bdf
