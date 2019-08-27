
![FunFont64](https://github.com/xriss/fun64/blob/master/art/funfont64/funfont64_mips.fat.png "FunFont64")

FunFont64
=========

FunFont64 is primarily a 4x8 fixed width pixel font designed for use in 
Fun64 as the smallest fixed width font you can get away with.

This font has been upscaled to 8x16 where it is a readable console font 
on 1080p displays and we have enough pixels to support regular and 
italic/oblique versions.

We have all the https://en.wikipedia.org/wiki/ISO/IEC_8859-15 glyphs 
Which is mostly the first 256 unicode glyphs and mostly covers Western 
European text, mostly.

The .psf and .psf.gz files can be used with the linux console via setfont.
On linux you can download the .psf.gz files and put them in /usr/share/consolefonts then
switch to a real terminal with CTRL+ALT+F3 or whichever F key gets you a login prompt,
login and run.

	setfont funfont_8x16r

This selects funfont 8x16 regular, we have bold, regular and italic versions
of the 8x16 sized fonts but only bold versions of the 4x8 size font as you can
probably guess from the filenames.

Please feel free to use and modify and republish in anyway you like, the 
included MIT license just seems the least terrible option.
