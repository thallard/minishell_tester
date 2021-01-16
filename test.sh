# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thallard <thallard@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/13 20:16:23 by thallard          #+#    #+#              #
#    Updated: 2021/01/16 15:21:55 by thallard         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

GREEN='\033[0;32m'
RED='\033[0;31m'
REDB='\033[1;31m'
BLANK='\033[0m'
YELLOW='\033[0;33m'

PATH_Makefile=..
PATH_executable=../minishell
# Variables
i=1
FILE_TO_READ=
RUN=1

# Check if 0 arguments is set 
if [ "$1" == "help" ]; then
    printf "How to use this tester ?\n"
    printf "    use ${YELLOW}\"bash test.sh [--diff] <name_command>\"${BLANK} to run a specific builtin command test (echo, unset, export, etc...).\n\n"
    printf "    flag ${YELLOW}[--diff]${BLANK} allow when its enabled to see difference between your minishell results and real bash,
    without this flag enabled you will only see if the test is correct.\n\n"
    printf "    use ${YELLOW}\"bash test.sh all\"${BLANK} to run all commands test in the same time.\n"
    exit
fi

# Check if Makefile and minishell executable exists in the parent folder
# if [[ -f "$PATH_Makefile/Makefile" ]]; then
# 	make all -C ..
# else
# 	printf "\033[1;31mError : Makefile doesn't found with the path : \"$PATH_Makefile\", please be sure to change the variable \"PATH_Makefile\" or to move your Makefile in the right folder.\n"
# 	RUN=0
# fi
# if [[ -f "$PATH_executable" ]]; then
# 	cp "$PATH_executable" . 
# else
# 	printf "\033[1;31mError : Executable \"minishell\" doesn't found with the path : \""$PATH_executable"\", please be sure to change the variable \""$PATH_executable"\" or to move your executable in the right folder.\n"
# 	RUN=0
# fi

# Run main program if all the checks are done
if [ "$RUN" == "1" ]; then
	# Read inputs files for cat command
	if [ -z "$1" ]; then
		printf "\033[1;32mYou choose to run all tests.${BLANK}\n\n"
		FILE_TO_READ="file_tests/echo_tests.txt"
		sleep 2
	else
		for var in "$@"
		do
			FILE_TO_READ="$FILE_TO_READ $(find file_tests -name "$var?*" -print)"
		done
	fi
	# Built-in echo checker
	cat $FILE_TO_READ | while read line
		do
			BASH_RESULT=$(echo $line "; exit"| bash 2>&-)
			BASH_EXIT=$?
			MINISHELL_RESULT=$(echo $line "; exit"| ./minishell 2>&-)
			MINISHELL_EXIT=$?
			if [ "$1" == "--diff" ]; then
				if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
						printf "${GREEN}$i: $line\n"
						echo $line >> tmp
				else
					if [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
						printf "${RED}$i: [$line]\nbash: [$BASH_RESULT]${GREEN}[$BASH_EXIT]${RED}\nminishell: [$MINISHELL_RESULT]${GREEN}[$MINISHELL_EXIT]\n"
					else
						printf "${RED}$i: [$line]\nbash: [$BASH_RESULT][$BASH_EXIT] | minishell: [$MINISHELL_RESULT][$MINISHELL_EXIT]\n"
					fi
				fi
			else
				if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
					printf "${GREEN}$i: [$line]\n"
					echo $line >> tmp
				else
					printf "${RED}$i: [$line]\n"
				fi
			fi
			i=$((i + 1))
		done
	if [ "$1" == "echo" ] || [ "$2" == "echo" ]; then
		printf "\n${GREEN}Built-in echo result : $(cat tmp | wc -l | xargs)/$(cat file_tests/echo_tests.txt | wc -l | xargs) tests passed\n"
		rm -rf tmp
	elif [ "$2" == "export" ]; then
		printf "\n${GREEN}Built-in export result : $(cat tmp | wc -l | xargs)/$(cat file_tests/echo_tests.txt | wc -l | xargs) tests passed\n"
		rm -rf tmp
	fi
fi