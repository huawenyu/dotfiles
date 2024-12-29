% VimMaps(1) | VimMaps Manual
% Wilson  wilson.yuu@gmail.com
% 2024-12-27

NAME
===
**Vim_Maps** - A man page written in Markdown
**vim_cheat(1)**, **vim(1)**

SYNOPSIS
===
`Vim_Maps` [*options*] [*arguments*]

-`LD-leader` is \<space\>  | `LD2-leader2` is `;`

-`K`-Help | `;q`-Smartclose  `<LD>q`-Exit `<LD><LD>`-Preview Tag `<LD2><LD2>`-Jump-char2

-`<LD>*`     : c-Change  v-Views  e-Edit/Execute  g-Git  t-Terminal  m-Make/Mark  s-Session/Workspace/Save

```table

Category\Prefix | Alt | L    | L2   | Comment                   | Sample
--------------  | --  | --   | --   | --                        |
Leader prefix   | M   | 󱁐    | ;    |                           |
--------------  | --  | --   | --   | --                        |
Shortcut        |     | 󱁐    |      |                           |
-               | M   | 󱁐    | ;    |                           |
                | ➜ e |      |      | (view)Toggle explore      |
                | ➜ t |      |      | (view)Toggle tag          |
                | ➜ f |      |      | (lsp)Reference            |
           n/v  | ➜ s |      |      | Search text               |
                | ➜ w |      |      | Edit Fence Code           |
                | ➜ g |      |      | (view)Toggle git-status   |
                | ➜ b |      |      | (view)Toggle buffers      |
                |     | v➜ v | v➜ v | Search all                |
                |     | g➜ g | g➜ g | Search in <dir>           |
                |     |      | ➜ ;  | (motion)Hop by char2      |
Views           |     | 󱁐v   |      |                           |
-               |     | ➜ 1  |      | Outline 1                 |
                |     | ➜ a  |      | buffer swap               |
                |     | ➜ b  |      | buffers                   |
                |     | ➜ e  |      | Files                     |
                |     | ➜ f  |      | Focus                     |
                |     | ➜ g  |      | Git                       |
                |     | ➜ i  |      | Markdown preview          |
                |     | ➜ o  |      | Outline                   |
                |     | ➜ q  |      | quickfix                  |
                |     | ➜ r  |      | Replace                   |
                |     | ➜ s  |      | Pick a window             |
                |     | ➜ t  |      | Tag                       |
                |     | ➜ v  |      | Search all                |
                |     | ➜ w  |      | Max-windo                 |
Change          |     | 󱁐c   |      |                           |
-               |     | ➜ c  |      | EasyAlign                 |
                |     | ➜ t  |      | Trim trailing space       |
                |     | ➜ i  |      | Capitalize                |
                |     | ➜ l  |      | lowercase                 |
                |     | ➜ u  |      | UPPERCASE                 |
                |     | ➜ w  |      | Wrap pagraph              |
                |     | ➜ d  |      | Delete search             |
                |     | ➜ 󱁐  |      | Text keep one space       |
Edit/Execute    |     | 󱁐e   |      |                           |
-               |     | ➜ e  |      | Execute                   |
                |     | ➜ p  |      | TemplateHere              |
Find            |     | 󱁐f   | ;f   |                           |
-               |     | ➜ f  | ➜ f  | (fzf)Open file            |
                |     | ➜ s  | ➜ s  | (fzf)Symbol               |
Find-tag/cscope |     | 󱁐f   |      |                           |
                |     | ➜ F  |      | Open file (all)           |
                |     | ➜ g  |      | (fzf)Grep                 |
                |     | ➜ c  |      | (cscope)Caller            |
                |     | ➜ C  |      | (cscope)Callee            |
                |     | ➜ S  |      | (cscope)Reference +       |
                |     | ➜ w  |      | (cscope)Ref-write         |
                |     | ➜ W  |      | (cscope)Ref-write +       |
                |     | ➜ ]  |      | (tag)Create               |
                |     | ➜ t  |      | (fzf)Tag                  |
                |     | ➜ T  |      | (fzf)TagWiki              |
Find(lsp)       |     |      | ;f   |                           |
-               |     |      | ➜ d  | (lsp)Definition           |
                |     |      | ➜ D  | (lsp)Declaration          |
                |     |      | ➜ h  | (lsp)Show info            |
                |     |      | ➜ H  | (lsp)Show action          |
                |     |      | ➜ i  | (lsp)Implement            |
                |     |      | ➜ n  | (lsp)Diag next            |
                |     |      | ➜ p  | (lsp)Diag prev            |
                |     |      | ➜ q  | (lsp)Diag sink local      |
                |     |      | ➜ r  | (lsp)Refactor rename      |
Git             |     | 󱁐g   |      |                           |
-               |     | ➜ b  |      | (git)Blame                |
                |     | ➜ d  |      | (git)Diff                 |
                |     | ➜ D  |      | (git)DiffTab              |
                |     | ➜ g  |      | (git)Search               |
                |     | ➜ f  |      | (tool)GotoFile            |
                |     | ➜ l  |      | (git)Log                  |
                |     | ➜ s  |      | (git)Status               |
                |     | ➜ x  |      | (git)Clean                |
                |     | ➜ r  |      | (gutter)Review            |
                |     | ➜ a  |      | (gutter)Stage             |
                |     | ➜ p  |      | (gutter)Prev              |
                |     | ➜ n  |      | (gutter)Next              |
                |     | ➜ u  |      | (gutter)Undo              |
Mark/Make       |     | 󱁐m   |      |                           |
-               |     | ➜ a  |      | Make all                  |
                |     | ➜ c  |      | QF add caller             |
                |     | ➜ f  |      | QF filter                 |
                |     | ➜ k  |      | Make wad                  |
                |     | ➜ m  |      | Colorize word             |
                |     | ➜ w  |      | (tool)Dictionary          |
                |     | ➜ x  |      | (color)Clear all colorize |
Search/Session  |     | 󱁐s   |      |                           |
-               |     | ➜ 1  |      | Search wad                |
                |     | ➜ 2  |      | Search cmf                |
                |     | ➜ 3  |      | Search                    |
                |     | ➜ a  |      | Save file as              |
                |     | ➜ b  |      | (fzf)Buffers              |
                |     | ➜ c  |      | (fzf)Changes              |
                |     | ➜ g  |      | (fzf)git-status           |
                |     | ➜ h  |      | (fzf)History              |
                |     | ➜ j  |      | (fzf)Jump                 |
                |     | ➜ l  |      | (fzf)Line                 |
                |     | ➜ m  |      | (fzf)Marks                |
                |     | ➜ q  |      | (fzf)Quickfix             |
                |     | ➜ r  |      | Session restore           |
                |     | ➜ s  |      | Session save              |
                |     | ➜ w  |      | (fzf)Windows              |
                |     | ➜ /  |      | (fzf)history-search       |
                |     | ➜ :  |      | (fzf)history-cmd          |
                |     | ➜ ;  |      | (fzf)history-cmd          |
Info            |     | 󱁐i   |      |                           |
-               |     | ➜ f  |      | (info)File                |
                |     | ➜ c  |      | (info)Code                |
                |     | ➜ s  |      | (info)Syntax              |
                |     | ➜ S  |      | (info)Syntax +            |

```

SEE ALSO
===
**vim_cheat(1)**, **vim(1)**

For more information, see [Man pages with Markdown and Pandoc]
(https://gabmus.org/posts/man_pages_with_markdown_and_pandoc/).

