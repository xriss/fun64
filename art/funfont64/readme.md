
![FunFont64](https://github.com/xriss/fun64/blob/master/art/funfont64/funfont64_mips.fat.png "FunFont64")


FunFont64
=========

FunFont64 is primarily a 4x8 fixed width pixel font designed for use in 
Fun64 as the smallest font you can get away with.

This base 4x8 font has been upscaled by hand to 8x8 and 8x16, we may 
need to add a 16x32 as well but for now 8x16 is big enough for my 
needs.

At 8x16 it is a readable console font on 1080p displays.

Although we have an 8x8 version I would avoid using it for walls of 
text as the lack of linespace makes it looked rather ugly.

Currently we only support 7bit ASCII characters but plan to add in 
diacriticals as soon as we work out exactly what we need and where to 
put them.

FunFont64 is designed to be used with a character based fragment 
shader, take a look at the Fun64 source for an example of how that 
works.

Please feel free to use and modify and republish in anyway you like, the 
included MIT license just seems the least terrible option.
