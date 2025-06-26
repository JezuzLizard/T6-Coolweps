import os
import zipfile
import glob
import sys
import shutil

def read_file_list(file_path):
	includes = []
	excludes = []
	with open(file_path, 'r', encoding='utf-8') as f:
		for line in f:
			line = line.strip()
			if not line or line.startswith('//'):
				continue
				
			if line.startswith('!'):
				excludes.append(line[1:])
			else:
				includes.append(line)

	# Expand includes
	files = []
	for pattern in includes:
		matched = glob.glob(os.path.join(os.path.dirname(file_path), pattern), recursive=True)
		if matched:
			files.extend(matched)
		else:
			files.append(os.path.join(os.path.dirname(file_path), pattern))

	# Expand excludes
	exclude_paths = set()
	for pattern in excludes:
		matched = glob.glob(os.path.join(os.path.dirname(file_path), pattern), recursive=True)
		exclude_paths.update(os.path.abspath(p) for p in matched)

	# Filter out excluded files and directories
	filtered_files = []
	for f in files:
		abs_f = os.path.abspath(f)
		# Exclude if file or any parent is in exclude_paths
		if any(abs_f == ex or abs_f.startswith(ex + os.sep) for ex in exclude_paths):
			continue

		filtered_files.append(f)

	return filtered_files

def find_files_files(root_dir):
	files_files = []
	for dirpath, _, filenames in os.walk(root_dir):
		for filename in filenames:
			if filename.endswith('.files'):
				files_files.append(os.path.join(dirpath, filename))
				
	return files_files

def main():
	if len(sys.argv) < 3:
		print("Usage: python generate_iwd.py <search_root> <output.iwd> [developer]")
		sys.exit(1)

	search_root = sys.argv[1]
	output_zip = sys.argv[2]
	developer = len(sys.argv) > 3 and sys.argv[3] != '0' and sys.argv[3] != 'false' and sys.argv[3] != 'False'

	files_to_zip = []

	files_files = find_files_files(search_root)
	for files_file in files_files:
		base_folder = os.path.dirname(files_file)
		file_list = read_file_list(files_file)

		for f in file_list:
			if os.path.isdir(f):
				continue
			elif os.path.exists(f):
				arcname = os.path.relpath(f, base_folder)
				files_to_zip.append((f, arcname))
			else:
				print(f"Warning: {f} not found, skipping.")

	if not developer:
		with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
			for file_path, arcname in files_to_zip:
				zipf.write(file_path, arcname=arcname)
	else:
		for file_path, arcname in files_to_zip:
			dest_path = os.path.join(search_root, arcname)
			os.makedirs(os.path.dirname(dest_path), exist_ok=True)
			shutil.copy2(file_path, dest_path)

	print(f"Created {output_zip} with {len(files_to_zip)} entries.")

if __name__ == "__main__":
	main()
