#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------------
#  *                              Gist Manager using GitHub CLI                                 *
#
#    Author: uwbfritz
#    Description: Gist manager using GitHub CLI
#    Last Modified: 2024-08-20
#
#---------------------------------------------------------------------------------------------------

gist_editor="micro"
export EDITOR=$gist_editor

clear

main_menu() {
  echo -e "1. \033[32mCreate a new gist\033[0m\n2. \033[34mList and edit a gist\033[0m\n3. \033[31mDelete a gist\033[0m" |
    fzf --height 80% --border --ansi --prompt "Choose an option: " --with-nth=2..
}

create_gist() {
  tmpfile=$(mktemp /tmp/gist_XXXXXX.md)
  echo -e "\033[33mWrite your gist content. Save and exit" $gist_editor "when done.\033[0m"
  $gist_editor "$tmpfile"

  if [ -s "$tmpfile" ]; then
    echo -e "\033[33mEnter a description for the gist: \033[0m"
    read -r description

    echo -e "\033[33mDo you want this gist to be public? (y/N)\033[0m"
    read -r is_public

    if [[ "$is_public" =~ ^[Yy]$ ]]; then
      gh gist create "$tmpfile" --desc "$description" --public
    else
      gh gist create "$tmpfile" --desc "$description"
    fi

    echo -e "\033[32mGist created successfully.\033[0m"
  else
    echo -e "\033[31mGist creation aborted: No content provided.\033[0m"
  fi

  rm "$tmpfile"
}

edit_gist() {
  selected_gist=$(gh gist list -L 500 |
    fzf --height 80% --border --ansi --preview 'gh gist view {1}' --preview-window=right:60%:wrap --layout=reverse --info=inline --header='Select a gist to edit')

  if [ -n "$selected_gist" ]; then
    gist_id=$(echo "$selected_gist" | awk '{print $1}')
    gh gist edit "$gist_id"
  else
    echo -e "\033[31mNo gist selected\033[0m"
  fi
}

delete_gist() {
  selected_gist=$(gh gist list -L 500 |
    fzf --height 80% --border --ansi --preview 'gh gist view {1}' --preview-window=right:60%:wrap --layout=reverse --info=inline)

  if [ -n "$selected_gist" ]; then
    gist_id=$(echo "$selected_gist" | awk '{print $1}')
    echo -e "\033[31mAre you sure you want to delete this gist? (y/N)\033[0m"
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      gh gist delete "$gist_id"
      echo -e "\033[32mGist deleted\033[0m"
    else
      echo -e "\033[33mDeletion aborted\033[0m"
    fi
  else
    echo -e "\033[31mNo gist selected\033[0m"
  fi
}

if [ $# -gt 0 ]; then
  case $1 in
  "list")
    gh gist list -L 500
    exit
    ;;
  "edit")
    edit_gist
    exit
    ;;
  "delete")
    delete_gist
    exit
    ;;
  *)
    echo -e "\033[31mInvalid argument\033[0m"
    echo -e "Valid options are:\n1. list\n2. edit\n3. delete"
    exit
    ;;
  esac
fi

selection=$(main_menu)

case $selection in
"1. Create a new gist" | "1")
  create_gist
  ;;
"2. List and edit a gist" | "2")
  edit_gist
  ;;
"3. Delete a gist" | "3")
  delete_gist
  ;;
*)
  echo -e "\033[31mInvalid selection\033[0m"
  ;;
esac
