# flycheck-smlsharp

Emacs Flychcker for Standard ML with SML# compiler

## Demo

![demo](https://github.com/yonta/flycheck-smlsharp/blob/media/screenshot2.gif)

## Requirement

- SML# compiler >= 3.4.0
- Emacs >= 24.1
- flycheck >= 0.22
- sml-mode >= 0.4

## Install

1. Install SML# compiler.
1. Add flycheck-smlsharp.el file to the directory which is in Emacs load path.
1. Add a line like adove to your `init.el`.

```elisp
(eval-after-load 'sml-mode
  '(progn
    (require 'flycheck-smlsharp)))
```

- with leaf.el,

``` elisp
(leaf flycheck-smlsharp
  :el-get (flycheck-smlsharp
           :url "https://github.com/yonta/flycheck-smlsharp.git")
  :after sml-mode
  :require t)
```

## Usage

1. Open `.sml` file, and begin sml-mode.
1. After saving your change to file, flycheck with SML# compiler is running.

## Limitation

- You always need interface file (.smi) for this checker, even if you will use
  REPL of SML# compiler.
- This checker do not checks intaractively, it checks only when source file is
  saved. Because temporary source file which is made by intaractive flycheck
  can not have interface file now.
