echo 'Start installing route-builder';

REL=$(pwd);
ROOT="$REL/eve-route-builder";

if [ "$UPDATE" = "true" ]; then
    echo 'UPDATE eve route builder';
    rm -rf "${REL}/lockfile"
fi

if [ -f "${REL}/lockfile" ]; then # will exit if all was installed
    echo "Starting..."
    cd "$ROOT" || exit;
    npm run exec
    echo "Started"
    exit 1;
fi

echo 'Install nestjs'
npm i -g @nestjs/cli

echo 'Start installing';

rm -rf ./eve-route-builder
git clone https://github.com/DanSylvest/eve-route-builder.git;

echo '_____________ INITIAL FOLDER STATE _____________'
ls -al
echo '_____________ INITIAL FOLDER STATE _____________'

echo "Download latest eve systems and routes";
if [ ! -d "$ROOT/eveData" ]; then
  mkdir -p "$ROOT/eveData";
fi


cd "$ROOT/eveData" || exit;
rm -f *

latestURLSystems='https://www.fuzzwork.co.uk/dump/latest/mapSolarSystems.csv';
latestURLJumps='https://www.fuzzwork.co.uk/dump/latest/mapSolarSystemJumps.csv';

echo '_____________ Download Systems _____________'
curl -O "${latestURLSystems}";
echo '_____________ Download Jumps _____________'
curl -O "${latestURLJumps}";

echo " _____________ DUMP ----------------"
ls -al
echo " _____________ DUMP ----------------"

cd "$ROOT" || exit;

echo '_____________ BUILDER INSTALL NPM START _____________'
npm install;
echo '_____________ BUILDER INSTALL NPM FINISH _____________'

echo '_____________ INSTALL NPM FINISH _____________'
npm run build

echo "" > "${REL}/lockfile"

npm run exec