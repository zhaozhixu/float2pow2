#! /bin/bash -x

find $@ -type f -name '*.bak' | while read fname
do
    mv $fname ${fname/.bak/}
done
