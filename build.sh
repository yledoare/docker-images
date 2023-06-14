EXPORT_IMAGES=$PWD
[ -e $HOME/export-images.ini ] && source  $HOME/export-images.ini

ls | while read image
do
  test -d $image || continue
  cd $image
  echo "Build $image"
  [ ! -e $EXPORT_IMAGES/$image.img ] && docker build -t $image . && docker save -o $EXPORT_IMAGES/$image.img $image
  [ ! -e $EXPORT_IMAGES/$image.img ] && exit 1 
  cd ..
done
