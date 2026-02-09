# term-utils

This is a collection of util scripts I add to my terminal configs.

## Install

### Install script

Clone the repository and run the `install` script with

```sh
git clone git@github.com:sebastae/term-utils && cd term-utils && ./install
````

This will:

- Check that you have the required dependencies
- Copy the util file to `$HOME/.term-utils`
- Add `source $HOME/.term-utils` to your rcfile to add the utils to your shell

### Manually

Clone the `utils.sh` file to wherever you want it and source it from your shell config file

## Dependencies

- `fzf`
- `git`
