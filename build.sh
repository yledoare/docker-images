EXPORT_IMAGES=$PWD
[ -e $HOME/export-images.ini ] && source  $HOME/export-images.ini

ls |grep odoo-17 | while read image
do
  test -d $image || continue
  cd $image
  echo "Build $image"
  [ -e $EXPORT_IMAGES/$image.img ] && cd .. && continue
  docker build -t $image . || exit 1
  echo docker save -o $EXPORT_IMAGES/$image.img $image
  docker save -o $EXPORT_IMAGES/$image.img $image || exit 1
  chmod 755 $EXPORT_IMAGES/$image.img 
  cd ..
done
