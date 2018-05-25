Copyright 2018 Kriss@wetgenes.com

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the 
"Software"), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to 
the following conditions:

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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

Please feel free to use and modify and republish in anyway you like the 
MIT license just seems the least terrible option.
