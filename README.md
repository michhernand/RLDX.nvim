# rolodex.nvim

![Logo](./repo/logo.png)

# Features
- Autocomplete for your contact list.
- Syntax highlighting for contacts.
![Demo1](./repo/demo1.gif)

# Requirements
- Tested on Neovim 0.10.0.
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

# Installation
1. Add to your Neovim package manager's configuration. See specific steps below.
2. Update your cmp-nvim configuration.

nvim-cmp configuration for all file types.
```lua
local my_sources = {
    -- your other sources
    { name = "cmp_rolodex"},
}

local cmp = require("cmp")
cmp.setup({
    sources = cmp.config.sources(my_sources),
})
```

nvim-cmp configuration for select file types.
```lua
local my_sources = {
    -- your other sources
    { name = "cmp_rolodex"},
}

local cmp = require("cmp")
cmp.setup({
    sources = cmp.config.sources(my_sources),
    cmp.setup.filetype({ "org", "md" }, {
        sources = cmp.config.sources(my_sources)
    })
})
```

## Package Managers
### Lazy
lazy configuration for all file types.
```lua
{
    "github.com/michhernand/rolodex.nvim",
    lazy = true,
    opts = {} -- see configuration docs for details
}
```

### Other Package Managers Coming Soon
...

# Configuration
## Default Configuration
```lua
opts = {
    prefix_char = "@",
    db_filename = os.getenv("HOME") .. "/.rolodex/db.json"),
    highlight_enabled = true,
    highlight_color = "00ffff",
    highlight_bold = true
}
```

## Prefix Char
`prefix_char` (str) is the character that triggers autocomplete.

## DB Filename
`db_filename` (str) is the location where your contacts are stored.

## Highlighting
### Highlight Enabled
`highlight_enabled` (bool) is a flag indicating whether highlighting of names is enabled.

### Highlight Color
`highlight_color` (str) is a hex color code indicating what color names should be highlighted as.

### Highlight Bold
`highlight_bold` (bool) is a flag indicating whether highlighted names should be bolded.

# Usage
## Autocomplete
![Demo for Autocomplete](./repo/demo3.gif)
## Adding Names
![Demo for Adding Names](./repo/demo2.gif)

# Roadmap
- [ ] Delete contacts.
- [ ] Update contacts.
- [ ] Grep files by contact name.

# Known Issues
## Shows duplicate autocomplete recommendations.
This appears to happen when you add contacts and then query them in the same session. A workaround is to exit and re-launch Neovim.
## Highlighting does not initialize on lazy loading.
This appears to happen when lazy loading with Lazy.nvim. A workaround is to set `lazy = false` in opts.
