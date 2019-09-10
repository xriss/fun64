

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib


psf2fnt funfont_4x8b.psf  funfont_4x8b.fon
psf2fnt funfont_8x16b.psf funfont_8x16b.fon
psf2fnt funfont_8x16i.psf funfont_8x16i.fon
psf2fnt funfont_8x16r.psf funfont_8x16r.fon

psf2bdf funfont_4x8b.psf  funfont_4x8b.bdf
psf2bdf funfont_8x16b.psf funfont_8x16b.bdf
psf2bdf funfont_8x16i.psf funfont_8x16i.bdf
psf2bdf funfont_8x16r.psf funfont_8x16r.bdf


#fontforge --lang=ff -c 'Open("funfont_4x8b.fon"); Generate("funfont_4x8b.ttf")'
#fontforge --lang=ff -c 'Open("funfont_8x16b.fon"); Generate("funfont_8x16b.ttf")'
#fontforge --lang=ff -c 'Open("funfont_8x16i.fon"); Generate("funfont_8x16i.ttf")'
#fontforge --lang=ff -c 'Open("funfont_8x16r.fon"); Generate("funfont_8x16r.ttf")'

