#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export DEBEMAIL="frederik.carlier@quamotion.mobi"
export DEBFULLNAME="Frederik Carlier"

git config --global user.name "$DEBFULLNAME"
git config --global user.email "$DEBEMAIL"

dch -v "1.1.1.$TRAVIS_BUILD_NUMBER-0$1" --distribution $1 "Travis CI Build"
git add debian/changelog
git commit -m "Travis CI Build"

git clean -xfd

git archive --format tar.gz -o ../usbmuxd_1.1.1.${TRAVIS_BUILD_NUMBER}.orig.tar.gz HEAD

echo allow-loopback-pinentry > ~/.gnupg/gpg-agent.conf
gpg --allow-secret-key-import --import ppa.asc
killall gpg-agent
echo "${GPG_PASSPHRASE}" >> /tmp/gpg_passphrase
debuild -S -kFBA0ACB4 -p"$DIR/gpg-pass.sh /tmp/gpg_passphrase"
rm -rf /tmp/gpg_passphrase

dput ppa:quamotion/ppa ../usbmuxd_1.1.1.${TRAVIS_BUILD_NUMBER}-0$1_source.changes

