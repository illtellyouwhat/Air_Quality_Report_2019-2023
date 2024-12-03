#Script must be run in the CWD of files to add to DB
#only set to work with .CSV files



import os
import subprocess
import getpass
import glob
from datetime import datetime

# Log file
log_file = "transfer_log.txt"

# Clear log file
with open(log_file, 'w') as f:
    f.write(f"Transfer Log - {datetime.now()}\n")

# Prompt for user input
username = input("Enter PostgreSQL username: ")
database = input("Enter PostgreSQL database: ")
password = getpass.getpass("Enter PostgreSQL password: ")
copy_command = input("Enter the \COPY command (e.g., \COPY <table> (col1, col2, col3, etc): ")

# Get current directory
directory = os.getcwd()

# Check for CSV files
files = glob.glob(os.path.join(directory, '*.csv'))
if not files:
    print("No CSV files found in the directory.")
    with open(log_file, 'a') as f:
        f.write("No CSV files found in the directory.\n")
    exit(1)

# Loop through all CSV files
for file in files:
    if os.path.isfile(file):
        print(f"Processing file: {file}")
        with open(log_file, 'a') as f:
            f.write(f"Processing file: {file}\n")
        
        psql_command = f"psql -U \"{username}\" -d \"{database}\" -c \"{copy_command} FROM '{file}' DELIMITER ',' CSV HEADER\""

        # Export PGPASSWORD for password input
        os.environ['PGPASSWORD'] = password

        # Execute the command and log success or failure
        result = subprocess.run(psql_command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        with open(log_file, 'a') as f:
            if result.returncode == 0:
                print(f"Successfully transferred: {file}")
                f.write(f"Successfully transferred: {file}\n")
            else:
                print(f"Error transferring: {file}")
                f.write(f"Error transferring: {file}\n")
                f.write(result.stderr)

# Unset the PGPASSWORD variable
del os.environ['PGPASSWORD']

print("Transfer process completed. Check", log_file, "for details.")