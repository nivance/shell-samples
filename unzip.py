import zipfile
import os
import shutil
import sys

def extract_all(zip_filename, extract_dir, filename_encoding='GBK'):
    zf = zipfile.ZipFile(zip_filename, 'r')
    for file_info in zf.infolist():
        filename = unicode(file_info.filename, filename_encoding).encode("utf8")
        print 'filename is ', filename
        output_filename = os.path.join(extract_dir, filename)
        output_file_dir = os.path.dirname(output_filename)
        if not os.path.exists(output_file_dir):
            os.makedirs(output_file_dir)
        with open(output_filename, 'wb') as output_file:
            shutil.copyfileobj(zf.open(file_info.filename), output_file)
    zf.close()

if __name__ == '__main__':
    if len(sys.argv) < 2 :
	print 'usage: python unzip.py zipFile destDir'
	sys.exit()
    zip_filename = sys.argv[1]
    extract_dir  = sys.argv[2]
    extract_all(zip_filename, extract_dir)

