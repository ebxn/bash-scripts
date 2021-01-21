# get eslint (and prettier) plugins for a specified framework
get_plugins () {
  local plugins

  if [ "$1" = "vue" ] || [ "$1" = "gridsome" ]; then
    plugins=("babel-eslint eslint-plugin-vue")
    plugins+=("prettier" "eslint-plugin-prettier @vue/eslint-config-prettier")
  elif [ "$1" = "react" ] || [ "$1" = "next" ]; then
    plugins=("babel-eslint" "eslint-plugin-react" "eslint-plugin-react-hooks" "eslint-plugin-jsx-a11y")
    plugins+=("prettier" "eslint-plugin-prettier" "eslint-config-prettier")
  else
    plugins=()
  fi

  # return
  echo "${plugins[@]}"
}

# get .eslintrc modifications required
get_mods () {
  local mods

  echo "getting mods"

  if [ "$1" = "react" ] || [ "$1" = "next" ]; then
    mods="${color_blue}Add the following to \`.eslintrc.js\`:${color_none}\
    \n  extends: [\
    \n    \"plugin:react/recommended\",\
    \n    \"plugin:react-hooks/recommended\",\
    \n    \"plugin:jsx-a11y/recommended\",\
    \n    \"prettier\",\
    \n    \"prettier/react\",\
    \n  ],\
    \n  parser: \"babel-eslint\""
  elif [ "$1" = "vue" ] || [ "$1" = "gridsome" ]; then
    mods="${color_blue}Add the following to \`.eslintrc.js\`:${color_none}\
    \n  extends: [\
    \n    \"plugin:vue/essential\",\
    \n    \"plugin:prettier/recommended\",\
    \n    \"@vue/prettier\"\
    \n  ],\
    \n  parserOptions: {,\
    \n    parser: \"babel-eslint\","
  else
    mods=""
  fi

  #return
  echo "$mods"
}

esl () {
  local color_blue='\033[0;36m'
  local color_none='\033[0m'
  local plugins
  local mods

  # get plugins
  plugins=( $(get_plugins $1) )

  # exit if no plugins found
  if [ ${#plugins[@]} -eq 0 ]; then
    return
  fi

  # get .eslintrc modifications for framework
  mods=$(get_mods $1)

  # convert plugins array into comma separated string
  printf -v plugins_str "${color_blue}%s${color_none}, " "${plugins[@]}"

  # print list of plugins to be installed
  echo "Installing ESLint plugins. This may take a little while."
  echo -e "Installing $(echo ${plugins_str%, } | sed 's/\(.*\),\(.*\)/\1 and\2.../')\n"

  # install all plugins
  yarn add -D -s ${plugins[@]}

  # ask whether or not to run eslint --init
  read -n 1 -s -p "$( echo -e "\n${color_blue}Initialise ESLint${color_none} (y/N)${color_blue}?${color_none}" )" init_eslint
  case "$init_eslint" in
    y|Y ) echo -e "\n"; eslint --init;;
    * ) echo;;
  esac

  # if any modifications need to be made, print them
  if [ -n "$mods" ]; then
    echo -e "\nInstallation complete! Please make the following modifications:\n"
    echo -e "$mods"
  else
    echo -e "\nInstallation complete!"
  fi
}

# retaining in case of future upgrades
# [OLD] get language dependent eslint plugins and mods for each argument
# plugins = get_esl_plugins $1
# while [ -n "$1" ]; do
#   plugins=( $(get_esl_plugins $1) ${plugins[@]} )
#   mods="$(get_esl_mods $1)$mods"
#   shift
# done
