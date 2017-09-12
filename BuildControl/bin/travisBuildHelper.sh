#!/bin/bash

set -o pipefail

if [[ $# != 2 ]]; then
	echo "error: Expecting 2 arguments; <operation> <platform>"
	exit 1
fi

OPERATION="$1"
PLATFORM="$2"

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd "$PWD" ; cd `dirname "$0"` ; echo "$PWD")

source "${SCRIPT_DIR}/include-common.sh"

case $OPERATION in
	build)
		MAXIMUM_TRIES=1
		XCODE_ACTION="clean build";;

	test)
		MAXIMUM_TRIES=3
		XCODE_ACTION="test";;

	*)
		echo "error: Unknown operation: $OPERATION"
		exit 1;;
esac

DESTINATION=$(runDestinationForPlatform $PLATFORM)

#
# this retry loop is an unfortunate hack; Travis unit tests periodically fail
# without explanation with an exit code of 65. Sometimes this is just a temporary
# glitch and re-trying will succeed. We retry a few times if we keep hitting 65
# to avoid the temporary error. If it fails enough times, we assume it's a 'real'
# failure
#
THIS_TRY=0
while [[ $THIS_TRY < $MAXIMUM_TRIES ]]; do
	THIS_TRY=$(( $THIS_TRY + 1 ))
	if [[ $MAXIMUM_TRIES > 1 ]]; then
		echo "Attempt $THIS_TRY of $MAXIMUM_TRIES..."
	fi

	( set -o pipefail && xcodebuild -project RaptureXML.xcodeproj -configuration Debug -scheme "RaptureXML" -destination "$DESTINATION" -destination-timeout 300 $XCODE_ACTION 2>&1 | tee "RaptureXML-$PLATFORM-$OPERATION.log" | xcpretty )
	XCODE_RESULT="${PIPESTATUS[0]}"
	if [[ "$XCODE_RESULT" == "0" ]]; then
		rm "RaptureXML-$PLATFORM-$OPERATION.log"
		exit 0
	elif [[ "$XCODE_RESULT" != "65" ]]; then
		echo "Failed with exit code $XCODE_RESULT."
		exit $XCODE_RESULT
	elif [[ $MAXIMUM_TRIES > 1 && $THIS_TRY < $MAXIMUM_TRIES ]]; then
		echo "Failed with exit code 65. This may be a transient error; trying again."
		echo
	fi
done

exit $XCODE_RESULT
