"""Qutebrowser configuration"""
# * Pylint
# prevent pylint warnings and fix completion for c/config
# line too long
# pylint: disable = C0301
# E501 - line too long
# F401 - module imported but unused
# F821 - undefined name
# E0602 - undefined variable
# C0103 - invalid constant name
import os
import re
import sys
import setproctitle
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401,E501 pylint: disable=unused-import
from qutebrowser.config.config import ConfigContainer  # noqa: F401,E501 pylint: disable=unused-import
config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103
setproctitle.setproctitle("qutebrowser")

# * Notes
# ** Probably Will Be Useful
# - click-element
# - ;; for command chaining
# - content.user_stylesheets

# ** TODO Add/Look Into
# HiDPI:
#   - scrollbar is massive with QT_AUTO_SCREEN_SCALE_FACTOR=1
#   - the default zoom is often delayed for a bit
# - difference between url and url:pretty/pretty-url
# - make sanitize command ('history-clear ;; download-clear'; TODO
#   clear-cookies)
# - password management
#   https://github.com/qutebrowser/qutebrowser/issues/180
#   https://github.com/qutebrowser/qutebrowser/issues/3350
# - require permissions per page to use flash
# - spell checking (https://github.com/qutebrowser/qutebrowser/issues/700)
# - change background/active tab colors
# - loading bar under tabs (like firefox)
# - maybe equivalent of readability bookmarklet
# - try webrtc and fingerprint test sites
# - strictfocus equivalent
# - maybe use buku for adding bookmarks (and bind a key to query in terminal or
#   something); or org https://orgmode.org/worg/org-contrib/org-protocol.html;
#   http://www.diegoberrocal.com/blog/2015/08/19/org-protocol/
# - zn/e instead of oi for consistency; zoom reset; text vs full zoom
# - count for tw
# - way to get feed info like with pentadactyl's :pageinfo
# - commit quickmarks if havent; gmail quickmark
# - key to get rid of highlights (or automatic)
# - locally disable javascript (e.g. message about adblock)

# ** Nice Things About Qutebrowser
# - more sophisticated completion than pentadactyl (e.g. " " like ".*")
# - very fast/responsive (though I've had session files even for small sessions
#   that made it unusable; TODO look into replicating this)
# - navigation wizardry with :navigate (prev|next|up)

# ** Missing Functionality/ Wishlist
# *** Necessary for Everyday Usage
# - Better cursor behavior in insert mode (this is cause of constant annoyance
#   for me; https://github.com/qutebrowser/qutebrowser/issues/2668;
#   https://github.com/qutebrowser/qutebrowser/pull/3834;
#   https://github.com/qutebrowser/qutebrowser/pull/3906)
# - custom command instead of file browser or post download auto-command
#   (currently have to manually run :download-open; TODO make issue)
# - single key quickmarks (real quickmarks;
#   https://github.com/qutebrowser/qutebrowser/issues/711; also
#   https://github.com/qutebrowser/qutebrowser/issues/882)
# - per-domain keybindings
#   (https://github.com/qutebrowser/qutebrowser/issues/3636)
# - better greasemonkey support
#   (https://github.com/qutebrowser/qutebrowser/issues/3238)

# *** Major
# - plugin support (https://github.com/qutebrowser/qutebrowser/issues/30)
#   - security: secure pasword fill plugin, decentraleyes, cookie auto delete
#     (dedicated issue:
#     https://github.com/qutebrowser/qutebrowser/issues/1660), privacy badger
#     (a ghosterey/disconnect/privacy badger equivalent), agent
#     spoofing/browser fingerprint minimization, etc.
#   - related issues to above:
#     https://github.com/qutebrowser/qutebrowser/issues/2160
#     https://github.com/qutebrowser/qutebrowser/issues/2235
#     https://github.com/qutebrowser/qutebrowser/issues/1659
#   - hover zoom/imagus equivalent (if userscript doesn't work)
#   - DownThemAll equivalent (particularly in conjunction with comic/gallery
#     userscript)
#   - RES equivalent (at least some of the features would be nice)
#   - "automatically spawn mpv on video pages"
# - HTTPS everywhere (https://github.com/qutebrowser/qutebrowser/issues/335)
# - tabgroups (https://github.com/qutebrowser/qutebrowser/issues/49)
# - autocmds/setlocal (https://github.com/qutebrowser/qutebrowser/issues/35)
# - undo completion/history
#   (https://github.com/qutebrowser/qutebrowser/issues/32; also see
#   https://github.com/qutebrowser/qutebrowser/issues/1031)
# - same-window, tab-unique inspector instead of separate windows
#   (https://github.com/qutebrowser/qutebrowser/issues/1400)

