# Assignment 2: Undo Logging in xv6
### Goal
- To implement a different implementation of write-ahead logging with undo logs instead of the redo logs
- The difference would be that now the unmodified data would be stored in logs to prevent any data loss instead of writing the new modified data to logs

### Idea Overview
- Most of the functionalities were already provided to us in the starter code
- I implemented a new function our_bread in log.c used to read from buffer cache
- In bio.c, I had to implement bread_wr which called functions from our implementation of log.c
- The code that I added was pretty less but had a lot of conceptual thought behind it
- lab2.md file has also explained the steps pretty well, you can refer them to get more idea about this

This was also an easy assignment but introduced a new idea to me of undo logging as only redo logging was discussed in the class
