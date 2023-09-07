<div align="center">

# asdf-eza ![Build](https://github.com/jc00ke/asdf-eza/workflows/Build/badge.svg) ![Lint](https://github.com/jc00ke/asdf-eza/workflows/Lint/badge.svg)

[eza](https://github.com/eza-community/eza) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `unzip`.

# Install

Plugin:

```shell
asdf plugin add eza
# or
asdf plugin add eza https://github.com/jc00ke/asdf-eza.git
```

eza:

```shell
# Show all installable versions
asdf list-all eza

# Install specific version
asdf install eza latest

# Set a version globally (on your ~/.tool-versions file)
asdf global eza latest

# Now eza commands are available
eza --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jc00ke/asdf-eza/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Siegfried Ehret](https://github.com/SiegfriedEhret/)