# *** Minor
# - better ad-blocking (e.g. youtube not supported; other sites still have lots
#   of ads visible)
#   https://github.com/qutebrowser/qutebrowser/issues/29
# - way to reference ~ / $HOME in filename (TODO make issue)
# - simpler key syntax (c instead of Ctrl,  esc instead of Escape, etc.;
#   TODO make issue)
# - tree style tab view (https://github.com/qutebrowser/qutebrowser/issues/927)
# - rikaikun/rikaichan (seems unlikely)
# - unbind should work for default keybindings (TODO make issue)
# - better caret mode or way to open current page in editor (TODO make issue)
# - full jumplist (https://github.com/qutebrowser/qutebrowser/issues/2642)
# - more hinting modes (https://github.com/qutebrowser/qutebrowser/issues/521)
# - save editor buffer (https://github.com/qutebrowser/qutebrowser/issues/1596)
# - cookies-clear command (TODO make issue)
# - tab-focus jump within current 10 tabs range(or this possible with plugin
#   API; TODO make issue)
# - configurable completion
#   (https://github.com/qutebrowser/qutebrowser/issues/836)
# - support recursive command aliasing (alias an alias)
# - insert editing keys (e.g. rl-backward-kill-word doesn't work in insert but
#   can use fake-key as a workaround)
#   https://github.com/qutebrowser/qutebrowser/issues/68
# - show whether js is enabled
#   https://github.com/qutebrowser/qutebrowser/issues/1795
#   https://github.com/qutebrowser/qutebrowser/issues/1052
# - embedded editor/pterosaur equivalent
#   https://github.com/qutebrowser/qutebrowser/issues/827

# * Helper Functions
def bind(key, command, mode):  # noqa: E302
    """Bind key to command in mode."""
    # TODO set force; doesn't exist yet
    config.bind(key, command, mode=mode)


def nmap(key, command):
    """Bind key to command in normal mode."""
    bind(key, command, 'normal')


def imap(key, command):
    """Bind key to command in insert mode."""
    bind(key, command, 'insert')


def cmap(key, command):
    """Bind key to command in command mode."""
    bind(key, command, 'command')


# def cimap(key, command):
#     """Bind key to command in command mode and insert mode."""
#     cmap(key, command)
#     imap(key, command)


def tmap(key, command):
    """Bind key to command in caret mode."""
    bind(key, command, 'caret')


def pmap(key, command):
    """Bind key to command in passthrough mode."""
    bind(key, command, 'passthrough')


def unmap(key, mode):
    """Unbind key in mode."""
    config.unbind(key, mode=mode)


def nunmap(key):
    """Unbind key in normal mode."""
    unmap(key, mode='normal')


# * Settings
# ** Session
# always restore opened sites when opening qutebrowser
c.auto_save.session = True
c.session.lazy_restore = True

# ** Tabs
# open new tabs (middleclick/ctrl+click) in the background
c.tabs.background = True
# select previous tab instead of next tab when deleting current tab
c.tabs.select_on_remove = 'prev'
# open unrelated tabs after the current tab not last
c.tabs.new_position.unrelated = 'next'
#c.tabs.min_width = 200
#c.tabs.title.format = '{index}{private}{title_sep}{current_title}'

# **
c.aliases = {
    # ** Command Aliases
    "h":        "help",
    "w":        "session-save",
    "wq":       "quit --save",
    "mpv":      "spawn -d mpv --force-window=immediate {url}",
    "nicehash": "spawn --userscript nicehash",
    "pass":     "spawn -d pass -c",

    # ** Bookmarklets/Custom Commands
    'archive':           'open --tab http://web.archive.org/save/{url}',
    'view-archive':      'open --tab http://web.archive.org/web/*/{url}',
    'va':                'open --tab http://web.archive.org/web/*/{url}',
    'view-google-cache': 'open http://www.google.com/search?q=cache:{url}',
    'vgc':               'open http://www.google.com/search?q=cache:{url}',
}

