#!/bin/bash

cd "$(dirname "$0")"

echo Kompiluję Sortowanie topologiczne

ocamlopt -g -c pMap.mli pMap.ml topol.mli topol.ml || exit 1

for f in tests/*.ml
do
    echo Przetwarzam: $(basename "$f")
    ocamlopt -g -c "$f" || exit 2
    ocamlopt -g -o "${f%%.*}" pMap.cmx topol.cmx "${f%%.*}".cmx || exit 3
    time OCAMLRUNPARAM="b,l=100M" ./"${f%%.*}"
    rm "${f%%.*}" "${f%%.*}".cmx "${f%%.*}".cmi
done
