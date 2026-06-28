require("git"):setup()

require("mime-ext.local"):setup({
  with_files = {
    makefile   = "text/x-makefile",
    dockerfile = "text/x-dockerfile",
  },
})
