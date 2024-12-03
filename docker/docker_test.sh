#!/usr/bin/env bash
packagePath=${PACKAGE_PATH:-}
testPath=${TEST_PATH:-}
updateGoldens=${UPDATE_GOLDENS:-}
coverage=${COVERAGE:-}

while [ $# -gt 0 ]; do
   if [ "$1" == "--update-goldens" ]; then
        declare= updateGoldens="--update-goldens"
        shift
   elif [ "$1" == "--coverage" ]; then
        declare= coverage="--coverage"
        shift
   elif [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        shift
        shift
   else
        shift
   fi
done

cd $packagePath
flutter test $testPath $updateGoldens $coverage --no-pub --test-randomize-ordering-seed random
exit 