#!/bin/bash
set -e

echo "Cleaning old git history..."
rm -rf .git

echo "Initializing new git repository..."
git init

echo "Adding files..."
git add .

echo "Committing..."
git commit -m "Initial commit (Clean code & Documentation)"

echo "Setting branch to main..."
git branch -M main

echo "Adding remote..."
git remote add origin https://github.com/HosamRaouf/koll.git

echo "Pushing to remote..."
git push -u -f origin main

echo "Repository securely re-uploaded!"
