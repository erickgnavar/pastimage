# Pastimage

Insert images links from clipboard, it has support for `org-mode`, `markdown-mode` and `rts-mode`.

For now it only works on `macOS`, but support for other systems is comming.

## Installation

### Cloning the repo

Clone this repo somewhere, and add this to your config:

```emacs-lisp
(add-to-list 'load-path "path where the repo was cloned")

(require 'pastimage)
```

## Usage

Copy some image into clipboard and then execute:

```emacs-lisp
M-x pastimage-insert-from-clipboard
```
