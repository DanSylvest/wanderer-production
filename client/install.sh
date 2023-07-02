echo 'Start installing 6';

REL=$(pwd);

echo '_____________ INITIAL FOLDER STATE _____________'
ls -al
echo '_____________ INITIAL FOLDER STATE _____________'

ROOT="$REL/wanderer-client";
echo "root path $ROOT";

if [ -f "lockfile" ]; then # will exit if all was installed
    echo "Starting..."
    cd "$ROOT" || exit;
    npm run buildDev
    npm run host:ssl
    echo "Started"
    exit 1;
fi

rm -rf ./wanderer-client
git clone https://github.com/DanSylvest/wanderer-client.git;

ls -al

echo 'Create custom client config'
echo "export default {
    app: {
        title: \"Wanderer the mapper\"
    },
    product: {
        version: \"1.0.0\",
        state: \"beta\",
        name: \"wanderer\"
    },
    connection: {
        socket: {
            host: \"${CN_WS_HOST}\",
            proto: \"${CN_WS_PROTO}\",
            port: \"${CN_WS_PORT}\"
        }
    },
    eve: {
        sso: {
            client: {
                response_type: \"code\",
                client_id: \"${EVE_CLIENT_KEY}\", // application Client Id,
                scope: [
                    \"esi-location.read_location.v1\",
                    \"esi-location.read_ship_type.v1\",
                    \"esi-location.read_online.v1\",
                    \"esi-ui.write_waypoint.v1\",
                    \"esi-search.search_structures.v1\",
                ]
            },
            server:  {
                host: \"login.eveonline.com\", // login server
                proto: \"https:\", // protocol
                content_type: \"application/x-www-form-urlencoded\"
            }
        }
    }
}" > "$ROOT/src/conf/main.js";

#echo "module.exports = {
#  eve: {
#    sso: {
#      client: {
#        client_id: \"${EVE_CLIENT_KEY}\"
#      }
#    },
#    connection: {
#      socket: {
#        host: \"${CN_WS_HOST}\",
#        proto: \"${CN_WS_PROTO}\",
#        port: ${CN_WS_PORT}
#      }
#    }
#  }
#}" > "$ROOT/src/conf/custom.js";
#


echo '_____________ CONFIG CLIENT _____________'
ls -al "$ROOT/src/conf"
cat "$ROOT/src/conf/main.js"
echo '_____________ CONFIG CLIENT _____________'

cd "$ROOT" || exit;

echo '_____________ INSTALL NPM DEPS _____________'
npm install
echo '_____________ INSTALL NPM DEPS _____________'

echo "" > "${REL}/lockfile"

echo "Starting..."
npm run buildDev
npm run host:ssl
echo "Started"
