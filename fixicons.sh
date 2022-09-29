#!/bin/bash
find grails-app/views/ -type f -name "*.gsp" -print0 | xargs -0 sed -i -re "s/<span class=\"([a-z_]*)\"><\/span>/<span class=\"\1 ico\"><\/span>/g"
# class=\"(.*)\"(.*)>(.*)</g\:link><\/span>/<span class=\"menuButton\"><g\:link \2><span class=\"\2\"><\/span>\3</g\:link><\/span>/g}"


