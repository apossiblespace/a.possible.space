#!/usr/bin/env bash
set -o nounset
set -o errexit

bold=$(tput bold)
normal=$(tput sgr0)

echo "    _     ____               _ _     _       ____                       "
echo "   / \   |  _ \ ___  ___ ___(_) |__ | | ___ / ___| _ __   __ _  ___ ___ "
echo "  / _ \  | |_) / _ \/ __/ __| | '_ \| |/ _ \\___ \| '_ \ / _  |/ __/ _ \ "
echo " / ___ \ |  __/ (_) \__ \__ \ | |_) | |  __/ ___) | |_) | (_| | (_|  __/"
echo "/_/   \_\|_|   \___/|___/___/_|_.__/|_|\___||____/| .__/ \__,_|\___\___|"
echo "                                                  |_|                   "

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

echo "${bold}👀 Preparing...${normal}"
DIR="$( cd "$( dirname $( dirname "$0" ) )" && pwd)"
source "$DIR/.env"

echo ""
echo "${bold}🛠 Building static site...${normal}"
bundle exec jekyll build

echo ""
echo "${bold}🚚 Deploying to server...${normal}"
chmod -R og+Xr ${DIR}/_site
echo "→ Deploying ${DIR}/_site to ${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:aps.web"
rsync $NFLAG -rvzp --delete --exclude-from="$DIR/.deployignore" "${DIR}/_site/" "${DEPLOY_ACCOUNT}@${DEPLOY_SERVER}:aps.web"

echo ""
echo "${bold}🎉 Done!${normal}"
