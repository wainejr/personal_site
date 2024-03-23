# Personal site

This is my personal site, it is hosted at http://www.wainejr.com.

It uses [Hugo](https://gohugo.io) and the theme [Hugo-Coder](https://github.com/luizdepra/hugo-coder) by [Luiz de Prá](https://github.com/luizdepra).
For more informations about serving locally this site, check the docs from Hugo and Hugo-Coder. (run `hugo serve`)

Any suggestion you can leave at the issues here in GitHub.

## Submodules

To run locally, you must clone as well the submodule. For doing this you can run 

```bash
git clone --recursive https://github.com/jrwaine/personal_site.git
# or
git clone https://github.com/jrwaine/personal_site.git
cd personal_site
git submodule update --init --recursive
```

## Commands

Serve locally

```bash
hugo serve
```

Build site

```bash
hugo
```
