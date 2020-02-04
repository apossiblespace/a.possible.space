#!/usr/bin/env bash
set -o nounset
set -o errexit

NFLAG=""

while getopts ":n" opt; do
    case $opt in
        n)
            NFLAG="-n"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

echo "👀 Preparing..."
DIR="$( cd "$( dirname $( dirname "$0" ) )" && pwd)"
source "$DIR/.env"

echo ""
echo "🛠 Building static site..."
bundle exec jekyll build

echo ""
echo "🚚 Deploying to server..."
chmod -R og+Xr ${DIR}/_site
echo "→ Deploying ${DIR}/_site to ${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:aps.web"
rsync $NFLAG -rvzp --delete --exclude-from="$DIR/.deployignore" "${DIR}/_site/" "${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:aps.web"

echo ""
echo "🎉 Done!"
