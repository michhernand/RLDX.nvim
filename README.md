# rolodex.nvim

![Logo](./repo/logo.png)

## Features
- Autocomplete for your contact list.
- Syntax highlighting for contacts.
![Demo1](./repo/demo1.gif)

## Requirements
- Tested on Neovim 0.10.0.
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Installation
1. Add to your Neovim package manager's configuration. See specific steps below.
2. Update your cmp-nvim configuration.
```lua
return {
    "hrsh7th/nvim-cmp",

    local my_sources = {
        -- your other sources
        { name = "cmp_rolodex"},
    }

    sources = cmp.config.sources(my_sources),
}
```

### Package Managers
#### Lazy
```lua
return {
    "github.com/michhernand/rolodex.nvim",
    lazy = true,
    opts = {}
}
```

## Configuration

## Usage
