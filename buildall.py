#!/usr/bin/env python3

import sys
import subprocess
from tabulate import tabulate
from concurrent.futures import ThreadPoolExecutor, as_completed

targets = ["x86", "x64", "armv7m", "armv7emsp", "armv7emdp", "xtensa", "xtensawin"]  # "armv6m", "rv32imc"
apps = ["assemblyscript", "cpp", "rust", "tinygo", "zig", "virgil", "wat", "coremark"]


# Initialize a dictionary of dictionaries to store results
results = {target: {app: None for app in apps} for target in targets}


# Function to run the make command and return the result
def build(target, app):
    print(f"Building {target} - {app}")
    result = subprocess.run(
        [
            "make",
            "clean",
            "all",
            #"V=1",
            f"ARCH={target}",
            f"APP={app}",
            f"BUILD=build-{target}-{app}",
        ],
        capture_output = True,
        text = True,
    )
    if result.returncode == 0:
        return (target, app, "🟢")
    else:
        print(f"==== FAILED {target} - {app} ====")
        print(result.stdout)
        print(result.stderr)
        return (target, app, "🟥")


# Execute builds in parallel
with ThreadPoolExecutor(max_workers=None) as executor:
    # Create a future for each build task
    futures = {
        executor.submit(build, target, app): (target, app)
        for target in targets
        for app in apps
    }

    # Collect the results as they complete
    for future in as_completed(futures):
        target, app, result = future.result()
        results[target][app] = result

# Prepare the data for tabulate
table = [[results[target][app] for target in targets] for app in apps]

# Display the transposed results using tabulate
print(tabulate(table, headers=targets, showindex=apps, tablefmt="simple_outline"))

# Detect and report failure
if any(item != "🟢" for row in table for item in row):
    sys.exit(1)
