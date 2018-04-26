

FILES=$(find ../gists -type f -name '*.fun.lua')

for f in $FILES ; do
	echo "Linking $f"
	ln -s $f
done

