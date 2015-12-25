# Zsh Line Editor
If the ZLE option is set (it is by default) and the shell input is attached to the terminal, the user is allowed to edit command lines.

There are two display modes. The first, multi-line mode, is the default. It only works if the TERM parameter is set to a valid terminal type that can move the cursor up. The second, single line mode, is used if TERM is invalid or incapable of moving the cursor up, or if the SINGLE_LINE_ZLE option is set. This mode is similar to ksh, and uses no termcap sequences. If TERM is `emacs', the ZLE option will be unset by the shell.

## Bindings

Command bindings may be set using the bindkey builtin. There are two keymaps; the main keymap and the alternate keymap. The alternate keymap is bound to vi command mode. The main keymap is bound to emacs mode by default. To bind the main keymap to vi insert mode, use bindkey -v. However, if either of the VISUAL or EDITOR environment variables contains the string `vi' when the shell starts up the main keymap will be bound to vi insert mode by default.

The following is a list of all the key commands and their default bindings in emacs mode, vi command mode and vi insert mode.

### Movement

- **vi-backward-blank-word** (unbound) (B) (unbound)
    Move backward one word, where a word is defined as a series of non-blank characters.
- **backward-char** (^B ESC-[D) (unbound)
    Move backward one character.
- **vi-backward-char** (unbound) (^H h ^?) (unbound)
    Move backward one character, without changing lines.
- **backward-word** (ESC-B ESC-b) (unbound) (unbound)
    Move to the beginning of the previous word.
- **emacs-backward-word**
    Move to the beginning of the previous word.
- **vi-backward-word** (unbound) (b) (unbound)
    Move to the beginning of the previous word, vi-style.
- **beginning-of-line** (^A) (unbound) (unbound)
    Move to the beginning of the line. If already at the beginning of the line, move to the beginning of the previous line, if any.
- **vi-beginning-of-line**
    Move to the beginning of the line, without changing lines.
- **end-of-line** (^E) (unbound) (unbound)
    Move to the end of the line. If already at the end of the line, move to the end of the next line, if any.
- **vi-end-of-line** (unbound) ($) (unbound)
    Move to the end of the line. If an argument is given to this command, the cursor will be moved to the end of the line (argument - 1) lines down.
- **vi-forward-blank-word** (unbound) (W) (unbound)
    Move forward one word, where a word is defined as a series of non-blank characters.
- **vi-forward-blank-word-end** (unbound) (E) (unbound)
    Move to the end of the current word, or, if at the end of the current word, to the end of the next word, where a word is defined as a series of non-blank characters.
- **forward-char** (^F ESC-[C) (unbound) (unbound)
    Move forward one character.
- **vi-forward-char** (unbound) (SPACE l) (unbound)
    Move forward one character.
- **vi-find-next-char** (^X^F) (f) (unbound)
    Read a character from the keyboard, and move to the next occurrence of it in the line.
- **vi-find-next-char-skip** (unbound) (t) (unbound)
    Read a character from the keyboard, and move to the position just before the next occurrence of it in the line.
- **vi-find-prev-char** (unbound) (F) (unbound)
    Read a character from the keyboard, and move to the previous occurrence of it in the line.
- **vi-find-prev-char-skip** (unbound) (T) (unbound)
    Read a character from the keyboard, and move to the position just after the previous occurrence of it in the line.
- **vi-first-non-blank** (unbound) (^) (unbound)
    Move to the first non-blank character in the line.
- **vi-forward-word** (unbound) (w) (unbound)
    Move forward one word, vi-style.
- **forward-word** (ESC-F ESC-f) (unbound) (unbound)
    Move to the beginning of the next word. The editor's idea of a word is specified with the WORDCHARS parameter.
- **emacs-forward-word**
    Move to the end of the next word.
- **vi-forward-word-end** (unbound) (e) (unbound)
    Move to the end of the next word.
- **vi-goto-column** (ESC-|) (|) (unbound)
    Move to the column specified by the numeric argument.
- **vi-goto-mark** (unbound) (\`) (unbound)
    Move to the specified mark.
- **vi-goto-mark-line** (unbound) (') (unbound)
    Move to the beginning of the line containing the specified mark.
- **vi-repeat-find** (unbound) (;) (unbound)
    Repeat the last vi-find command.
- **vi-rev-repeat-find** (unbound) (,) (unbound)
    Repeat the last vi-find command in the opposite direction.

### History Control

- **beginning-of-buffer-or-history** (ESC-<) (unbound) (unbound)
    Move to the beginning of the buffer, or if already there, move to the first event in the history list.
- **beginning-of-line-hist**
    Move to the beginning of the line. If already at the beginning of the buffer, move to the previous history line.
- **beginning-of-history**
    Move to the first event in the history list.
- **down-line-or-history** (^N ESC-[B) (j) (unbound)
    Move down a line in the buffer, or if already at the bottom line, move to the next event in the history list.
- **vi-down-line-or-history** (unbound) (+) (unbound)
    Move down a line in the buffer, or if already at the bottom line, move to the next event in the history list. Then move to the first non-blank character on the line.
- **down-line-or-search**
    Move down a line in the buffer, or if already at the bottom line, search forward in the history for a line beginning with the first word in the buffer.
- **down-history** (unbound) (^N) (unbound)
    Move to the next event in the history list.
- **history-beginning-search-backward**
    Search backward in the history for a line beginning with the current line up to the cursor. This leaves the cursor in its original position.
- **end-of-buffer-or-history** (ESC->) (unbound) (unbound)
    Move to the end of the buffer, or if already there, move to the last event in the history list.
- **end-of-line-hist**
    Move to the end of the line. If already at the end of the buffer, move to the next history line.
- **end-of-history**
    Move to the last event in the history list.
- **vi-fetch-history** (unbound) (G) (unbound)
    Fetch the history line specified by the numeric argument. This defaults to the current history line (i.e. the one that isn't history yet).
- **history-incremental-search-backward** (^R ^Xr) (unbound) (unbound)
    Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line. A restricted set of editing functions is available in the mini-buffer. An interrupt signal, as defined by the stty setting, will stop the search and go back to the original line. An undefined key will have the same effect. The supported functions are: backward-delete-char, vi-backward-delete-character, clearscreen, redisplay, quoted-insert, vi-quoted-insert, accept-and-hold, accept-and-infer-next-history, accept-line and accept-line-and-down-history; magic-space just inserts a space. vi-cmd-mode toggles between the main and alternate key bindings; the main key bindings (insert mode) will be selected initially. Any string that is bound to an out-string (via bindkey -s) will behave as if out-string were typed directly. Typing the binding of history-incremental-search-backward will get the next occurrence of the contents of the mini-buffer. Typing the binding of history-incremental-search-forward inverts the sense of the search. The direction of the search is indicated in the mini-buffer. Any single character that is not bound to one of the above functions, or self-insert or self-insert-unmeta will have the same effect but the function will be executed.
- **history-incremental-search-forward** (^S ^Xs) (unbound) (unbound)
    Search forward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line. The functions available in the mini-buffer are the same as for history-incremental-search-backward.
- **history-search-backward** (ESC-P ESC-p) (unbound) (unbound)
    Search backward in the history for a line beginning with the first word in the buffer.
- **vi-history-search-backward** (unbound) (/) (unbound)
    Search backward in the history for a specified string. The string may begin with ^ to anchor the search to the beginning of the line. A restricted set of editing functions is available in the mini-buffer. An interrupt signal, as defined by the stty setting, will stop the search. The functions available in the mini-buffer are: accept-line, vi-cmd-mode (treated the same as acceptline), backward-delete-char, vi-backward-delete-char, backward-kill-word, vi-backward-kill-word, clear-screen, redisplay, magic-space (treated as a space), quoted-insert and vi-quoted-insert. Any string that is not bound to an out-string (via bindkey -s) will behave as if out-string were typed directly. Any other character that is not bound to self-insert or self-insert-unmeta will beep and be ignored. If the function is called from vi command mode, the bindings of the current insert mode will be used.
- **history-search-forward** (ESC-N ESC-n) (unbound) (unbound)
    Search forward in the history for a line beginning with the first word in the buffer.
- **vi-history-search-forward** (unbound) (?) (unbound)
    Search forward in the history for a specified string. The string may begin with ^ to anchor the search to the beginning of the line. The functions available in the mini-buffer are the same as for vi-history-search-backward.
- **infer-next-history** (^X^N) (unbound) (unbound)
    Search in the history for a line matching the current one and fetch the event following it.
- **insert-last-word** (ESC-\_ ESC-.) (unbound) (unbound)
    Insert the last word from the previous history event at the cursor position. If a positive numeric argument is given, insert that word from the end of the previous history event. If the argument is zero or negative insert that word from the left (zero inserts the previous command word).
- **vi-repeat-search** (unbound) (n) (unbound)
    Repeat the last vi history search.
- **vi-rev-repeat-search** (unbound) (N) (unbound)
    Repeat the last vi history search, but in reverse.
- **up-line-or-history** (^P ESC-[A) (k) (unbound)
    Move up a line in the buffer, or if already at the top line, move to the previous event in the history list.
- **up-line-or-search**
    Move up a line in the buffer, or if already at the top line, search backward in the history for a line beginning with the first word in the buffer.
- **up-history** (unbound) (^P) (unbound)
    Move to the previous event in the history list.
- **history-beginning-search-forward**
    Search forward in the history for a line beginning with the current line up to the cursor. This leaves the cursor at its original position.

### Modifying Text

- **vi-add-eol** (unbound) (A) (unbound)
    Move to the end of the line and enter insert mode.
- **vi-add-next** (unbound) (a) (unbound)
    Enter insert mode after the current cursor position, without changing lines.
- **backward-delete-char** (^H ^?) (unbound) (unbound)
    Delete the character behind the cursor.
- **vi-backward-delete-char** (unbound) (X) (^H)
    Delete the character behind the cursor, without changing lines. If in insert mode this won't delete past the point where insert mode was last entered.
- **backward-delete-word**
    Delete the word behind the cursor.
- **backward-kill-line**
    Kill from the beginning of the line to the cursor position.
- **backward-kill-word** (^W ESC-^H ESC-^?) (unbound) (unbound)
    Kill the word behind the cursor.
- **vi-backward-kill-word** (unbound) (unbound) (^W)
    Kill the word behind the cursor, without going past the point where insert mode was last entered.
- **capitalize-word** (ESC-C ESC-c) (unbound) (unbound)
    Capitalize the current word and move past it.
- **vi-change** (unbound) (c) (unbound)
    Read a movement command from the keyboard, and kill from the cursor position to the endpoint of the movement. Then enter insert mode. If the command is vi-change, kill the current line.
- **vi-change-eol** (unbound) (C) (unbound)
    Kill to the end of the line and enter insert mode.
- **vi-change-whole-line** (unbound) (S) (unbound)
    Kill the current line and enter insert mode.
- **copy-region-as-kill** (ESC-W ESC-w) (unbound) (unbound)
    Copy the area from the cursor to the mark to the kill buffer.
- **copy-prev-word** (ESC-^\_) (unbound) (unbound)
    Duplicate the word behind the cursor.
- **vi-delete** (unbound) (d) (unbound)
    Read a movement command from the keyboard, and kill from the cursor position to the endpoint of the movement. If the command is vi-delete, kill the current line.
- **delete-char**
    Delete the character under the cursor.
- **vi-delete-char** (unbound) (x) (unbound)
    Delete the character under the cursor, without going past the end of the line.
- **delete-word**
    Delete the current word.
- **down-case-word** (ESC-L ESC-l) (unbound) (unbound)
    Convert the current word to all lowercase and move past it.
- **kill-word** (ESC-D ESC-d) (unbound) (unbound)
    Kill the current word.
- **gosmacs-transpose-chars**
    Exchange the two characters behind the cursor.
- **vi-indent** (unbound) (>) (unbound)
    Indent a number of lines.
- **vi-insert** (unbound) (i) (unbound)
    Enter insert mode.
- **vi-insert-bol** (unbound) (I) (unbound)
    Move to the beginning of the line and enter insert mode.
- **vi-join** (^X^J) (J) (unbound)
    Join the current line with the next one.
- **kill-line** (^K) (unbound) (unbound)
    Kill from the cursor to the end of the line.
- **vi-kill-line** (unbound) (unbound) (^U)
    Kill from the cursor back to wherever insert mode was last entered.
- **vi-kill-eol** (unbound) (D) (unbound)
    Kill from the cursor to the end of the line.
- **kill-region**
    Kill from the cursor to the mark.
- **kill-buffer** (^X^K) (unbound) (unbound)
    Kill the entire buffer.
- **kill-whole-line** (^U) (unbound) (unbound)
    Kill the current line.
- **vi-match-bracket** (^X^B) (%) (unbound)
    Move to the bracket character (one of {}, (), or []) that matches the one under the cursor. If the cursor is not on a bracket character, move forward without going past the end of the line to find one, and then go to the matching bracket.
- **vi-open-line-above** (unbound) (O) (unbound)
    Open a line above the cursor and enter insert mode.
- **vi-open-line-below** (unbound) (o) (unbound)
    Open a line below the cursor and enter insert mode.
- **vi-oper-swap-case**
    Read a movement command from the keyboard, and swap the case of all characters from the cursor position to the endpoint of the movement. If the movement command is vi-oper-swap-case, swap the case of all characters on the current line.
- **overwrite-mode** (^X^O) (unbound) (unbound)
    Toggle between overwrite mode and insert mode.
- **vi-put-before** (unbound) (P) (unbound)
    Insert the contents of the kill buffer before the cursor. If the kill buffer contains a sequence of lines (as opposed to characters), paste it above the current line.
- **vi-put-after** (unbound) (p) (unbound)
    Insert the contents of the kill buffer after the cursor. If the kill buffer contains a sequence of lines (as opposed to characters), paste it below the current line.
- **quoted-insert** (^V) (unbound) (unbound)
    Insert the next character typed into the buffer literally. An interrupt character will not be inserted.
- **vi-quoted-insert** (unbound) (unbound) (^Q ^V)
    Display a ^ at the current position, and insert the next character typed into the buffer literally. An interrupt character will not be inserted.
- **quote-line** (ESC-') (unbound) (unbound)
    Quote the current line; that is, put a ' character at the beginning and the end, and convert all ' characters to \'.
- **quote-region** (ESC-") (unbound) (unbound)
    Quote the region from the cursor to the mark.
- **vi-replace** (unbound) (R) (unbound)
    Enter overwrite mode.
- **vi-repeat-change** (unbound) (.) (unbound)
    Repeat the last vi mode text modification. If a count was used with the modification, it is remembered. If a count is given to this command, it overrides the remembered count, and is remembered for future uses of this command. The cut buffer specification is similarly remembered.
- **vi-replace-chars** (unbound) (r) (unbound)
    Replace the character under the cursor with a character read from the keyboard.
- **self-insert** (printable characters) (unbound) (printable characters and some control characters)
    Put a character in the buffer at the cursor position.
- **self-insert-unmeta** (ESC-^I ESC-^J ESC-^M) (unbound) (unbound)
    Put a character in the buffer after stripping the meta bit and converting ^M to ^J.
- **vi-substitute** (unbound) (s) (unbound)
    Substitute the next character(s).
- **vi-swap-case** (unbound) (~) (unbound)
    Swap the case of the character under the cursor and move past it.
- **transpose-chars** (^T) (unbound) (unbound)
    Exchange the two characters to the left of the cursor if at end of line, else exchange the character under the cursor with the character to the left.
- **transpose-words** (ESC-T ESC-t) (unbound) (unbound)
    Exchange the current word with the one before it.
- **vi-unindent** (unbound) (<) (unbound)
    Unindent a number of lines.
- **up-case-word** (ESC-U ESC-u) (unbound) (unbound)
    Convert the current word to all caps and move past it.
- **yank** (^Y) (unbound) (unbound)
    Insert the contents of the kill buffer at the cursor position.
- **yank-pop** (ESC-y) (unbound) (unbound)
    Remove the text just yanked, rotate the kill-ring, and yank the new top. Only works following yank or yank-pop.
- **vi-yank** (unbound) (y) (unbound)
    Read a movement command from the keyboard, and copy the region from the cursor position to the endpoint of the movement into the kill buffer. If the command is vi-yank, copy the current line.
- **vi-yank-whole-line** (unbound) (Y) (unbound)
    Copy the current line into the kill buffer.
- **vi-yank-eol**
    Copy the region from the cursor position to the end of the line into the kill buffer. Arguably, this is what Y should do in vi, but it isn't what it actually does.

### Arguments

- **digit-argument** (ESC-0...ESC-9) (1-9) (unbound)
    Start a new numeric argument, or add to the current one. See also vi-digit-or-beginning-of-line.
- **neg-argument** (ESC--) (unbound) (unbound)
    Changes the sign of the following argument.
- **universal-argument**
    Multiply the argument of the next command by 4.

### Completion

- **accept-and-menu-complete**
    In a menu completion, insert the current completion into the buffer, and advance to the next possible completion.
- **complete-word**
    Attempt completion on the current word.
- **delete-char-or-list** (^D) (unbound) (unbound)
    Delete the character under the cursor. If the cursor is at the end of the line, list possible completions for the current word.
- **expand-cmd-path**
    Expand the current command to its full pathname.
- **expand-or-complete** (TAB) (unbound) (TAB)
    Attempt shell expansion on the current word. If that fails, attempt completion.
- **expand-or-complete-prefix**
    Attempt shell expansion on the current word up to cursor.
- **expand-history** (ESC-SPACE ESC-!) (unbound) (unbound)
    Perform history expansion on the edit buffer.
- **expand-word** (^X\*) (unbound) (unbound)
    Attempt shell expansion on the current word.
- **list-choices** (ESC-^D) (^D=) (^D)
    List possible completions for the current word.
- **list-expand** (^Xg ^XG) (^G) (^G)
    List the expansion of the current word.
- **magic-space**
    Perform history expansion and insert a space into the buffer. This is intended to be bound to SPACE.
- **menu-complete**
    Like complete-word, except that menu completion is used. See section Options, for the MENU_COMPLETE option.
- **menu-expand-or-complete**
    Like expand-or-complete, except that menu completion is used.
- **reverse-menu-complete**
    See section Options, for the MENU_COMPLETE option.

### Miscellaneous

- **accept-and-hold** (ESC-A ESC-a) (unbound) (unbound)
    Push the contents of the buffer on the buffer stack and execute it.
- **accept-and-infer-next-history**
    Execute the contents of the buffer. Then search the history list for a line matching the current one and push the event following onto the buffer stack.
- **accept-line** (^J ^M) (^J ^M) (^J ^M)
    Execute the contents of the buffer.
- **accept-line-and-down-history** (^O) (unbound) (unbound)
    Execute the current line, and push the next history event on the the buffer stack.
- **vi-cmd-mode** (^X^V) (unbound) (^[)
    Enter command mode; that is, use the alternate keymap. Yes, this is bound by default in emacs mode.
- **vi-caps-lock-panic**
    Hang until any lowercase key is pressed. This is for vi users without the mental capacity to keep track of their caps lock key (like the author).
- **clear-screen** (^L ESC-^L) (^L) (^L)
    Clear the screen and redraw the prompt.
- **describe-key-briefly**
    Waits for keypress, then prints the function bound to the pressed key.
- **exchange-point-and-mark** (^X^X) (unbound) (unbound)
    Exchange the cursor position with the position of the mark.
- **execute-named-cmd** (ESC-x) (unbound) (unbound)
    Read the name of a editor command and execute it. A restricted set of editing functions is available in the mini-buffer. An interrupt signal, as defined by the stty setting, will abort the function. The allowed functions are: backward-delete-char, vi-backward-delete-char, clear-screen, redisplay, quoted-insert, vi-quoted-insert, kill-region (kills the last word), backward-kill-word, vi-backward-kill-word, kill-whole-line, vi-kill-line, backward-kill-line, list-choices, delete-char-or-list, complete-word, expand-or-complete, expand-or-complete-prefix, accept-line, and vi-cmd-mode (treated the same as accept line). The SPC and TAB characters, if not bound to one of these functions, will complete the name and then list the possibilities if the AUTO_LIST option is set. Any string that is bound to an out-string (via bindkey -s) will behave as if out-string were typed directly. Any other character that is not bound to self-insert or self-insert-unmeta will beep and be ignored. If the function is called from vi command mode, the bindings of the current insert mode will be used.
- **execute-last-named-cmd** (ESC-z) (unbound) (unbound)
    Redo the last function executed with execute-named-cmd.
- **get-line** (ESC-G ESC-g) (unbound) (unbound)
    Pop the top line off the buffer stack and insert it at the cursor position.
- **pound-insert** (unbound) (#) (unbound)
    If there is no # character at the beginning of the buffer, add one to the beginning of each line. If there is one, remove a # from each line that has one. In either case, accept the current line. The INTERACTIVE_COMMENTS option must be set for this to have any usefulness.
- **vi-pound-insert**
    If there is no # character at the beginning of the current line, add one. If there is one, remove it. The INTERACTIVE_COMMENTS option must be set for this to have any usefulness.
- **push-input**
    Push the entire current multi-line construct onto the buffer stack and return to the top-level (PS1) prompt. If the current parser construct is only a single line, this is exactly like push-line. Next time the editor starts up or is popped with get-line, the construct will be popped off the top of the buffer stack and loaded into the editing buffer.
- **push-line** (^Q ESC-Q ESC-q) (unbound) (unbound)
    Push the current buffer onto the buffer stack and clear the buffer. Next time the editor starts up, the buffer will be popped off the top of the buffer stack and loaded into the editing buffer.
- **push-line-or-edit**
    At the top-level (PS1) prompt, equivalent to push-line. At a secondary (PS2) prompt, move the entire current multi-line construct into the editor buffer. The latter is equivalent to push-line followed by get-line.
- **redisplay** (unbound) (^R) (^R)
    Redisplays the edit buffer.
- **send-break** (^G ESC-^G) (unbound) (unbound)
    Abort the current editor function, e.g. execute-named-command, or the editor itself, e.g. if you are in vared. Otherwise abort the parsing of the current line.
- **run-help** (ESC-H ESC-h) (unbound) (unbound)
    Push the buffer onto the buffer stack, and execute the command run-help cmd, where cmd is the current command. run-help is normally aliased to man.
- **vi-set-buffer** (unbound) (") (unbound)
    Specify a buffer to be used in the following command. There are 35 buffers that can be specified: the 26 named buffers "a to "z and the nine queued buffers "1 to "9. The named buffers can also be specified as "A to "Z. When a buffer is specified for a cut command, the text being cut replaces the previous contents of the specified buffer. If a named buffer is specified using a capital, the newly cut text is appended to the buffer instead of overwriting it. If no buffer is specified for a cut command, "1 is used, and the contents of "1 to "8 are each shifted along one buffer; the contents of "9 is lost.
- **vi-set-mark** (unbound) (m) (unbound)
    Set the specified mark at the cursor position.
- **set-mark-command** (^@) (unbound) (unbound)
    Set the mark at the cursor position.
- **spell-word** (ESC-$ ESC-S ESC-s) (unbound) (unbound)
    Attempt spelling correction on the current word.
- **undefined-key** (lots o' keys) (lots o' keys) (unbound)
    Beep.
- **undo** (^\_ ^Xu ^X^U) (unbound) (unbound)
    Incrementally undo the last text modification.
- **vi-undo-change** (unbound) (u) (unbound)
    Undo the last text modification. If repeated, redo the modification.
- **where-is**
    Read the name of an editor command and and print the listing of key sequences that invoke the specified command.
- **which-command** (ESC-?) (unbound) (unbound)
    Push the buffer onto the buffer stack, and execute the command which-command cmd, where cmd is the current command. which-command is normally aliased to whence.
- **vi-digit-or-beginning-of-line(unbound)** (0) (unbound)
    If the last command executed was a digit as part of an argument, continue the argument. Otherwise, execute vi-beginning-of-line.
