#!/bin/bash

# Exit on error
set -e

echo "Building Flutter Web..."
/Users/hosamabdelraouf/Developer/flutter/bin/flutter build web --base-href "/koll/" --no-tree-shake-icons

echo "Deploying to GitHub Pages..."

# Navigate to build directory
cd build/web

# Initialize a temporary git repo
git init
git remote add origin https://github.com/HosamRaouf/koll.git
git add .
git commit -m "Deploy to GitHub Pages"

# Force push to the gh-pages branch
echo "Pushing to GitHub..."
git push -f origin HEAD:gh-pages

echo "Successfully deployed! Your app will be live at: https://HosamRaouf.github.io/koll/"
