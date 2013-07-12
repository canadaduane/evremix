SOURCE_TEXT=$1
ROOT=${SOURCE_TEXT%\.txt}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Creating dir $ROOT"
mkdir "$ROOT"
for N in 1 2 3 4 5; do
  echo "Making ${N}-grams"
  $DIR/mkngrams -b -n $N "$SOURCE_TEXT" | sort | uniq -c | gzip -c >"$ROOT/${N}-grams.txt.gz"
done