# ** Appearance
# *** General
c.fonts.monospace = 'Fira mono'

# default but not transparent
c.colors.hints.bg = \
    'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 1), ' \
    + 'stop:1 rgba(255, 197, 66, 1))'

c.scrolling.bar = True
# keep smooth scrolling off

# lower delay for keyhint dialog (comparable to which-key)
c.keyhint.delay = 250

# c.tabs.padding = {"top": 2, "bottom": 2,  "left": 0, "right": 4}

# *** Pywal
colorsfile = os.path.expanduser('~/.cache/wal/qutebrowser_colors.py')
if os.path.isfile(colorsfile):
    config.source(colorsfile)

# ** Editor
#c.editor.command = ['emacsclient', '-c', '-a', ' ', '+{line}:{column}', '{}']
c.editor.command = ['urxvt', '-e', 'vim', '{}']
# The editor (and arguments) to use for the `open-editor` command. `{}`
# gets replaced by the filename of the file to be edited.
#c.editor.command = ["termite", "-e", "vim '{}'"]   <=== fail


# ** Hints
# don't require enter after hint keys
c.hints.auto_follow = 'always'
c.hints.chars = 'arstdhneiowfpluy'

# ** Downloads
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False
c.downloads.open_dispatcher = 'dl_move {}'

# ** Security
# defaults
# c.content.cookies.accept = 'no-3rdparty'
# c.content.geolocation = 'ask'
# c.content.headers.do_not_track = True
# c.content.headers.referer = 'same-domain'
# c.content.host_blocking.enabled = True
# c.content.media_capture = 'ask'
# c.content.notifications = 'ask'
# c.content.ssl_strict = 'ask'

# content.javascript.can_access_clipboard
# content.headers.user_agent
# content.javascript.enabled
# content.pdfjs
# content.plugins
# content.proxy
# content.xss_auditing

# ** Input
# don't timeout for during partially entered command
c.input.partial_timeout = 0
# arrow key link element navigation; works okay on some pages
# unfortunately affects hnei too (move-to commands)
# c.input.spatial_navigation = True

# ** Home/Start Page
# TODO generic user home directory reference instead
c.url.default_page = '/home/noctuid/src/homepage/home.html'
c.url.start_pages = ['/home/noctuid/src/homepage/home.html']

# ** Search Keywords
c.url.searchengines = \
    {'DEFAULT': 'https://www.startpage.com/do/search?query={}&?prf=7de10a290cc3cee4fa552d4b43dc3f48',  # noqa: E501
     'aff': 'http://www.anime4fun.com/search?keyword={}',
     'bt': 'http://bato.to/search?name_cond=c&name={}',
     'am': 'https://smile.amazon.com/s?k={}',
     'aw': 'http://wiki.archlinux.org/index.php?search={}',
     'az': 'http://search.azlyrics.com/search.php?q={}',
     'd': 'http://duckduckgo.com/?q={}',
     'dv': 'http://www.deviantart.com/?q={}',
     'fl': 'http://fluffy.is/search.php?folders=&name={}',
     'gh': 'http://github.com/search?q={}',
     'hg': 'http://www.haskell.org/hoogle/?hoogle={}',
     'j': 'http://jisho.org/search/{}',
     'mal': 'https://myanimelist.net/search/all?q={}',
     'mus': 'http://www.allmusic.com/search/all/{}',
     'r': 'http://www.reddit.com/r/{}/',
     'rt': 'http://www.rottentomatoes.com/search/?search={}',
     's': 'https://searx.me/?q={}',
     't': 'http://www.tumblr.com/search/{}',
     # other useful yub nub commands: cnv, gim, tiny, ddg, torf, etc.
     # useful mostly for stuff that combines things like mash, split, weird
     # piping stuff, etc.
     'yub': 'http://yubnub.org/parser/parse?command={}',
     'y': 'http://www.youtube.com/results?search_query={}',
     'wayback':  'http://web.archive.org/web/*/{}',
     'zerochan':  'http://www.zerochan.net/{}',
    }

