let g:gitblame_enabled = 0
let g:neoformat_try_node_exe = 1
let g:loaded_perl_provider = 0


" Cht.sh setup config
let g:syntastic_javascript_checkers = [ 'jshint' ]
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_shell_checkers = ['shellcheck']
let g:cheat_default_window_layout = 'split'


let g:python3_host_prog="/Users/adammomen/.local/share/virtualenvs/server-b6jBK0gV/bin/python3"
let g:python_host_prog="/Users/adammomen/.local/share/virtualenvs/server-b6jBK0gV/bin/python"

let g:vim_be_good_log_file = 1
let g:vim_apm_log = 1

if executable('rg')
    let g:rg_derive_root='true'
endif

let loaded_matchparen = 1

let g:bujo#todo_file_path = $HOME . "/.cache/bujo"
