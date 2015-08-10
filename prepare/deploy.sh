#!/bin/bash

ssh people.redhat.com mkdir -p ~/public_html/atomic-training

test -f index.html && scp index.html people.redhat.com:~/public_html/atomic-training

find . -iname *.iso -exec scp {} people.redhat.com:~/public_html/atomic-training \;
