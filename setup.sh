# Install required packages
npm install -D @tailwindcss/forms@latest @tailwindcss/typography@latest tailwindcss-animate@latest @trivago/prettier-plugin-sort-imports prettier-plugin-tailwindcss@latest prettier@latest
npm install tailwindcss@latest

cat <<EOF > prettier.config.cjs
// https://github.com/trivago/prettier-plugin-sort-imports/issues/117

/** @type {import("prettier").Config} */
const pluginSortImports = require("@trivago/prettier-plugin-sort-imports");

// @ts-ignore
const pluginTailwindcss = require("prettier-plugin-tailwindcss");

/** @type {import("prettier").Parser} */
const myParser = {
  ...pluginSortImports.parsers.typescript,
  parse: pluginTailwindcss.parsers.typescript.parse,
};

/** @type {import("prettier").Plugin} */
const myPlugin = {
  parsers: {
  typescript: myParser,
  },
};

module.exports = {
  trailingComma: "es5",
  tabWidth: 2,
  semi: true,
  singleQuote: false,
  importOrder: [
    "^src/core/(.)$",
    "^@/components/(.)$",
    "^@/containers/(.)$",
    "^@/queries/(.)$",
    "^@/mutations/(.)$",
    "^@/hooks[./]",
    "^@/pages[./]",
    "^@/utils/(.)$",
    "^@/types/(.)$",
    "^@/styles/(.)$",
    "^content/(.)$",
    "^public/(.)$",
    "^[./]"
  ],
  importOrderSeparation: true,
  importOrderSortSpecifiers: true,
  plugins: [myPlugin, pluginTailwindcss],
};
EOF

sed -i '' 's/plugins: \[\]/plugins: [\
    require("@tailwindcss\/forms"),\
    require("@tailwindcss\/typography"),\
    require("tailwindcss-animate")\
]/' tailwind.config.js

sed -i '' 's/"scripts": {/"scripts": {\n\t"format": "prettier --write --ignore-path .gitignore '\''**\/\*.{js,jsx,ts,tsx,json,html,css,md}'\''",/' package.json

npm run format