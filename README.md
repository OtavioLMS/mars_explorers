# MarsExplorer
## Elixir 1.6.2 (compiled with OTP 19)

NASA is sending probes to inspect plateaus in mars,
this a fictional application of that process made in elixir considering the probes move within a grid

## Input
the first line of the file must have two integers representing the max coordinates of the plateau 
```
5 9
```

the following lines must come in pairs of two representing a probe and the commands it receives
```
1 2 N
LMLMLMLMM
```

in the production environment this program will look for a file called input.txt on the io folder

in the development environment thefile will be called input.txt.example

for the test environment the file is input txt on the test/io folder

### full input example:

```
5 9
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
0 0 S
MMMMMMMMMM
1 1 E
MMM
6 1 W
MMM
```

## Output
the output will have the same directory and extension as its input counterpart for each environment, the difference being only thet the file name will be output instead of input

probes that go beyond the limits of the plateau(higher than set on the input file or lower than zero for either axis) will be indicated on the output, so will probes whose path is blocked by previously executed probes

### output example:

```
1 3 N
5 1 E
this probe was lost -> 0 -1
4 1 E
this probe stopped because of an obstacle -> 6 1 
```

## Execution details
 
### To execute the tests:

```
mix test
```

### To compile and execute the application:

```
mix escript.build
./mars_explorer
```
