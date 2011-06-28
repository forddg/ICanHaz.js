SHELL = /bin/bash

VERSION = $(shell cat version.txt;)

COMPILER = /usr/local/bin/closure-compiler.jar
WGET = /usr/bin/wget

ICH = ICanHaz.js
ICH_MIN = ICanHaz.min.js
JEESH = jeesh.min.js


BASE_FILES = source/mustache.js \
	source/main.js

all: normal min jeesh

normal: $(ICH)

min: $(ICH_MIN)

jeesh: $(JEESH)


$(ICH): $(BASE_FILES)
	@@echo
	@@echo "Building" $(ICH) "..."
	@@cat source/intro.js | sed -e 's/@VERSION@/$(VERSION)/' > $(ICH)
	@@echo "(function ($$) {" >> $(ICH)
	@@cat $(BASE_FILES) | sed -e 's/@VERSION@/$(VERSION)/' >> $(ICH)
	@@echo "})(window.jQuery || window.Zepto);" >> $(ICH)
	@@echo $(ICH) "built."
	@@echo


$(ICH_MIN): $(ICH)
	@@echo
	@@echo "Building" $(ICH_MIN) "..."
ifdef COMPILER
	@@java -jar $(COMPILER) --compilation_level SIMPLE_OPTIMIZATIONS --js=$(ICH) > $(ICH_MIN)
	@@echo $(ICH_MIN) "built."
else
	@@echo $(ICH_MIN) "not built."
	@@echo "    Google Closure complier required to build minified version."
	@@echo "    Please point COMPILER variable in 'makefile' to the jar file."
endif
	@@echo

$(JEESH):
	@@echo
	@@echo "Need to get a copy of 'jeesh.min.js.'"
	@@echo "Trying to 'wget http://ender-js.s3.amazonaws.com/jeesh.min.js'"...
	@@echo "Using path: " $(WGET)
	@@echo
ifdef WGET	
	@@$(WGET) http://ender-js.s3.amazonaws.com/jeesh.min.js
	@@echo $(JEESH) "Retrieved."
else
	@@echo $(JEESH) "Not Retrieved."
	@@echo "Something went wrong (:"
	@@echo "Check out 'https://github.com/ender-js/jeesh'."
endif
	@@echo
