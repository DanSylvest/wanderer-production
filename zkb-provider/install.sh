echo 'Start installing zkb-kills-provider';

REL=$(pwd);
ROOT="$REL/zkb-kills-provider";

if [ "$UPDATE" = "true" ]; then
    echo 'UPDATE zkb kills provider';
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

rm -rf ./zkb-kills-provider
git clone https://github.com/DanSylvest/zkb-kills-provider.git;

echo '_____________ INITIAL FOLDER STATE _____________'
ls -al
echo '_____________ INITIAL FOLDER STATE _____________'

cd "$ROOT" || exit;

echo '_____________ BUILDER INSTALL NPM START _____________'
npm install;
echo '_____________ BUILDER INSTALL NPM FINISH _____________'


echo '_____________ BUILDER build NPM FINISH _____________'
npm run build

echo "" > "${REL}/lockfile"

npm run exec