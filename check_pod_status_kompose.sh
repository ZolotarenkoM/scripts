#!/bin/bash

SVC=$1
NS=$2
x=1000

function usage {
    echo "Usage
    $0 your_svc namespace"
    exit 1
}
#check arguments
if [ $# -eq 1 ] || [ $# -eq 2 ]; then
  # default namespace
  if [[ -z $NS ]]; then NS='default'; fi
  while [ $x -gt 0 ]
  do
    if [[ $(kubectl get po --context=docker-for-desktop -l "io.kompose.service=$SVC" -n $NS --no-headers=true | tr -s " " | cut -d " " -f3) = 'Running' ]]; then
      kubectl logs --context=docker-for-desktop -f -l "app=$SVC" -n $NS
    else
      echo "$SVC - $(kubectl get po --context=docker-for-desktop -l "app=$SVC" -n $NS --no-headers=true | tr -s " " | cut -d " " -f3)"
    fi
    sleep 5
    x=$(( $x - 1 ))
  done
else
  usage
fi

exit 0