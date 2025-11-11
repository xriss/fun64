cd `dirname $0`

rsync -avh ../gamecake/exe     plated/source/wasm/ --delete --human-readable
rsync -avh ../gamecake/html/js plated/source/wasm/ --delete --human-readable

rm plated/source/wasm/exe/.git



