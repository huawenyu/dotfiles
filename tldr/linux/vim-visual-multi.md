# vim-visual-multi:

> Description.
> [More information](https://github.com/mg979/vim-visual-multi/).

# Key map

    # Enter VSM mode
        ### Re-map C-n to C-d as-Enter-VSM-mode
        ### https://github.com/mg979/vim-visual-multi/blob/master/doc/vm-mappings.txt
        Find Under            <C-d>       select the word under cursor
        Find Subword Under    <C-d>       from visual mode, without word boundaries
        Exit                  <Esc>       quit VM
        Select All            \\A         select all occurrences of a word
        Start Regex Search    \\/         create a selection with regex search
        Add Cursor At Pos     \\\         add a single cursor at current position
        Reselect Last         \\gS        reselect set of regions of last VM session

    # Special command:
        Increase              <C-A>       increase numbers (same as vim)
        Decrease              <C-X>       decrease numbers (same as vim)
        gIncrease             g<C-A>      progressively increase numbers (like |v_g_CTRL-A|)
        gDecrease             g<C-X>      progressively decrease numbers (like |v_g_CTRL-X|)
        Alpha-Increase        \\<C-A>     same but +alpha (see |'nrformats'|)

    # command:
        Transpose             \\t         transpose
        Align                 \\a         align regions
        Align Char            \\<         align by character
        Align Regex           \\>         align by regex
        Split Regions         \\s         subtract pattern from regions
        Filter Regions        \\f         filter regions by pattern/expression
        Transform Regions     \\e         transform regions with expression
        Rewrite Last Search   \\r         rewrite last pattern to match current region
        Merge Regions         \\m         merge overlapping regions
        Duplicate             \\d         duplicate regions
        Shrink                \\-         reduce regions from the sides
        Enlarge               \\+         enlarge regions from the sides
        One Per Line          \\L         keep at most one region per line
        Numbers               \\n         see |vm-numbering|
        Numbers Append        \\N         ,,

# Features:

