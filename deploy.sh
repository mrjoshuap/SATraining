#!/bin/bash

ssh people.redhat.com mkdir -p public_html/atomic-training

test -f prepare/index.html && scp prepare/index.html people.redhat.com:~/public_html/atomic-training
test -f infrastructure-diagram.png && scp infrastructure-diagram.png people.redhat.com:~/public_html/atomic-training

find . -iname *.iso -exec scp {} people.redhat.com:~/public_html/atomic-training \;
