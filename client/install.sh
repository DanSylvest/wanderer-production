REL=$(pwd);
ROOT="$REL/wanderer-client";
echo "root path $ROOT";

inject() {
  INDEX_HTML="$ROOT/public/index.html"

  echo "INJECTED files - "
  echo "$INDEX_HTML"

  # Проходим по всем файлам с шаблоном *_head.*
  for file in $REL/injections/*_head.*; do
      # Проверяем, что это действительно файл, а не директория или другой объект
      if [ -f "$file" ]; then
          # Вставляем содержимое файла перед закрывающим тегом </head>
          while IFS= read -r line; do
              sed -i "/<\/head>/i $line" $INDEX_HTML
          done < "$file"
      fi
  done

  cat $INDEX_HTML
  echo "END INJECTED files -"
}

run () {
    echo "Starting..."
    npm run buildDev
    npm run host:ssl
    echo "Started"
}

create_config () {
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
}



echo '_____________ INITIAL FOLDER STATE _____________'
ls -al
echo '_____________ INITIAL FOLDER STATE _____________'

if [ "$UPDATE" = "true" ]; then
    echo 'UPDATE';
    rm -rf "${REL}/lockfile"
fi

if [ -f "${REL}/lockfile" ]; then # will exit if all was installed
    cd "$ROOT" || exit;
    run;
    exit 1;
fi

echo 'Start installing';

rm -rf ./wanderer-client
git clone https://github.com/DanSylvest/wanderer-client.git;

ls -al

inject
create_config

echo '_____________ CONFIG CLIENT _____________'
ls -al "$ROOT/src/conf"
cat "$ROOT/src/conf/main.js"
echo '_____________ CONFIG CLIENT _____________'

cd "$ROOT" || exit;

echo '_____________ INSTALL NPM DEPS _____________'
npm install
echo '_____________ INSTALL NPM DEPS _____________'

echo "" > "${REL}/lockfile"

run;
