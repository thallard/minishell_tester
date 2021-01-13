# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thallard <thallard@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/13 20:16:23 by thallard          #+#    #+#              #
#    Updated: 2021/01/13 23:17:48 by thallard         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

GREEN='\033[1;32m'
RED='\033[0;31m'
BLANK='\033[0m'
YELLOW='\033[0;33m'
cp ../minishell .

# ECHO PART
correct=0
i=1
cat tests/echo_tests.txt | while read line
    do
        BASH_RESULT=$(echo $line "; exit" | bash 2>&-)
        BASH_EXIT=$?
        MINISHELL_RESULT=$(echo $line "; exit" | ./minishell 2>&-)
        MINISHELL_EXIT=$?
        if [ "$line" == "Echo part without -n flag" ]; then
            printf "${GREEN}$line\n\n" 
        else
            if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ]; then
                if [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
                    printf "${GREEN}$i: $line\n"
                    correct=$((correct + 1))
                fi
            else
                if [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
                    printf "${RED}$i: [$line]\nbash: [$BASH_RESULT]${GREEN}[$BASH_EXIT]${RED} | minishell: [$MINISHELL_RESULT]${GREEN}[$MINISHELL_EXIT]\n"
                else
                    printf "${RED}$i: [$line]\nbash: [$BASH_RESULT][$BASH_EXIT] | minishell: [$MINISHELL_RESULT][$MINISHELL_EXIT]\n"
                fi
            fi
        fi
        i=$((i + 1))
    done
printf "\n${GREEN}Conclusion : $correct/$i\n"