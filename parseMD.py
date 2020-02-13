import re
import csv
import urllib.request

url = 'https://raw.githubusercontent.com/2019ncovmemory/nCovMemory/features/generate-readme-from-csv/README.md'
content = urllib.request.urlopen(url).readlines()
lines = [x.decode('utf-8') for x in content]
# with open("./ncovmemory_README.md", 'r') as f:
#     lines = f.readlines()

title = ''
with open('ncov.csv', 'w', newline='\n') as csvfile:
    writer = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(['媒体','日期','原始URL','截图','Archive'])
    for line in lines:

        if re.search('###',line):
            title = line.rstrip()[4:]
        
        if re.search('|link|', line) and active:
            elements = [title] + line.rstrip().split('|')[1:]
            if len(elements) < 5:
                continue
            # print(len(elements))
            time = elements[1]
            if re.search('\d\d-\d\d', time):
                writer.writerow(elements)
