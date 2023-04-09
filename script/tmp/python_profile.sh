#!/bin/bash
printf '<%s>' "$@" >> /tmp/pargs
echo "$$" >>/tmp/pargs
mkdir -p /tmp/profile
if test $# -ge 2 && test "x$1" = x-c ; then
  tmpfile="$(mktemp)"
  echo "$2" > "$tmpfile"
  shift
  shift
  python -m cProfile -o /tmp/profile/$$ "$tmpfile" "$@"
elif test $# -ge 1 && test "x${1#-}" = "x$1" ; then
  python -m cProfile -o /tmp/profile/$$ "$@"
else
  exit 1
fi
