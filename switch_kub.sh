#!/bin/bash

case $1 in
  test)
    kubectl config use-context test.us-east-2.k8s.domain.com
  ;;
  poc)
    kubectl config use-context dev-poc.us-east-2.k8s.local
  ;;
  desk)
   kubectl config use-context docker-for-desktop
  ;;
  ort-west)
   echo 'export AWS_SDK_LOAD_CONFIG=1 && export AWS_PROFILE=<AWS_PROFILE>'
   kubectl config use-context ort.us-west-2.k8s.domain.com
esac
