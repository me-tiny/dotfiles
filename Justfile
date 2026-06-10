dots := justfile_directory()

default:
    @just --list

link:
    stow --verbose --target=$HOME --dir={{dots}} --restow */

one pkg:
    stow --verbose --target=$HOME --dir={{dots}} --restow {{pkg}}

unlink:
    stow --verbose --target=$HOME --dir={{dots}} --delete */
