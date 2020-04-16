#!/usr/bin/env bash
# ip address kafka
KAFKA=$1
# ip address zookeeper
ZOOKEEPER=$2
# aws region
AWS_REGION=$3

function usage {
    echo "Usage
    $0 kafka_ip zookeeper_ip:port region (us-east-1,us-west-2...)"
    exit 1
}

#check arguments
if [ $# -ne 3 ]; then
    usage
else
# anything '^__' is an kafka internal topic, that kafka itself creates and uses
LIST=($(ssh $KAFKA "/usr/local/kafka/bin/kafka-topics.sh --zookeeper $ZOOKEEPER --list" | grep -v '^__'))
# generate TF config file with all topics, skip this step if topics_list.tf exists
if [ ! -f ./kafka-region/topics_list.tf ]; then
  for topic in "${LIST[@]}"
  do
    dash="${topic//[^-]}"
    # exclude any topics with 3+ '-' characters
    if (( "${#dash}" < 3 )); then
      echo -e "module \""${topic/\./_}"\" {\n\
      source     = \""git-repo-to-kafka-topic-module"\"\n\
      topic_name = \""$topic"\"\n\
}\n" >> ./kafka-region/topics_list.tf
    fi
  done
fi

# initialize a working directory containing Terraform configuration files
terraform init

# import all topics to state
for topic in "${LIST[@]}"
do
  dash="${topic//[^-]}"
  # exclude any topics with 3+ '-' characters
  if (( "${#dash}" < 3 )); then
    terraform import module.$AWS_REGION.module."${topic/\./_}".kafka_topic.topic $topic
  fi
done
fi

exit 0