# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thallard <thallard@student.42lyon.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/13 20:16:23 by thallard          #+#    #+#              #
#    Updated: 2021/06/23 14:47:54 by thallard         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

# Colors variables
GREEN='\033[0;32m'
GREENB='\033[1;32m'
RED='\033[0;31m'
REDB='\033[1;31m'
BLANK='\033[0m'
YELLOW='\033[0;33m'

# ----------------------- MODIFY THESE VARIABLES ----------------------------
# Please modify this variable if your Makefile or your minishell executable is not found
PATH_Makefile=..
PATH_executable=..

# Variables
i=1
FILE_TO_READ=
RUN=1
DIFF_FLAGS=0
SHORT=0
ALL=0
SPEED=0.09
VALGRIND=

# Check if 0 arguments is set 
if [ "$1" == "help" ]; then
    printf "How to use this tester ?\n"
    printf "    use ${YELLOW}\"bash test.sh [--diff] [--fast] [--short] [--valgrind] <name_file> ...\"${BLANK} to run a specific built-in command test (echo, unset, export, etc...).\n"
	printf "    use ${YELLOW}\"bash test.sh all\"${BLANK} to run all commands test at the same time.\n\n"
    printf "    flag ${YELLOW}[--diff]${BLANK}or ${YELLOW}[-d] allow when its enabled to see the difference(s) between your minishell results and real bash ones, without this flag enabled you will only see if the test is correct.\n"
	printf "    flag ${YELLOW}[--fast] ${BLANK}or ${YELLOW}[-f] ${BLANK}allow to increase the delay between each test.\n"
	printf "    flag ${YELLOW}[--short] ${BLANK}or ${YELLOW}[-s] ${BLANK}make all valids tests on one line.\n"
	printf "    flag ${YELLOW}[--valgrind] ${BLANK}or ${YELLOW}[-v] ${BLANK}enable leaks checking (Valgrind works only on Linux OS, check this to use it: https://github.com/grouville/valgrind_42.\n\n"
	printf "All files availables for tests :\n"
	printf "${YELLOW}$(find file_tests -type f -name "*.txt" -exec basename {} .po \;)\n"
    exit
fi

# Check if Makefile and minishell executable exists in the parent folder
if [[ -f "$PATH_Makefile/Makefile" ]]; then
	{
		make all -C $PATH_Makefile
	} > tmp/errors_makefile
	if [ -z "$(cat tmp/errors_makefile | grep error)" ]; then
		printf "${GREENB}Makefile successfully created, your executable minishell is ready.\n"
	else 
		printf "\033[1;31mError : Makefile can't compile, check above errors.\n"
		RUN=0
	fi
else
	printf "\033[1;31mError : Makefile doesn't found with the path : \"$PATH_Makefile\", please be sure to change the variable \"PATH_Makefile\" or to move your Makefile in the right folder.\n"
	RUN=0
fi
if [[ -f "$PATH_executable/minishell" ]]; then
	cp $PATH_executable/minishell . 
else
	printf "\033[1;31mError : Executable \"minishell\" doesn't found with the path : \""$PATH_executable/minishell"\", please be sure to change the variable \"PATH_executable\" or to move your executable in the right folder.\n"
	RUN=0
fi

