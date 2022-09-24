import argparse
import csv
from datetime import datetime
import os
import subprocess
import tempfile

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
    parser = argparse.ArgumentParser(description="Execute batch runs for Maximum Flow Problem")
    parser.add_argument("parametersFile", type=str, help="csv file with parameters for each run")
    parser.add_argument("timeout", type=str, help="max time in seconds that each run will be allowed to take (for each of the algorithms)")
    parser.add_argument("--output", "-o", type=str, default="results.csv", help="csv file to output results to (default: 'results.csv')")
    parser.add_argument("--repeat", "-r", type=int, default=1, help="number of repetitions for each combination or parameter and algorithm (default: 1)")
    parser.add_argument("--status", "-s", type=int, default=10, help="report status each X seconds (default: 10 seconds)")
    args = parser.parse_args()
    csvFileName = args.parametersFile
    timeout = args.timeout
    resultsFileName = args.output
    repetitions = args.repeat
    interval = args.status

    results = []
    with tempfile.TemporaryDirectory() as tmp:
        graphFileName = os.path.join(tmp, 'graph.txt')
        with open(csvFileName, newline='') as csvFile:
            checkpoint = datetime(1970, 1, 1)
            num_lines = sum(1 for line in csvFile)
            csvFile.seek(0)
            

            csvReader = csv.DictReader(csvFile, delimiter=',', quotechar='"')
            for l, parameter in enumerate(csvReader):
                checkpoint = printDebugStatus(checkpoint, num_lines, l, interval)
                generateGraph(parameter['n'], parameter['p'], parameter['r'], parameter['s'], graphFileName)

                for i in range(repetitions):
                    valueDinic, timeDinic = runAlgorithm("./code/Dinic", graphFileName, timeout)
                    valueEK, timeEK = runAlgorithm("./code/EK", graphFileName, timeout)
                    valueMPM, timeMPM = runAlgorithm("./code/MPM", graphFileName, timeout)

                    result = dict()
                    result["n"] = parameter['n']
                    result["p"] = parameter['p']
                    result["r"] = parameter['r']
                    result["s"] = parameter['s']
                    result["Dinic"] = timeDinic
                    result["EK"] = timeEK
                    result["MPM"] = timeMPM
                    results.append(result)

    print(f"writing results to '{resultsFileName}'...")
    with open(resultsFileName, 'w', newline='') as csvFile:
        fieldNames = ["n", "p", "r", "s", "Dinic", "EK", "MPM"]
        csvWriter = csv.DictWriter(csvFile, fieldnames= fieldNames)
        csvWriter.writeheader()
        for result in results:
            csvWriter.writerow(result)

    print("done! bye")


if __name__ == "__main__":
  main()
