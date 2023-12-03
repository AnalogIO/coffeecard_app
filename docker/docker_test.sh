#!/usr/bin/env bash
packagePath=${PACKAGE_PATH:-}
testPath=${TEST_PATH:-}
updateGoldens=${UPDATE_GOLDENS:-}
coverage=${COVERAGE:-}

# 1. If the first argument is --update-goldens, then updateGoldens is set to --update-goldens
# 2. If the first argument is --coverage, then coverage is set to --coverage
# 3. If the first argument is --packagePath, then packagePath is set to the second argument
# 4. If the first argument is --testPath, then testPath is set to the second argument
# 5. If the first argument is not --update-goldens or --coverage, then shift to the next argument
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