# RLDX.nvim

![Logo](./repo/logo.png)

**Experience an Issue?**
1. Review the [Known Issues](#known-issues) to find a workaround.
2. If the issue is new then create a [Github issue](https://github.com/michhernand/RLDX.nvim/issues).

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
require('cmp').setup({
    sources = {
        { name = 'cmp_rolodex' }
    }
})
```

nvim-cmp configuration for select file types.
```lua
require('cmp').setup.filetype('org', {
    sources = {
        { name = 'cmp_rolodex' }
    },
 })

```

## Package Managers
### Lazy
lazy configuration for all file types.
```lua
{
    "michhernand/RLDX.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    opts = {} -- see configuration docs for details
}
```

lazy configuration for select file types.
```lua
{
    "michhernand/RLDX.nvim",
    lazy = true,
    event = {
        "BufReadPost *.org", "BufNewFile *.org",
        "BufReadPost *.md", "BufNewFile *.md",
    },
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
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
    filename = os.getenv("HOME") .. "/.rolodex/db.json"),
    highlight_enabled = true,
    highlight_color = "00ffff",
    highlight_bold = true,
    encryption = "elementwise_xor",
}
```

## Prefix Char
`prefix_char` (str) is the character that triggers autocomplete.

## DB Filename
`filename` (str) is the location where your contacts are stored.

## Highlighting
### Highlight Enabled
`highlight_enabled` (bool) is a flag indicating whether highlighting of names is enabled.

### Highlight Color
`highlight_color` (str) is a hex color code indicating what color names should be highlighted as.

### Highlight Bold
`highlight_bold` (bool) is a flag indicating whether highlighted names should be bolded.

## encryption
`encryption` (str) is the chosen encryption methodology. Options include:
- `plaintext`: No encryption of fields.
- `elementwise_xor`: xor encryption of each contact.

## [Optional] Formatting for nvim-cmp
An optional feature is to add formatting for nvim-cmp to display the type and source of the completion.

```lua
-- nvim-cmp.lua

return {
    "hrsh7th/nvim-cmp",
    config = function()
        formatting = {
            format = function(entry, vim_item)
                if entry.source.name = "cmp_rolodex" then
                    vim_item.kind = "📇 Contact"
                    vim_item.menu = "[RLDX]"
                end
                return vim_item
            end
        }
    end
}
```

You may already have `formatting` configured. Possibly like...
```lua
return {
    "hrsh7th/nvim-cmp",
    config = function()
        formatting = {
            format = lspkind.cmp_format({
            maxwidth = 50,
                ellipsis_char = "...",
            }),
        }
    end
}
```

In such a case, you can merge your `formatting` with the RLDX `formatting`.
```lua
return {
    "hrsh7th/nvim-cmp",
    config = function()
	formatting = {
		format = function(entry, vim_item)
            -- Existing configuration
		    local format_func = lspkind.cmp_format({
				maxwidth = 50,
				ellipsis_char = "...",
			})
			vim_item = format_func(entry, vim_item)

            -- RLDX configuration
			if entry.source.name == "cmp_rolodex" then
				vim_item.kind = "📇 Contact"
				vim_item.menu = "[RLDX]"
			end

			return vim_item
		end
	}
    end
}
```

# Usage
## Autocomplete
![Demo for Autocomplete](./repo/demo3.gif)
## Adding Contacts
![Demo for Adding Contacts](./repo/demo2.gif)

# Roadmap
- [ ] Encryption
- [ ] Delete contacts.
- [ ] Update contacts.
- [ ] Blink.nvim compatability.
- [ ] Grep files by contact name.

# Known Issues
## Shows duplicate autocomplete recommendations.
This appears to happen when you add contacts and then query them in the same session. A workaround is to exit and re-launch Neovim.
## Highlighting does not initialize on lazy loading.
This appears to happen when lazy loading with Lazy.nvim. A workaround is to set `lazy = false` in opts.
- Only highlighting is affected here. Other functionality is unaffected.
## Highlighting does not intiialize some org-roam files.
This appears to happen when a new org-roam file is created via org-roam-capture. This resolves when Neovim is restarted.
- Only highlighting is affected here. Other functionality is unaffected.

# Acknowledgements
- md5.lua is provided by [md5](https://github.com/kikito/md5.lua)
