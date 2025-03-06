# RLDX.nvim

![Logo](./repo/logo.png)

**Experience an Issue?**
1. Review the [Known Issues](#known-issues) to find a workaround.
2. If the issue is new then create a [Github issue](https://github.com/michhernand/RLDX.nvim/issues).

# 🎷 Features
- Autocomplete for your contact list.
- At-rest obfuscation of contact list.
- Syntax highlighting for contacts.

_Left: Neovim Editor, Right: At-Rest Obfuscated Catalog_
![Demo1](./repo/demo1.gif)

# 🖥️ Usage
## Autocomplete Contact
To trigger autocomplete, simply start a word with your `prefix_char` (defaults to `@`).

## Add to Contact Catalog
To add a new contact to the autocomplete catalog, invoke `:RldxAdd` (deafults to <kbd>X</kbd> <kbd>a</kbd>).

## Reload Contact Catalog
To reload the catalog from its file, invoke `:RldxLoad` (defaults to <kbd>X</kbd> <kbd>l</kbd>).

# 📎 Requirements
- Tested on Neovim 0.10.0.
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

# 💾 Installation
1. Add to your Neovim package manager's configuration. See specific steps below.
2. Update your cmp-nvim configuration.
3. [Optional] Update your cmp-nvim `formatting` configuration.

## Package Managers
### Lazy
```lua
{
    "michhernand/RLDX.nvim",
    event = "VeryLazy",
    dependencies = {
        "hrsh7th/nvim-cmp",
    },
    opts = {}, -- see configuration docs for details
    keys = {
        { "<leader>Xa", "<cmd>RldxAdd<CR>" },
        { "<leader>Xl", "<cmd>RldxLoad<CR>" },
    }
}
```

### Packer
```lua
use {
    "michhernand/RLDX.nvim", 
    requires = { "hrsh7th/nvim-cmp" },
    config = function()
        require("rldx").setup{} -- see configuration docs for details
    end,
        setup = function()
        vim.keymap.set("n", "<leader>Xa", "<cmd>RldxAdd<CR>", { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>Xl", "<cmd>RldxLoad<CR>", { noremap = true, silent = true })
    end
}
```

## Completions Engine Configuration
### nvim-cmp
#### [Required] Core Configuration
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


#### [Optional] Formatting
An optional feature is to add formatting for nvim-cmp to display the type and source of the completion.

_A completion without formatting applied._

![Completion Without Formatting](./repo/Completion_Without_Formatting.png)

_A completion with formatting applied._

![Completion With Formatting](./repo/Completion_With_Formatting.png)

This is enabled by setting `formatting` in the `config` function for `hrsh7th/nvim-cmp`.
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

For more details on formatting setup, see the [Formatting Doc](./docs/formatting.org).

# ⚙️ Configuration
## Default Configuration
```lua
opts = {
    prefix_char = "@",
    filename = os.getenv("HOME") .. "/.rolodex/db.json"),
    highlight_enabled = true,
    highlight_color = "00ffff",
    highlight_bold = true,
    schema_ver = "latest",
    encryption = "plaintext",
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

## Schema Version
`schema_ver` (str) tells RLDX what version of the schmea to use when writing out data. Options include '0.0.2', '0.1.0', or '0.2.0'. 'latest' (which is the default) is also an option which automatically upgrades your catalog to the latest schema.

## Obfuscation
### Encryption
- `encryption` (str) is the chosen encryption methodology. Options include:
    - `plaintext`: No encryption of fields.
    - `elementwise_xor` (only available for `schema_ver >= '0.1.0'`): xor encryption of each contact.
### Hash Salt Length
`hash_salt_length` (str) is the number of random salt characters added to the hash.

For more information about Obfuscation, see the [Obfuscation Doc](./docs/obfuscation.org)

# 🖋️ Usage
## Autocompleting and Storing Contacts
_Left: Neovim Editor, Right: At-Rest Plaintext Catalog_
![Demo for Adding Contacts](./repo/demo2.gif)

## 🔒 Obfuscation
RLDX optionally provides obfuscation of data at rest. RLDX and its maintainers make no guarantees around security. For a full breakdown of obfuscation, see the [Obfuscation Doc](./docs/obfuscation.org).

_Left: Neovim Editor, Right: At-Rest Obfuscated Catalog_
![Demo for Obfuscation](./repo/demo3.gif)

### What Is Obfuscation?
- In `schema_ver` >= 0.1.0, RLDX provides:
    - **Very** light encryption of names.
    - Hashing of names to guarantee uniqueness.
- To enable obfuscation, see the instructions in [Obfusfaction Doc](./docs/obfuscation.org)

# 🚘 Roadmap
- [X] ~~Obfuscation~~
- [X] ~~Salt for Hashing~~
- [X] ~~Form for adding contacts~~
- [ ] Allow saving all contacts
- [X] Allow loading all contacts
- [ ] Allow deleting contacts
- [ ] Allow updating contacts
- [ ] Allow showing of contact details
- [ ] Blink.nvim compatability
- [ ] Grep files by contact name

# 🦗 Known Issues
## [RESOLVED in v0.1.0] Shows duplicate autocomplete recommendations.
This appears to happen when you add contacts and then query them in the same session. A workaround is to exit and re-launch Neovim.
## [RESOLVED in v0.1.0] Highlighting does not initialize on lazy loading.
This appears to happen when lazy loading with Lazy.nvim. A workaround is to set `lazy = false` in opts.
- Only highlighting is affected here. Other functionality is unaffected.
## Highlighting does not intiialize some org-roam files.
This appears to happen when a new org-roam file is created via org-roam-capture. This resolves when Neovim is restarted.
- Only highlighting is affected here. Other functionality is unaffected.

# 🏆 Acknowledgements
- md5.lua is provided by [md5](https://github.com/kikito/md5.lua) (by [kikito](https://github.com/kikito))
- xor.lua is provided by [xor](https://github.com/Braayy/xor-lua) (by [Braayy](https://github.com/Braayy/xor-lua))
