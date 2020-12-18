# emulate vue project creation for react/next
react () {
  if [ "$1" = "create" ]; then 
    create-react-app ${@:2}
  else 
    create-react-app ${@:1}
  fi
}

next () {
  if [ "$1" = "create" ]; then 
    create-next-app ${@:2}
  else 
    create-next-app ${@:1}
  fi
}

