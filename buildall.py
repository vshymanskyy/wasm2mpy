import sys
import subprocess
from tabulate import tabulate
from concurrent.futures import ThreadPoolExecutor, as_completed

targets = ["x86", "x64", "armv6m", "armv7m", "xtensa", "xtensawin"]  # "armv7emsp", "armv7emdp",

apps = ["virgil", "wat"]  # TODO: "assemblyscript", "cpp", "rust", "tinygo", "virgil", "wat", "zig", "coremark"


# Initialize a dictionary of dictionaries to store results
results = {target: {app: None for app in apps} for target in targets}


# Function to run the make command and return the result
def build(target, app):
    try:
        print(f"Building {target} - {app}")
        subprocess.run(
            [
                "make",
                "clean",
                "all",
                f"ARCH={target}",
                f"APP={app}",
                f"BUILD=build-{target}-{app}",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.STDOUT,
            check=True,
        )
        return (target, app, "🟢")
    except subprocess.CalledProcessError:
        return (target, app, "🟥")  # ⏳


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
if any(item != '🟢' for row in table for item in row):
    sys.exit(1)
