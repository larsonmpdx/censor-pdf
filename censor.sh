#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

rm -rf ./output/

echo "copying input to output dir"
cp -r ./input/ ./output/

cd ./output/

shopt -s nullglob globstar dotglob
for file in ./**; do
  if [ -f "$file" ]; then
      if [[ $file != *.pdf ]]; then
        continue
      fi
      echo "$file"
      # https://manpages.org/pdfcrop
      # unit is "bp".  one inch is 72 bp
      # left top right bottom
      pdfcrop --margins '10 -20 10 -10' --clip "$file" "$file" # after this the cropped data will still be part of the file and is visible in an editor like inkscape

      # https://stackoverflow.com/questions/21706976/ghostscript-removes-content-outside-the-crop-box
      # this isn't the safest thing possible because ghostscript will pass through many parts of the pdf. for extra safety we'd want to use an image printer instead
      gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dUseCropBox -sOutputFile="$file".temp "$file" # this does a "print to pdf" operation and can clean up some things. -dUseCropBox is the crucial flag to remove data outside the crop margins
      mv -f "$file".temp "$file" # ghostscript can't overwrite files so we do that after

      # we could now try to restore the original margins, or not
  fi
done
