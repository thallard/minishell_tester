# minishell_tester

## Overview


## Installation

```bash
git clone https://github.com/thallard/minishell_tester
```

## Prerequis
You must have the below part in your main of your minishell, otherwise you will can't use the tester : 
```c
// argv[3] will contains the -c that tester will send it
// argv[2] will contains the content of the line for example "echo $USER ; ls -la"
int main(int argc, char **argv)
{
  // Your code...
  if (argc >= 3 && !ft_strncmp(argv[1], "-c", 3))
    ft_launch_minishell(argv[
    // Here add the function that normally parse, execute, etc... line readed 
  // Your code...
  return (0);
}
```

## Usage


## Contact
If you have any ideas to improve this tester or if you are a bug hunter, feel free to send a pm on Discord : hosrAAA#6964

https://profile.intra.42.fr/users/thallard
https://profile.intra.42.fr/users/bjacob