# Run main program if all the checks are done
if [ "$RUN" == "1" ]; then
	# Read inputs files for cat command
	if [ -z "$1" ]; then
		printf "${GREENB}You have chosen  to run all tests without ${YELLOW}[--diff]${GREENB} (differences between minishell and bash results).${BLANK}\n\n"
		FILE_TO_READ="$(find file_tests -type f -name "*.txt" -print)"
		ALL=1
		sleep 2
	else
		for var in "$@"
		do
			# Compatibility part
			if [ "$var" == "compatibility" ]; then
				BASH_RESULT=$(bash -c "echo Its working!")
				BASH_EXIT=$?
				MINISHELL_RESULT=$(./minishell -c "echo Its working!")
				MINISHELL_EXIT=$?
				if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
					printf "${GREEN}$MINISHELL_RESULT\n"
					printf "The tester and your minishell is now working together, good job ! You can start use standard commands right now.\n"
				else
					printf "${RED}The tester is not working with your minishell, check the \"Get Started\" part of the repository : https://github.com/thallard/minishell_tester.\n"
					printf "Your result     : [${MINISHELL_RESULT}] and exit status : $MINISHELL_EXIT\n"
					printf "Expected result : [${BASH_RESULT}] and exit status : $BASH_EXIT\n"
				fi 
				RUN=0
				break
			elif [ "$var" == "--diff" ] || [ "$var" == "-d" ]; then
				DIFF_FLAGS=1
			elif [ "$var" == "--short" ] || [ "$var" == "-s" ]; then
				SHORT=1
			elif [ "$var" == "--fast" ] || [ "$var" == "-f" ]; then
				SPEED=0.001
			elif [ "$var" == "--valgrind" ] || [ "$var" == "-v" ]; then
				VALGRIND="valgrind -q --leak-check=full"
			else
				if [ "$var" == "all" ]; then
					FILE_TO_READ="$(find file_tests -type f -name "*.txt" -print)"
					if [ -z "$(find file_tests -type f -name "*.txt" -print)" ]; then
						printf "${REDB}Error, 0 files founded in ./file_tests with \"all\" tag, be sure you don\'t have deleted ./file_tests content.\n"
						exit
					fi
					ALL=1
					break 
				else
					FILE_TO_READ="$FILE_TO_READ $(find file_tests -name "$var?*" -print)"
					if [ -z "$(find file_tests -name "$var?*" -print)" ]; then
						printf "${REDB}Error, 0 files founded with \"${var}\" tag, use for example \"echo\" to run echo tests.\n\n"
						printf "${BLANK}Below, there are the list of files available (in file_tests folder) :\n"
						find file_tests -type f -name "*.txt" -exec basename {} .po \; | cut -d '.' -f1 | while read line; do
							printf "${BLANK}-  ${YELLOW}$line\n"
						done
						exit
					fi
				fi
			fi
		done
	fi
	# Added all files if 0 files name or "all" is specified
	if [ "$ALL" == "0" ] && [ -z "$FILE_TO_READ" ]; then
		FILE_TO_READ="$(find file_tests -type f -name "*.txt")"
		if [ -z "$(find file_tests -type f -name "*.txt" -print)" ]; then
			printf "${REDB}Error, 0 files founded in ./file_tests with \"all\" tag, be sure you don\'t have deleted ./file_tests content.\n"
			exit
		fi
		ALL=1
	fi
	# Last check before main process (little message for valgrind utilisation)
	if [[ ! -z "$VALGRIND" ]]; then
		printf "${GREENB}You have activated ${YELLOW}[--valgrind]${GREENB} flag, care it's only work with a Linux architecture.\n"
		sleep 2
	fi
	echo -n > tofix/tofix_tests.txt
	echo -n > tmp/tmp
	# Main process checking each line and compare minishell executable + bash results
	if [ "$RUN" == "1" ]; then
		cat $FILE_TO_READ | while read line
			do
				if [ "$line" == "\n" ]; then
					continue
				elif [ "$(printf '%s' "$line" | cut -c1)" == "-" ] && [ "$SPEED" == "0.09" ]; then
					printf "\n${GREENB}${line}\n"
					sleep 1
					continue 
				elif [ "$(printf '%s' "$line" | cut -c1)" == "-" ] && [ "$SPEED" == "0.001" ]; then
					printf "\n${GREENB}${line}\n"
					continue 
				fi
				# If Valgrind flags is enabled, run tests with valgrind
				BASH_RESULT=$(bash -c "$line")
				BASH_EXIT=$?
				# Remove temp files if they exists
				rm -f tmp/file tmp/file1 tmp/file2 2>/dev/null
				MINISHELL_RESULT=$($VALGRIND ./minishell -c "$line")
				MINISHELL_EXIT=$?
				if [ "$DIFF_FLAGS" == "1" ]; then
					if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
							if [ "$SHORT" == "1" ]; then
								printf "\033[?25l\033[J${GREEN}$i: $line\033[0m\r"
							else
								printf "${GREEN}$i: $line\n"
							fi
							echo $line >> tmp/valid
					else
						if [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
							printf "${RED}$i:        [$line]\nbash     : [$BASH_RESULT]${GREEN}[$BASH_EXIT]${RED}\nminishell: [$MINISHELL_RESULT]${GREEN}[$MINISHELL_EXIT]\n"
							echo $line >> tofix/tofix_tests.txt
						else
							printf "${RED}$i:        [$line]\nbash     : [$BASH_RESULT][$BASH_EXIT]\nminishell: [$MINISHELL_RESULT][$MINISHELL_EXIT]\n"
							echo $line >> tofix/tofix_tests.txt
						fi
					fi
				else
					if [ "$BASH_RESULT" == "$MINISHELL_RESULT" ] && [ "$BASH_EXIT" == "$MINISHELL_EXIT" ]; then
						if [ "$SHORT" == "1" ]; then
							printf "\033[?25l\033[J${GREEN}$i: $line\033[0m\r"
						else
							printf "${GREEN}$i: $line\n"
						fi
						echo $line >> tmp/valid
					else
						printf "${RED}$i: [$line]\n"
						echo $line >> tofix/tofix_tests.txt
					fi
				fi
				i=$((i + 1))
				echo $i >> tmp/total
				sleep $SPEED
			
			done
		
		printf "\n${GREEN}Conclusion : $(cat tmp/valid | wc -l | xargs)/$(cat tmp/total | wc -l | xargs) tests passed.\n"
		printf "$(cat tofix/tofix_tests.txt | wc -l | xargs) wrong tests were added in \"${YELLOW}./tofix/tofix_tests.txt${GREEN}\".\n"
		rm -rf tmp/valid tmp/total
		fi
fi
rm -f tmp/file1 tmp/file2 tmp/errors_makefile
