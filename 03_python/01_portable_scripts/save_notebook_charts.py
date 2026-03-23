# Takes all charts generated and saves them in a folder named after the notebook
# ATTENTION! Type notebook name in notebook_path

notebook_path = "cleaned_data_overview_AQI.ipynb"  
output_dir = Path(notebook_path + "_charts")
output_dir.mkdir(exist_ok=True)

# Load the notebook content
with open(notebook_path, "r", encoding="utf-8") as f:
    nb = nbformat.read(f, as_version=4)

# Iterate over each cell in the notebook
for i, cell in enumerate(nb.cells):
    # Check if the cell has outputs and contains images
    if 'outputs' in cell:
        # Filter out cells with no chart (image/png)
        image_outputs = [output for output in cell['outputs'] if 'data' in output and 'image/png' in output['data']]
        
        # If there are no image outputs, skip the cell
        if not image_outputs:
            continue

        # Create a folder for the cell based on its index
        cell_folder = output_dir / f"cell_{i+1}"
        cell_folder.mkdir(exist_ok=True)
        
        image_counter = 1
        
        # Process each image output
        for output in image_outputs:
            # Decode the base64 image data
            image_data = output['data']['image/png']
            image_bytes = base64.b64decode(image_data)
            
            # Save image with a unique name based on the image count in the current cell
            image_filename = cell_folder / f"image_{image_counter}.png"
            with open(image_filename, "wb") as img_file:
                img_file.write(image_bytes)
            
            image_counter += 1

print(f"Images saved in '{output_dir}'")