# ** Media
#c.content.autoplay = False

# ** Zoom
# decrease for HiDPI (necessary with QT_AUTO_SCREEN_SCALE_FACTOR=1)
if os.getenv('MONITOR_IS_HIDPI'):
    c.zoom.default = 67

# Bindings
config.bind("gi", "hint inputs")
config.bind("<f12>", "inspector")

config.unbind("+")
config.unbind("-")
config.unbind("=")
config.bind("z+", "zoom-in")
config.bind("z-", "zoom-out")
config.bind("zz", "zoom")

config.unbind("O")
config.unbind("T")
config.unbind("th")
config.unbind("tl")
config.bind("O", "set-cmd-text :open {url:pretty}")
config.bind("T", "set-cmd-text :open -t {url:pretty}")
config.bind("t", "set-cmd-text -s :open -t")

config.unbind("<ctrl+tab>")
config.bind("<ctrl+tab>", "tab-next")
config.bind("<ctrl+shift+tab>", "tab-prev")

config.unbind("ZQ")
config.unbind("ZZ")
config.unbind("<ctrl+q>")
config.bind("<ctrl+q>", "wq")

## * Key Bindings
## ** Reload Configuration
#nmap('t.', 'config-source')
#
## ** Miscellaneous Swaps
## swap ; and :
#nmap(';', 'set-cmd-text :')
#nunmap(':')
#hints_dict = dict()  # pylint: disable = C0103
#for k, v in c.bindings.default['normal'].items():
#    if k.startswith(';'):
#        hints_dict[re.sub(r'^;(.*)', r':\1', k)] = v
#c.bindings.commands['normal'].update(hints_dict)
#
## lose scroll left
#nmap('h', 'back')
#nmap('H', 'forward')
#
## lose scroll right
#nmap('l', 'tab-focus last')
#
#nmap('b', 'set-cmd-text --space :buffer')
#
## ** Colemak Swaps
## https://github.com/qutebrowser/qutebrowser/issues/2668#issuecomment-309098314
#nmap('n', 'scroll-page 0 0.2')
#nmap('e', 'scroll-page 0 -0.2')
#nmap('N', 'tab-prev')
## no default binding
#nmap('E', 'tab-next')
#
## add back search
#nmap('k', 'search-next')
#nmap('K', 'search-prev')
#
#tmap('n', 'move-to-next-line')
#tmap('e', 'move-to-prev-line')
#tmap('i', 'move-to-next-char')
## add back e functionality
#tmap('j', 'move-to-end-of-word')
#
#tmap('N', 'scroll down')
#tmap('E', 'scroll up')
#tmap('I', 'scroll right')
#
## ** Hinting
## I think I like this better than going to first input
#nmap('gi', 'hint inputs')
## TODO ts for download hinting instead of :d
## TODO ti for image hinting in background (rebind :inspector)
#
## ** Miscellaneous
#nmap('gn', 'navigate previous')
#nmap('ge', 'navigate next')
#
#nmap('tm', 'messages --tab')
#nmap('th', 'help --tab')
#nmap('tr', 'stop')
#
## @: - run last ex command
#nmap('t;','set-cmd-text : ;; completion-item-focus --history prev ;; '
#     + 'command-accept')
#
## ** Tabs and Windows
#nmap('o', 'set-cmd-text -s :open --tab')
#nmap('O', 'set-cmd-text -s :open')
#
## open homepage in new tab
#nmap('tt', 'open --tab')
#
## lose tab-only and download-clear
#nmap('c', 'set-cmd-text :open --related {url:pretty}')
#nmap('C', 'set-cmd-text :open --tab --related {url:pretty}')
#
## open new private window
#nmap('tp', 'open -p')
#
## tn and te for tab moving
#nmap('tn', 'tab-move -')
#nmap('te', 'tab-move +')
#
## ** TODO Tabgroups
## - title should be displayed somewhere
## - create new group (vn)
## - move tab to different group (vM; vm - without switching)
## - switch to different group (vv completion)
## - keys for specific tap groups (e.g. wr,  prog, main, mango)
## - rename tab group (vr)
## - delete tab group (vd)
#
## ** Yanking and Pasting
## don't need primary or extra yanks
#nmap('p', 'open --tab -- {clipboard}')
#nmap('P', 'open -- {clipboard}')
#nmap('y', 'yank')
#nmap('Y', 'yank selection')
#
## ** Editor
#imap('<Ctrl-i>', 'open-editor')
## open source in editor
#nmap('gF', 'view-source --edit')
#
## ** Insert/RL
#imap('<Ctrl-w>', 'fake-key <Ctrl-backspace>')
#imap('¸', 'fake-key <Ctrl-backspace>')
#cmap('¸', 'fake-key --global <Ctrl-backspace>')
#
## nunmap('<Ctrl-w>')
## prevent c-w from closing tab
#del c.bindings.default['normal']['<Ctrl-W>']
#
## C-y for pasting
#imap('<Ctrl-y>', 'fake-key <Ctrl-v>')
#cmap('<Ctrl-y>', 'fake-key --global <Ctrl-v>')
#
## ** Passthrough
#nmap(',', 'enter-mode passthrough')
#pmap('<Escape>', 'leave-mode')
#
## ** Undo
## no :undo completion currently
## nmap('U', 'set-cmd-text --space :undo')
#
## ** Quickmarks and Marks
#nmap("'", 'set-cmd-text -s :quickmark-load --tab')
## nmap('B', 'set-cmd-text -s :bookmark-load --tab')
#nmap("t'", 'set-cmd-text -s :bookmark-load --tab')
#
## add back mark jumping
#nmap('"', 'enter-mode jump_mark')
#nmap('tl', 'jump-mark "\'"')
#
## ** Spawn/Shell
## *** Bookarking with Buku
## can add tags after
#nmap('m', 'set-cmd-text -s :spawn --detach buku --add "{url}"')
#
## *** Playing Videos with MPV
## "y" for youtube-dl
#nmap('ty', 'spawn --detach mpv "{url}"')
#
## ** Downloads
## TODO download video and audio
## nmap -ex <leader>Y execute "silent !youtube-dl --restrict-filenames -o '~/move/%(title)s_%(width)sx%(height)s_%(upload_date)s.%(ext)s' " + buffer.URL + " &"
## nmap -ex <leader>A execute "silent !youtube-dl --restrict-filenames --extract-audio -o '~/move/%(title)s_%(width)sx%(height)s_%(upload_date)s.%(ext)s' " + buffer.URL + " &"
#nmap('tw', 'download --dest ~/database/move/ ;; tab-close')
#nmap('tg', 'spawn --detach dlg "{url}"')
#nmap('td', 'download-open')
#nmap('tr', 'spawn --detach dl_move bulk_store')
#nmap('tc', 'download-clear')
#
## ** Zooming
#nmap('zi', 'zoom-in')
#nmap('zo', 'zoom-out')
#
## ** Inspector
#nmap('ti', 'inspector')

