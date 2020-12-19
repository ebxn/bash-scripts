# emulate vue project creation for create-react-app
react () {
  if [ "$1" = "create" ]; then 
    create-react-app ${@:2}
  else 
    create-react-app ${@:1}
  fi
}


# emulate vue project creation for create-next-app
next () {
  if [ "$1" = "create" ]; then 
    create-next-app ${@:2}
  else 
    create-next-app ${@:1}
  fi
}
