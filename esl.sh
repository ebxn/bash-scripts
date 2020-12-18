# get a list of eslint plugins for a specified language
get_esl_plugins () {
  local esl_plugins=()
  local react_base_plugins=(
    "eslint-plugin-react"
    "eslint-plugin-react-hooks"
    "eslint-plugin-jsx-a11y"
    "eslint-plugin-prettier"
    "eslint-config-prettier"
  )
  
  if [ "$1" = "react" ]; then
    esl_plugins=(${react_base_plugins[@]})
  elif [ "$1" = "next" ]; then
    esl_plugins=("babel-eslint" ${react_base_plugins[@]})
  elif [ "$1" = "native" ] || [ "$1" = "react-native" ] || [ "$1" = "reactnative" ]; then
    esl_plugins=("babel-eslint" "eslint-plugin-react-native" ${react_base_plugins[@]})
  elif [ "$1" = "standard" ]; then
    esl_plugins=("eslint-config-standard" "eslint-plugin-promise" "eslint-plugin-import" "eslint-plugin-node")
  elif [ "$1" = "import-sort" ] || [ "$1" = "importsort" ]; then
    esl_plugins=("eslint-plugin-simple-import-sort")      
  fi
  
  # return
  echo ${esl_plugins[@]}
}

esl () {
  local color_blue='\033[0;36m'
  local color_none='\033[0m'
  local plugins=()
  local eslint_mods=()
  
  # get language dependent eslint plugins
  plugins=( $(get_esl_plugins $1) )
  
  # get language dependent modifications (if any)
  if [ "$1" = "react" ] || [ "$1" = "next" ] || [ "$1" = "native" ]; then
    eslint_mods="${color_blue}Add the following to \`.eslintrc.js\`'s extend:${color_none}\
      \n  \"eslint:recommended\",\
      \n  \"plugin:react/recommended\",\
      \n  \"plugin:react-hooks/recommended\",\
      \n  \"plugin:jsx-a11y/recommended\",\
      \n  \"plugin:prettier/recommended\""
  fi

  # convert deps array into comma separated string
  printf -v plugins_str "${color_blue}%s${color_none}, " "${plugins[@]}"
  
  echo "Installing ESLint plugins. This may take a little while."
  echo -e "Installing $(echo ${plugins_str%, } | sed 's/.*,\(.*\)/\0 and\1.../')" 
  
  # install all plugins, hiding any "warnings" (yarn's --silent is great!)
  yarn add -D -s ${plugins[@]} 2> >(grep -v warning 1>&2)
  
  # if any modifications need to be made, print them
  if [ ! -z eslint_mods ]; then
    echo -e "Installation complete! Please make the following modifications:\n"
    echo -e "${eslint_mods}"
  fi
}

