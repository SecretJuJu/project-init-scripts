#!/bin/bash

echo "Select Node.js version [default: 20.16]:"
read NODE_VERSION
NODE_VERSION=${NODE_VERSION:-20.16}

echo "Enter project name:"
read PROJECT_NAME

echo "Select your package manager:"
echo "1. pnpm"
echo "2. yarn"
echo "3. yarn berry (v4)"
echo "4. npm"
read PM_CHOICE

case $PM_CHOICE in
  1)
    PM="pnpm"
    ;;
  2)
    PM="yarn"
    ;;
  3)
    PM="yarn berry"
    echo "Is this project using pnp ? (y, n)"
    read IS_PNP
    ;;
  4)
    PM="npm"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

echo "Creating project directory..."
mkdir $PROJECT_NAME
cd $PROJECT_NAME

PACAKGES="express"
DEV_PACKAGES="typescript ts-node prettier eslint-plugin-prettier eslint-config-prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin @types/express @types/node eslint @eslint/js typescript-eslint globals"

# package.json 생성
if [ "$PM" == "pnpm" ]; then
  pnpm init
  pnpm add $PACAKGES
  pnpm add -D $DEV_PACKAGES
elif [ "$PM" == "yarn" ]; then
  yarn init
  yarn add $PACAKGES
  yarn add -D $DEV_PACKAGES
elif [ "$PM" == "yarn berry" ]; then
  yarn set version berry
  yarn init
  # .yarnrc.yml 생성
  echo "nodeLinker: pnp" > .yarnrc.yml
  echo "enableGlobalCache: false" >> .yarnrc.yml
  yarn add $PACAKGES
  yarn add -D $DEV_PACKAGES
else
  npm init
  npm install $PACAKGES
  npm install -D $DEV_PACKAGES
fi

# .gitignore 생성
cp "$(dirname "$0")"/gitignore.txt .gitignore

# eslintrc 생성
cp "$(dirname "$0")"/eslint.config.mjs eslint.config.mjs

# prettierrc 생성
cp "$(dirname "$0")"/prettierrc .prettierrc

# tsconfig 생성
cp "$(dirname "$0")"/tsconfig.json tsconfig.json
cp "$(dirname "$0")"/tsconfig.build.json tsconfig.build.json

