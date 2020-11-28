#!/bin/bash

function print_help() {
	echo "usage: $0 COMMAND";
	echo ""
	echo "The commands are:"
	echo "  lint     - Check if the Dart syntax of the code is correct."
	echo "  fix-lint - Fix the Dart syntax of the code."
	echo "  test     - Run the tests."
}

function rmdoc() {
	echo "Removing documentation..."
	rm -rf doc/api
	exit_code=$?
	if [[ $exit_code -ne 0 ]]; then
		echo "Could not remove the documentation."
	fi
	return $exit_code
}

if [[ $# == 0 ]]; then
	echo "An argument must be given."
	print_help
	exit 1
fi

exit_code=0

if [[ $1 == "lint" ]]; then
	echo "Checking Dart files format..."
	dartfmt -n --set-exit-if-changed .
	exit_code=$?
elif [[ $1 == *"fix"* && $1 == *"lint"* ]]; then
	dartfmt -w .
	exit_code=$?
elif [[ $1 == "test" ]]; then
	echo "Testing app..."
	flutter -v test --no-color --coverage
	exit_code=$?
	# Generate coverage report
	if command -v "genhtml"; then
		lcov -r coverage/lcov.info '*/__test*__/*' -o coverage/lcov_cleaned.info
		genhtml coverage/lcov_cleaned.info --output=coverage
	fi
elif [[ $1 == "doc" ]]; then
	rmdoc
	exit_code=$?
	if [[ $exit_code -ne 0 ]]; then
		exit $exit_code
	fi
	echo "Generating documentation..."
	dartdoc --show-progress --exclude dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:io,dart:isolate,dart:math,dart:typed_data,dart,dart:ffi,dart:html,dart:js,dart:ui,dart:js_util
	exit_code=$?
elif [[ $1 == "rmdoc" ]]; then
	rmdoc
elif [[ $1 == "publish" ]]; then
	echo "Publishing app..."
	if [[ $2 == "-n" || $2 == "--dry-run" ]]; then
		pub publish --dry-run
		exit_code=$?
	else
		pub publish
		exit_code=$?
	fi
else
	echo "\"$1\" is not a valid command."
	print_help
	exit_code=1
fi

echo $exit_code
exit $exit_code
