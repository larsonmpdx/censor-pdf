#!/usr/bin/env bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

sudo apt update
sudo apt install -y texlive-extra-utils ghostscript # texlive-extra-utils: for pdfcrop

# https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
echo "install inkscape? (useful to check on files (can view things outside cropped margins, for example)"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            echo "further prompts are for the inkscape ppa etc."
            sudo add-apt-repository universe
            sudo add-apt-repository ppa:inkscape.dev/trunk
            sudo apt update
            sudo apt install -y inkscape-trunk
        break;;
        No ) exit;;
    esac
done
