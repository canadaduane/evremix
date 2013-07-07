SOURCE_TEXT=$1
ROOT=${SOURCE_TEXT%\.txt}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Creating dir $ROOT"
mkdir "$ROOT"
for N in 1 2 3 4 5 6; do
  echo "Making ${N}-grams"
  cat "$SOURCE_TEXT" | ruby "$DIR/make-ngrams.rb" $N | sort | uniq >"$ROOT/${N}-grams.txt"
done