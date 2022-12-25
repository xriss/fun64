Welcome to fun64 the super simple super lowrez single file game engine 
powered by [gamecake](https://github.com/xriss/gamecake/tree/master/lua/wetgenes/gamecake/fun).

Try the live html version of the example projects here, this site can be fund in the plated/source folder.

https://wetgenes.com/fun64

Note that we can not use github pages anymore as it does not send headers now required by wasm.

If you have cloned this repo and intend to run the example files in the fun directory on linux/mac/raspbian/etc then
be sure to use git-pull to get latest gamecake binaries for your operating system into the exe directory.

	git clone https://github.com/xriss/fun64.git
	cd fun64
	./git-pull

Alternatively gamecake can be installed from the snap store and be used to run .fun.lua files from the command line like so.

	snap install gamecake
	
	gamecake test.fun.lua
	
Or if you are on windows then the same can be done with a gamecake.exe that can just be downloaded and used as is.

	gamecake.exe test.fun.lua

Finally you should also be able to drag and drop .fun.lua files onto a gamecake.exe without using a command line.

	
