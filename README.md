# flycheck-smlsharp

Emacs Flychcker for Standard ML with SML# compiler

## Demo

![demo](https://github.com/yonta/flycheck-smlsharp/blob/media/screenshot.gif)

## Requirement

- SML# compiler
- Emacs >= 24.1
- flycheck >= 0.22
- sml-mode

## Install

1. Install SML# compiler.
1. Add flycheck-smlsharp.el file to the directory which is in Emacs load path.
1. Add like adove line to your `init.el`

```elisp
(load "flycheck-smlsharp.el")
```

## Usage

1. Open `.sml` file, and begin sml-mode.
1. After saving your change to file, flycheck with SML# compiler is running.
