# Bluesight API Platform Docs

[![Build, push to registry and deploy](https://github.com/bluesightai/docs/actions/workflows/build-and-deploy.yml/badge.svg)](https://github.com/bluesightai/docs/actions/workflows/build-and-deploy.yml)

This is docs for the [Bluesight API platform](https://github.com/bluesightai/platform).

## Development

Build Jupyter Notebooks to `.mdx` automatically via

```
./build-ipynb.sh
```

Install the [Mintlify CLI](https://www.npmjs.com/package/mintlify) to preview the documentation changes locally. To install, use the following command

```
npm i -g mintlify
```

Run the following command at the root of your documentation (where mint.json is)

```
mintlify dev
```
