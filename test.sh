# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thallard <thallard@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/13 20:16:23 by thallard          #+#    #+#              #
#    Updated: 2021/01/14 23:08:07 by thallard         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

GREEN='\033[0;32m'
RED='\033[0;31m'
BLANK='\033[0m'
YELLOW='\033[0;33m'
cp ../minishell .
make all -C ..

# Variables
i=1

# Check if 0 arguments is set 
if [ "$1" == "help" ]; then
    printf "How to use this tester ?\n"
    printf "    use ${YELLOW}\"bash test.sh [--diff] <name_command>\"${BLANK} to run a specific builtin command test (echo, unset, export, etc...).\n\n"
    printf "    flag ${YELLOW}[--diff]${BLANK} allow when its enabled to see difference between your minishell results and real bash,
    without this flag enabled you will only see if the test is correct.\n\n"
    printf "    use ${YELLOW}\"bash test.sh all\"${BLANK} to run all commands test in the same time.\n"
    exit
fi
# Built-in echo checker

cat file_tests/echo_tests.txt | while read line
    do
        BASH_RESULT=$(echo $line "; exit" | bash 2>&-)
        BASH_EXIT=$?
        MINISHELL_RESULT=$(echo $line "; exit" | ./minishell 2>&-)
        MINISHELL_EXIT=$?
        if [ "$1" == "--diff" ]; then
            if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
                    printf "${GREEN}$i: $line\n"
                    echo $line >> tmp/file
            else
                if [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
                    printf (${RED}$i: [$line]\nbash: [$BASH_RESULT]${GREEN}[$BASH_EXIT]${RED}\nminishell: [$MINISHELL_RESULT]${GREEN}[$MINISHELL_EXIT]\n"
                else
                    printf "${RED}$i: [$line]\nbash: [$BASH_RESULT][$BASH_EXIT] | minishell: [$MINISHELL_RESULT][$MINISHELL_EXIT]\n"
                fi
            fi
        else
            if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
                printf "${GREEN}$i: [$line]\n"
                echo $line >> tmp/file
            else
                printf "${RED}$i: [$line]\n"
            fi
        fi
        i=$((i + 1))
    done

if [ "$1" == "echo" ] || [ "$2" == "echo" ]; then
    printf "\n${GREEN}Built-in echo result : $(cat tmp/file | wc -l | xargs)/$(cat file_tests/echo_tests.txt | wc -l | xargs) tests passed\n"
    rm -rf tmp/file
elif [ "$2" == "export" ]; then
    printf "\n${GREEN}Built-in export result : $(cat tmp/file | wc -l | xargs)/$(cat file_tests/echo_tests.txt | wc -l | xargs) tests passed\n"
    rm -rf tmp/file
fi

