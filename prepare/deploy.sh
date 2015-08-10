#!/bin/bash

test -f index.html && scp index.html people.redhat.com:~/public_html/atomic-training

find . -iname *.iso -exec scp {} people.redhat.com:~/public_html/atomic-training \;
