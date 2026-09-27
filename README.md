# flycheck-smlsharp

Emacs Flycheck checker for Standard ML with SML# compiler

## Demo

![demo](https://github.com/yonta/flycheck-smlsharp/blob/media/screenshot2.gif)

## Requirement

- SML# compiler >= 3.4.0
- Emacs >= 28.1
- flycheck >= 32
- sml-mode

## Install

1. Install SML# compiler.
1. Install this package, and call `flycheck-smlsharp-setup` after flycheck is
   loaded.

- with package-vc (Emacs >= 29),

```elisp
(package-vc-install "https://github.com/yonta/flycheck-smlsharp.git")
(with-eval-after-load 'flycheck
  (flycheck-smlsharp-setup))
```

- with use-package (Emacs >= 30),

```elisp
(use-package flycheck-smlsharp
  :vc (:url "https://github.com/yonta/flycheck-smlsharp.git")
  :after flycheck
  :config (flycheck-smlsharp-setup))
```

- with leaf.el,

```elisp
(leaf flycheck-smlsharp
  :vc (:url "https://github.com/yonta/flycheck-smlsharp.git")
  :after flycheck
  :config (flycheck-smlsharp-setup))
```

## Usage

1. Open `.sml` file, and begin sml-mode.
1. After saving your change to file, flycheck with SML# compiler is running.

## Limitation

- You always need interface file (.smi) for this checker, even if you will use
  REPL of SML# compiler.
- This checker does not check interactively, it checks only when source file
  is saved. Because temporary source file which is made by interactive flycheck
  can not have interface file now.
