ls | while read image
do
  test -d $image || continue
  cd $image
  echo "Build $image"
  	[ ! -e $image.img ] && docker build -t $image .
	exit 1
  cd ..
done
