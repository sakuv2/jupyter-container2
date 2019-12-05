
# Options
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream "informative"

# Colors
set green (set_color green)
set magenta (set_color magenta)
set normal (set_color normal)
set red (set_color red)
set yellow (set_color yellow)

set __fish_git_prompt_color_branch magenta --bold
set __fish_git_prompt_color_dirtystate white
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_merging yellow
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red


# Icons
set __fish_git_prompt_char_cleanstate '✔ '
set __fish_git_prompt_char_conflictedstate '𝓒 '
set __fish_git_prompt_char_dirtystate '𝓜 '
set __fish_git_prompt_char_invalidstate ' 🤮  '
set __fish_git_prompt_char_stagedstate '𝓢 '
set __fish_git_prompt_char_stashstate ' 📦  '
set __fish_git_prompt_char_stateseparator '|'
set __fish_git_prompt_char_untrackedfiles '𝓐 '
set __fish_git_prompt_char_upstream_ahead '𝓤 '
set __fish_git_prompt_char_upstream_behind '𝓓 '
set __fish_git_prompt_char_upstream_diverged ' 🚧  '
set __fish_git_prompt_char_upstream_equal ' 💯 ' 


function fish_prompt
  set last_status $status

  set_color cyan
  printf '%s' $USER'@jupyter '
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)
#   echo -n "🐠  "
  echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '
  set_color normal
end

function fish_right_prompt --description '右側に pwd と git status を表示'
#   __fish_git_prompt
  echo (date "+%Y/%m/%d %H:%M:%S")
end