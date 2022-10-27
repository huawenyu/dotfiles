# [Plug-startscreen.vim] config: ~/dotfiles/startpage.md
- Vim:
  - ~/.vimrc        # config-file, and the plugins dir: ~/.vim/bundle
  - howto           # Check ~/.vimrc
  - update          # wget --no-check-certificate -O ~/.vimrc  https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
  - vim --clean     # Startup vim without any config/plug
  - <Space>         # Remap-As <leader>
  - Press ';;'      # Top-outline of shortcuts, search 'silent! Shortcut!' in ~/.vim/bundle
  - Press 'H'       # on topic word with the '?' sign (by cheat?)

- Tool:
  - zsh/fish		# Better shell
  - tmux/alacritty	# Better terminal
  - geany			# Simple editor: sudo apt install geany geany-plugins
  - tig				# Terminal GUI of git
  - pee				# Tee standard input to pipes
  - ts				# Timestamp standard input
  - grc				# Colorize grep/pipe
  - direnv          # Environment auto setup: python-venv

- find:
  - ripgrep			# Better grep
  - batcat			# Better cat, used vim-fzf: sudo apt install bat
  - fuzzy/fzf		# Fuzzy filter

- Man:
  - tldr			# Better man: pip3 install tldr
  - cheat			# Command helper: ~/wiki/cheat

- Misc:
  - graph-easy		# Ascii-text base dot-graph
  - taskwarrior		# Tasklist
  - tshark tcpdump	# Network sniffer

# vim: noai:ts=4:sw=4:ft=yaml:
