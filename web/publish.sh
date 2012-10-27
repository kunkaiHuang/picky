#!/bin/bash
bundle exec middleman build --verbose 

echo
echo 'middleman finished'

git checkout gh-pages                # switch to gh-pages branch
git checkout master -- web/build     # checkout just the web/build folder from master
git commit -m "Picky website update" # commit the changes
git push -n                          # 
git checkout master                  # go back to the master branch