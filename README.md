# mei-2022-2023

## Batch Executor 

In the `executor.py` you can find a batch executor for the Maximum Flow Problem.
It is capable of executing all algorithms for each of the parameters any number of times.
For all options on how to execute the scrip see help (`python3 executor.py -h`).

Parameters are provided as a csv file of the format:

```csv
n,p,r,s
100,0.5,100,86029955770628
105,0.5,100,368539058687997
110,0.5,100,542815961637859
115,0.5,100,511607154454856
120,0.5,100,712489507517039
...
```

Where:

* `n` is the number of vertices 
* `p` is the arc probability (0 <= p <= 1)
* `r` is the maximum range of capacity
* `s` is the random seed

It outputs a file in the format:

```csv
n,p,r,s,Dinic,EK,MPM
100,0.5,100,86029955770628,0.000166945,0.00161067,0.000567869
100,0.5,100,86029955770628,0.000179486,0.00159629,0.000719177
100,0.5,100,86029955770628,0.00014913,0.00179331,0.000623259
100,0.5,100,86029955770628,0.000154795,0.00150538,0.000584598
...
```

In addition to the inputs we have:

* `Dinic` the execution time for the Dinic algorithm implementation
* `EK` the execution time for the EK algorithm implementation
* `MPM` the execution time for the MPM algorithm implementation
