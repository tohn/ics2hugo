"""Small script to create a markdown file with date, time and name of
future events given by an URL containing an ics calendar"""

import argparse
import sys
from ics import Calendar
import arrow
import requests
#import re

def write_hugo(path, entries):
    """Write date, time and name to a markdown file"""
    #for event in entries:
    #    fname = event.name
    #    fname = fname.replace(' ','-')
    #    fname = re.sub('[^0-9a-zA-Z-]*','',fname)
    #    fpath = path+'/'+fname+'.md'
    #    with open(fpath,'w') as mdfile:
    #        mdfile.write('+++\n')
    #        mdfile.write('date = \"'+str(event.begin.to('Europe/Berlin'))+'\"\n')
    #        mdfile.write('title = \"'+event.name+'\"\n')
    #        mdfile.write('+++\n\n')
    #        mdfile.write(str(event.description))
    with open(path+'/events.md', mode='w', encoding='utf-8') as mdfile:
        for event in entries:
            local = event.begin.to('Europe/Berlin')
            mdfile.write('* '+local.format('YYYY-MM-DD, HH:mm')+': '+event.name+'\n')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ics2hugo (markdown) conversion tool.')
    parser.add_argument('--url', required=True, help='url to ics calendar.')
    parser.add_argument('--path', required=True ,help='output path of markdown files.')
    args = parser.parse_args()
    try:
        ics = Calendar(requests.get(args.url, timeout=10).text)
        events = list(ics.timeline.start_after(arrow.now()))
        #events = list(ics.timeline)
        write_hugo(args.path, events)
    except Exception as e: # pylint: disable=broad-exception-caught
        print(f"Error '{0}' occured. Arguments {1}.".format(e.message, e.args))
        sys.exit(1)
