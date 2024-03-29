import argparse
import csv
from datetime import datetime
import os
import subprocess
import tempfile
import string

def generateGraph(n, p, r, s, outputFileName):
    graphGeneratorCmd = ["python3", "./code/gen.py", n, p, r, s, outputFileName]
    try:
        subprocess.run(graphGeneratorCmd, check=True)
    except subprocess.CalledProcessError:
        quit("error running graph generator")

def runAlgorithm(program, graphFileName, timeout):
    algorithmCmd = [program, timeout, graphFileName]
    try:
        result = subprocess.run(algorithmCmd, check=True, capture_output=True)
    except subprocess.CalledProcessError:
        quit("error running graph generator")
    return result.stdout.decode("utf-8").split("\n")[:2]

def printDebugStatus(checkpoint, num_lines, l, interval):
    # only print status if interval has passed without giving update to user
    now = datetime.now()
    delta = now - checkpoint
    if (delta.total_seconds() >= interval):
        print(f"executing... {l} of {num_lines}")
        return now
    return checkpoint

def main():
    description = """
        Execute batch runs for Maximum Flow Problem.
        This script is capable of executing all algorithms for each of the parameters any number of times.

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
        n,p,r,s,alg,time
        100,0.5,100,86029955770628,Dinic,0.000166945
        100,0.5,100,86029955770628,EK,0.00159629
        100,0.5,100,86029955770628,MPM,0.000623259
        100,0.5,100,368539058687997,Dinic,0.000154795
        ...
        ```

        In addition to the inputs we have:

        * `Dinic` the execution time for the Dinic algorithm implementation
        * `EK` the execution time for the EK algorithm implementation
        * `MPM` the execution time for the MPM algorithm implementation
    """
    allowed_algorithms = ['dinic', 'ek', 'mpm']
    parser = argparse.ArgumentParser(description=description, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("parametersFile", type=str, help="csv file with parameters for each run")
    parser.add_argument("timeout", type=str, help="max time in seconds that each run will be allowed to take (for each of the algorithms)")
    parser.add_argument("--output", "-o", type=str, default="results.csv", help="csv file to output results to (default: 'results.csv')")
    parser.add_argument("--repeat", "-r", type=int, default=1, help="number of repetitions for each combination or parameter and algorithm (default: 1)")
    parser.add_argument("--status", "-s", type=int, default=10, help="report status each X seconds (default: 10 seconds)")
    parser.add_argument("--algorithm", "-a", nargs='*', default=allowed_algorithms, help=f"The algorithms to run against. Defaults to all: {allowed_algorithms}")
    args = parser.parse_args()
    csvFileName = args.parametersFile
    timeout = args.timeout
    resultsFileName = args.output
    repetitions = args.repeat
    interval = args.status
    algorithms = [alg.lower() for alg in args.algorithm]

    # validate algorithms chosen
    if (not all(alg in allowed_algorithms for alg in algorithms)):
        quit(f"provided algorithms are not valid. Please choose any arrangement from the subset of {allowed_algorithms}")
    if (len(algorithms) == 0):
        quit(f"at least one algorithm must be provided. Please choose any arrangement from the subset of {allowed_algorithms}")

    results = []
    with tempfile.TemporaryDirectory() as tmp:
        graphFileName = os.path.join(tmp, 'graph.txt')
        with open(csvFileName, newline='') as csvFile:
            checkpoint = datetime(1970, 1, 1)
            num_lines = sum(1 for line in csvFile) - 1
            csvFile.seek(0)
            

            csvReader = csv.DictReader(csvFile, delimiter=',', quotechar='"')
            for l, parameter in enumerate(csvReader):
                checkpoint = printDebugStatus(checkpoint, num_lines, l+1, interval)
                generateGraph(parameter['n'], parameter['p'], parameter['r'], parameter['s'], graphFileName)

                for i in range(repetitions):
                    if 'dinic' in algorithms:
                        result = dict()
                        result["n"] = parameter['n']
                        result["p"] = parameter['p']
                        result["r"] = parameter['r']
                        result["s"] = parameter['s']
                        result["alg"] = "Dinic"
                        valueDinic, timeDinic = runAlgorithm("./code/Dinic", graphFileName, timeout)
                        result["time"] = timeDinic
                        results.append(result)
                    if 'ek' in algorithms:
                        result = dict()
                        result["n"] = parameter['n']
                        result["p"] = parameter['p']
                        result["r"] = parameter['r']
                        result["s"] = parameter['s']
                        result["alg"] = "EK"
                        valueEK, timeEK = runAlgorithm("./code/EK", graphFileName, timeout)
                        result["time"] = timeEK
                        results.append(result)
                    if 'mpm' in algorithms:
                        result = dict()
                        result["n"] = parameter['n']
                        result["p"] = parameter['p']
                        result["r"] = parameter['r']
                        result["s"] = parameter['s']
                        result["alg"] = "MPM"
                        valueMPM, timeMPM = runAlgorithm("./code/MPM", graphFileName, timeout)
                        result["time"] = timeMPM
                        results.append(result)

    print(f"writing results to '{resultsFileName}'...")
    with open(resultsFileName, 'w', newline='') as csvFile:
        fieldNames = ["n", "p", "r", "s", "alg", "time"]
        csvWriter = csv.DictWriter(csvFile, fieldnames= fieldNames)
        csvWriter.writeheader()
        for result in results:
            csvWriter.writerow(result)

    print("done! bye")


if __name__ == "__main__":
  main()