# * TODO Per Domain
# ~/.pentadactyl/groups.penta
# ** Settings
# ** Keybindings

# * TODO Greasemonkey
# supposed to work with qutebrowser
# - https://greasyfork.org/en/scripts/404-mouseover-popup-image-viewer is
# - try ccd0/4chan x
# - https://github.com/untamed0/Show-Just-Image-3


# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = "white"

# Background color of unselected tabs.
c.colors.tabs.even.bg = "silver"
c.colors.tabs.odd.bg = "gainsboro"

# Foreground color of unselected tabs.
c.colors.tabs.even.fg = "#666666"
c.colors.tabs.odd.fg = c.colors.tabs.even.fg

# The height of the completion, in px or as percentage of the window.
c.completion.height = "20%"

# Move on to the next part when there's only one possible completion
# left.
c.completion.quick = False

# When to show the autocompletion window.
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
c.completion.show = "auto"

# Whether quitting the application requires a confirmation.
# Valid values:
#   - always: Always show a confirmation.
#   - multiple-tabs: Show a confirmation if multiple tabs are opened.
#   - downloads: Show a confirmation if downloads are running
#   - never: Never show a confirmation.
c.confirm_quit = ["downloads"]

# Value to send in the `Accept-Language` header.
c.content.headers.accept_language = "en-US,en;q=0.8,fi;q=0.6"

