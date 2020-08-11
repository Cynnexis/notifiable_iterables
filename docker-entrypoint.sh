#!/bin/bash

function print_help() {
	echo "usage: $0 COMMAND";
	echo ""
	echo "The commands are:"
	echo "  lint     - Check if the Dart syntax of the code is correct."
	echo "  fix-lint - Fix the Dart syntax of the code."
	echo "  test     - Run the tests."
}

if [[ $# == 0 ]]; then
	echo "An argument must be given."
	print_help
	exit 1
fi

exit_code=0

if [[ $1 == "lint" ]]; then
	echo "Checking Dart files format..."
	dartfmt -n --set-exit-if-changed -l 120 .
	exit_code=$?
elif [[ $1 == *"fix"* && $1 == *"lint"* ]]; then
	dartfmt -w -l 120 .
	exit_code=$?
elif [[ $1 == "test" ]]; then
	echo "Testing app..."
	flutter -v test --no-color --coverage test/*_test.dart
	exit_code=$?
elif [[ $1 == "doc" ]]; then
	echo "Generating documentation..."
	dartdocgen --include-private --introduction=README.md .
	exit_code=$?
else
	echo "\"$1\" is not a valid command."
	print_help
	exit_code=1
fi

echo $exit_code
exit $exit_code
