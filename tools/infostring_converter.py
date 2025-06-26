import sys
import json
import argparse

def main():
	parser = argparse.ArgumentParser(description='Tool to convert infostrings.')
	parser.add_argument('-s', '--sort', default=False, action='store_true', help='Sort the output JSON keys')
	parser.add_argument('mode', nargs='?', choices=['tojson', 'fromjson'], default='tojson', help="Mode of operation: tojson' to convert infostring to JSON, 'fromjson' to convert JSON to infostring")
	parser.add_argument('input_file', nargs='?', help='Input file path (optional, uses stdin if not provided)')
	parser.add_argument('output_file', nargs='?', help='Output file path (optional, prints to stdout if not provided)')
	args = parser.parse_args()

	try:
		input_text = ''
		output_text = ''
		
		if args.input_file:
			with open(args.input_file, 'r', encoding='utf-8') as f:
				input_text = f.read()
		else:
			input_text = sys.stdin.read()

		if args.mode == 'tojson':
			fields = input_text.split('\\')
			
			dict_data = {}
			# first field is the magic
			dict_data['__HEADERMAGIC__'] = fields[0]

			# the rest are key-value pairs
			for i in range(1, len(fields), 2):
				dict_data[fields[i]] = fields[i + 1] if i + 1 < len(fields) else ''
				
			output_text = json.dumps(dict_data, indent=4, sort_keys=args.sort)
		elif args.mode == 'fromjson':
			dict_data = json.loads(input_text)
			
			if '__HEADERMAGIC__' not in dict_data:
				raise ValueError('Input JSON does not contain the required magic header.')
			
			output_text += dict_data['__HEADERMAGIC__']
			for key, value in dict_data.items():
				if key != '__HEADERMAGIC__':
					output_text += '\\' + key + '\\' + value


		if args.output_file:
			with open(args.output_file, 'w', encoding='utf-8') as f:
				f.write(output_text)
		else:
			print(output_text)
		
	except FileNotFoundError:
		print(f'Error: File not found.', file=sys.stderr)
		sys.exit(1)
	except Exception as e:
		print(f'Error: {str(e)}', file=sys.stderr)
		sys.exit(1)
	finally:
		sys.exit(0)


if __name__ == '__main__':
	main()
