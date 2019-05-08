#!/usr/bin/env bash
function usage {
    echo "Usage
    $0 /path/to/your/dir"
    exit 1
}
#check arguments
if [ $# -ne 1 ]; then
    usage
else
  cd $1
  # find all directories containing 4 digits
  LIST=(`ls | grep -P '\d{4}' | tr ' ' '\n'`)
  # archiving and deleting found directories
  eval tar -zcvf result.tar.gz "${LIST[*]}"
  eval rm -r "${LIST[*]}"
fi
exit 0

