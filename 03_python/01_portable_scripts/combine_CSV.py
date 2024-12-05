
path = input("Enter the path to the directory containing the CSV files: ").strip()

# Remove surrounding quotes if present
if path.startswith('"') and path.endswith('"'):
    path = path[1:-1]

# Replace single backslashes with double backslashes for Windows compatibility
path = path.replace('\\', '\\\\')

file_type = input("Enter the file type (e.g., 'csv'): ").strip().lower()
filter_string = input("Enter a string to filter filenames (leave blank for all files): ").strip()

try:
    # List all files in the directory that match the specified file type
    csv_files = [
        f for f in os.listdir(path) 
        if f.endswith(f'.{file_type}') and (filter_string in f if filter_string else True)
    ]

    # Check if any files were found
    if not csv_files:
        print("No files found matching the criteria.")
    else:
        # Use a list comprehension to read and store DataFrames
        df_list = [pd.read_csv(os.path.join(path, file)) for file in csv_files]

        # Concatenate all DataFrames
        combined_df = pd.concat(df_list, ignore_index=True)

        # Get the name for the output file based on the first file's name and the filter string
        base_name = csv_files[0][:5]  # First 5 characters of the first file name
        filter_part = f'_{filter_string}' if filter_string else ''
        output_file_name = f'{base_name}{filter_part}_COMB.csv'

        # Save the combined DataFrame to a new CSV file in the specified directory
        combined_df.to_csv(os.path.join(path, output_file_name), index=False)

        print("Done!")

except Exception as e:
    print(f"Error: {e}")

