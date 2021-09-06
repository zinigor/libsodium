#! /bin/sh

CT='ct.c'

echo '#include <assert.h>' > "$CT"
echo '#include <sodium.h>' >> "$CT"
echo 'int main(void) {' >> "$CT"
for macro in $(egrep -r '#define crypto_.*BYTES ' src/libsodium/include | \
               cut -d: -f2- | cut -d' ' -f2 | \
               fgrep -v edwards25519sha512batch | sort -u); do
  func=$(echo "$macro" | tr A-Z a-z)
  echo "  assert($func() == $macro);" >> "$CT"
done
echo "return 0; }" >> "$CT"

cc -Wno-deprecated-declarations "$CT" -lsodium && ./a.out
rm -f a.out "$CT"

