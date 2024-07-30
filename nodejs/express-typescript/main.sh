#!/bin/bash

echo "Select Node.js version [default: 20.16]:"
read NODE_VERSION
NODE_VERSION=${NODE_VERSION:-20.16}

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
    echo "Choose mode for yarn berry:"
    echo "1. pnp"
    echo "2. zero install"
    read YARN_BERRY_MODE
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
mkdir my-express-ts-app
cd my-express-ts-app

echo "Initializing project..."
if [ "$PM" = "pnpm" ]; then
  pnpm init -y
elif [ "$PM" = "yarn" ]; then
  yarn init -y
elif [ "$PM" = "yarn berry" ]; then
  yarn set version berry
  yarn init -y
  if [ "$YARN_BERRY_MODE" = "1" ]; then
    yarn config set nodeLinker pnp
  elif [ "$YARN_BERRY_MODE" = "2" ]; then
    yarn plugin import workspace-tools
    touch .yarnrc.yml
    echo "enableGlobalCache: true" >> .yarnrc.yml
  fi
else
  npm init -y
fi

echo "Installing dependencies..."
if [ "$PM" = "pnpm" ]; then
  pnpm add express
  pnpm add -D typescript @types/node @types/express ts-node-dev eslint prettier eslint-config-prettier eslint-plugin-prettier
elif [ "$PM" = "yarn" ] || [ "$PM" = "yarn berry" ]; then
  yarn add express
  yarn add -D typescript @types/node @types/express ts-node-dev eslint prettier eslint-config-prettier eslint-plugin-prettier
else
  npm install express
  npm install --save-dev typescript @types/node @types/express ts-node-dev eslint prettier eslint-config-prettier eslint-plugin-prettier
fi

echo "Setting up TypeScript..."
mkdir src
touch src/index.ts
npx tsc --init --rootDir src --outDir dist --esModuleInterop --resolveJsonModule --lib ES6 --module commonjs

cat <<EOL > src/index.ts
import express, { Request, Response } from 'express';

const app = express();
const port = 3000;

app.get('/', (req: Request, res: Response) => {
  res.send('Hello, TypeScript with Express!');
});

app.listen(port, () => {
  console.log(\`Server is running at http://localhost:\${port}\`);
});
EOL

echo "Setting up ESLint..."
cat <<EOL > .eslintrc.json
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "plugin:@typescript-eslint/recommended",
    "prettier"
  ],
  "plugins": ["@typescript-eslint", "prettier"],
  "rules": {
    "prettier/prettier": "error"
  },
  "env": {
    "node": true,
    "es6": true
  }
}
EOL

echo "Setting up Prettier..."
cat <<EOL > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 80
}
EOL

echo "Adding start script..."
if [ "$PM" = "pnpm" ]; then
  pnpm set-script start "ts-node-dev src/index.ts"
elif [ "$PM" = "yarn" ] || [ "$PM" = "yarn berry" ]; then
  yarn add ts-node-dev
  yarn set-script start "ts-node-dev src/index.ts"
else
  npm set-script start "ts-node-dev src/index.ts"
fi

echo "Project setup complete!"