# The proxy to use. In addition to the listed values, you can use a
# `socks://...` or `http://...` URL.
# Valid values:
#   - system: Use the system wide proxy.
#   - none: Don"t use any proxy
c.content.proxy = "none"

# Validate SSL handshakes.
# Valid values:
#   - true
#   - false
#   - ask
c.content.ssl_strict = False

# A list of user stylesheet filenames to use.
c.content.user_stylesheets = "user.css"

# The directory to save downloads to. If unset, a sensible os-specific
# default is used.
#c.downloads.location.directory = "/tmp/ape"

# Prompt the user for the download location. If set to false,
# `downloads.location.directory` will be used.
c.downloads.location.prompt = False

monospace = "8px 'Bok MonteCarlo'"

# Font used in the completion categories.
c.fonts.completion.category = f"bold {monospace}"

# Font used in the completion widget.
c.fonts.completion.entry = monospace

# Font used for the debugging console.
c.fonts.debug_console = monospace

# Font used for the downloadbar.
c.fonts.downloads = monospace

# Font used in the keyhint widget.
c.fonts.keyhint = monospace

# Font used for error messages.
c.fonts.messages.error = monospace

# Font used for info messages.
c.fonts.messages.info = monospace

# Font used for warning messages.
c.fonts.messages.warning = monospace

# Font used for prompts.
c.fonts.prompts = monospace

# Font used in the statusbar.
c.fonts.statusbar = monospace

# Font used in the tab bar.
c.fonts.tabs = monospace

# Font used for the hints.
c.fonts.hints = "bold 13px 'DejaVu Sans Mono'"

# Chars used for hint strings.
c.hints.chars = "asdfghjklie"

# Leave insert mode if a non-editable element is clicked.
c.input.insert_mode.auto_leave = True

# Automatically enter insert mode if an editable element is focused
# after loading the page.
c.input.insert_mode.auto_load = True

# Show a scrollbar.
c.scrolling.bar = True

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
c.scrolling.smooth = False

# Open new tabs (middleclick/ctrl+click) in the background.
c.tabs.background = True

# Behavior when the last tab is closed.
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = "close"

# Padding around text for tabs
c.tabs.padding = {
    "left": 5,
    "right": 5,
    "top": 0,
    "bottom": 1,
}

# Which tab to select when the focused tab is removed.
# Valid values:
#   - prev: Select the tab which came before the closed one (left in horizontal, above in vertical).
#   - next: Select the tab which came after the closed one (right in horizontal, below in vertical).
#   - last-used: Select the previously selected tab.
c.tabs.select_on_remove = "prev"

# Width of the progress indicator (0 to disable).
#c.tabs.width.indicator = 0

# The page to open if :open -t/-b/-w is used without URL. Use
# `about:blank` for a blank page.
c.url.default_page = "about:blank"

# Definitions of search engines which can be used via the address bar.
# Maps a searchengine name (such as `DEFAULT`, or `ddg`) to a URL with a
# `{}` placeholder. The placeholder will be replaced by the search term,
# use `{{` and `}}` for literal `{`/`}` signs. The searchengine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
c.url.searchengines = {"DEFAULT": "https://www.google.fi/search?q={}"}

# The page(s) to open at the start.
c.url.start_pages = "https://ape3000.com/"

# The format to use for the window title. The following placeholders are
# defined:
#   * `{perc}`: The percentage as a string like `[10%]`.
#   * `{perc_raw}`: The raw percentage, e.g. `10`
#   * `{title}`: The title of the current web page
#   * `{title_sep}`: The string ` - ` if a title is set, empty otherwise.
#   * `{id}`: The internal window ID of this window.
#   * `{scroll_pos}`: The page scroll position.
#   * `{host}`: The host of the current web page.
#   * `{backend}`: Either ''webkit'' or ''webengine''
#   * `{private}` : Indicates when private mode is enabled.
c.window.title_format = "{private}{perc}{title}{title_sep}qutebrowser"
