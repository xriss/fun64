
![FunFont64](https://github.com/xriss/fun64/blob/master/art/funfont64/funfont64_bold_mips.fat.png "FunFont64")
![FunFont64](https://github.com/xriss/fun64/blob/master/art/funfont64/funfont64_regular_mips.fat.png "FunFont64")
![FunFont64](https://github.com/xriss/fun64/blob/master/art/funfont64/funfont64_italic_mips.fat.png "FunFont64")

FunFont64
=========

FunFont64 is primarily a 4x8 fixed width pixel font designed for use in 
Fun64 as the smallest fixed font you can get away with.

This base 4x8 font has been upscaled by hand to 8x8 and 8x16.

At 8x16 it is a readable console font on 1080p displays.

As a sideffect of this upscaling the strokes are rather thick so 
perhaps consider this font bold by default. This also makes us sans 
serif, although a small amount of serif hackery is used on thin glyphs 
to help cover the fixed width.

A non bold version at 8x16 has also been included.

Although we have an 8x8 version I would avoid using it for walls of 
text as the fatness and lack of linespace makes it looked rather ugly. 
It mostly exists as a halfway step on the upscale to keep everything 
as consistant as possible.

Currently we only support 7bit ASCII characters but plan to add in 
diacriticals as soon as we work out exactly what we need and where to 
put them. https://en.wikipedia.org/wiki/ISO/IEC_8859-15 looks like the 
best layout as it is mostly unicode but swaps some of the less used 
glyphs out for more important ones. This is currently a work in 
progress.

FunFont64 is designed to be used with a character based fragment 
shader, take a look at the Fun64 source for an example of how that 
works.

Please feel free to use and modify and republish in anyway you like, the 
included MIT license just seems the least terrible option.
