# get a list of eslint plugins for a specified language
get_esl_plugins () {
  local esl_plugins
  local react_base_plugins=("eslint-plugin-react" "eslint-plugin-react-hooks" "eslint-plugin-jsx-a11y")

  if [ "$1" = "init" ]; then
    esl_plugins=("eslint")
  elif [ "$1" = "prettier" ] || [ "$1" = "pretty" ]; then
    esl_plugins=("prettier" "eslint-plugin-prettier" "eslint-config-prettier")
  elif [ "$1" = "react" ]; then
    esl_plugins=(${react_base_plugins[@]})
  elif [ "$1" = "next" ]; then
    esl_plugins=("babel-eslint" ${react_base_plugins[@]})
  elif [ "$1" = "native" ] || [ "$1" = "react-native" ] || [ "$1" = "reactnative" ]; then
    esl_plugins=("babel-eslint" "eslint-plugin-react-native" ${react_base_plugins[@]})
  elif [ "$1" = "standard" ]; then
    esl_plugins=("eslint-config-standard" "eslint-plugin-promise" "eslint-plugin-import" "eslint-plugin-node")
  elif [ "$1" = "import-sort" ] || [ "$1" = "importsort" ]; then
    esl_plugins=("eslint-plugin-simple-import-sort") 
  else  
    esl_plugins=() 
  fi

  # return
  echo ${esl_plugins[@]}
}

get_esl_mods () {
  local esl_mods=""
  
  if [ "$1" = "react" ] || [ "$1" = "next" ] || [ "$1" = "native" ] || [ "$1" = "react-native" ] || [ "$1" = "reactnative" ]; then
    esl_mods="${color_blue}Add the following to \`.eslintrc.js\`'s extend:${color_none}\
      \n  \"plugin:react/recommended\",\
      \n  \"plugin:react-hooks/recommended\",\
      \n  \"plugin:jsx-a11y/recommended\",\
      \n  \"prettier\",\
      \n  \"prettier/react\""
  fi
  
  #return
  echo "$esl_mods"
}

esl () {
  local color_blue='\033[0;36m'
  local color_none='\033[0m'
  local plugins=()
  local mods=""

  # get language dependent eslint plugins and mods for each argument
  while [ -n "$1" ]; do
    plugins=( $(get_esl_plugins $1) ${plugins[@]} )
    mods="$(get_esl_mods $1)$mods"
    shift
  done

  # convert plugins array into comma separated string
  printf -v plugins_str "${color_blue}%s${color_none}, " "${plugins[@]}"

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
