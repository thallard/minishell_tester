# minishell_tester

## Overview

![](tmp/preview.gif)

## Get started
First of all, you must have the below part in your main of your minishell, otherwise you will can't use the tester.
If you don't understand this part or have some troubles, do not hesitate to contact me on Discord or Slack : 
```cpp
// argv[3] will contains the -c flag that tester will send it, you have to check it
// argv[2] will contains the content of the line for example "echo $USER ; ls -la" 
int main(int argc, char **argv)
{
  // Your code...
  if (argc >= 3 && !ft_strncmp(argv[1], "-c", 3)) // Check if the -c flag is enabled
    ft_launch_minishell(argv[2]);
    // Above this is the function that normally launch your minishell, instead 
    // of reading line with a get_next_line or a read() on fd 0, you just have to get
    // the argv[2] (which contains the content) and execute it.
  // Your code...
  return (0);
}
```

## Usage


## Contact
If you have any ideas to improve this tester or if you are a bug hunter, feel free to send a PM on Discord : hosrAAA#6964

https://profile.intra.42.fr/users/thallard
