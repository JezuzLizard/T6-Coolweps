import os
import re
import sys

def find_anims_files(root_dir):
	files_files = []
	for dirpath, _, filenames in os.walk(root_dir):
		for filename in filenames:
			if filename.endswith('.anims'):
				files_files.append(os.path.join(dirpath, filename))
				
	return files_files

def extract_all_between(text, start_regex, end_regex):
	results = {}
	pos = 0
	while True:
		start_match = re.search(start_regex, text[pos:], re.MULTILINE)
		if not start_match:
			break

		group_key = start_match.group(1)
		assert group_key not in results, 'Duplicate CUSTOM'
		start_idx = pos + start_match.start() + len(start_match.group(0))
		end_match = re.search(end_regex, text[start_idx:], re.MULTILINE)
		if not end_match:
			assert False, 'Missing ENDCUSTOM'

		assert group_key == end_match.group(1), 'Mismatched ENDCUSTOM'

		end_idx = start_idx + end_match.start()
		results[group_key] = text[start_idx:end_idx]
		pos = end_idx + len(end_match.group(0))

	return results

def replace_all_between_with(text, start_regex, end_regex, replacement_func):
	result = []
	pos = 0
	while True:
		start_match = re.search(start_regex, text[pos:], re.MULTILINE)
		if not start_match:
			result.append(text[pos:])
			break

		group_key = start_match.group(1)
		start_idx = pos + start_match.start()
		content_start = start_idx + len(start_match.group(0))

		end_match = re.search(end_regex, text[content_start:], re.MULTILINE)
		if not end_match:
			assert False, 'Missing ENDCUSTOM'

		assert end_match.group(1) == group_key, 'Mismatched ENDCUSTOM'
		content_end = content_start + end_match.start()
		result.append(text[pos:start_idx])
		result.append(replacement_func(group_key, text[content_start:content_end]))
		pos = content_end + len(end_match.group(0))

	return ''.join(result)

def main():
	if len(sys.argv) < 3:
		print('Usage: python generate_anims.py <search_root> <og assets path>')
		sys.exit(1)

	search_root = sys.argv[1]
	og_assets_path = sys.argv[2]

	anim_files = find_anims_files(search_root)

	start_pattern = r'// CUSTOM (.+)$'
	end_pattern = r'// ENDCUSTOM (.+)$'
	
	parsed_anims = {}
	for filename in anim_files:
		with open(filename, 'r', encoding='utf-8') as f:
			parse = extract_all_between(f.read(), start_pattern, end_pattern)
			for group_key, content in parse.items():
				if group_key not in parsed_anims:
					parsed_anims[group_key] = ''

				parsed_anims[group_key] += content + '\n'

	for dirpath, _, filenames in os.walk(og_assets_path):
		for filename in filenames:
			filepath = os.path.join(dirpath, filename)
			with open(filepath, 'r', encoding='utf-8') as f:
				def my_replacer(group_key, old_content):
					return f'// CUSTOM {group_key}\n{parsed_anims[group_key] if group_key in parsed_anims else old_content}\n// ENDCUSTOM {group_key}'

				new_content = replace_all_between_with(f.read(), start_pattern, end_pattern, my_replacer)
				new_file = os.path.join(search_root, os.path.relpath(filepath, og_assets_path))
				os.makedirs(os.path.dirname(new_file), exist_ok=True)
				with open(new_file, 'w', encoding='utf-8') as f:
					f.write(new_content)


if __name__ == '__main__':
	main()
