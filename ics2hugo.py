from ics import Calendar
import argparse
import arrow
import requests
#import re

def write_hugo(path,events):
    #for event in events:
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
    with open(path+'/events.md','w') as mdfile:
        for event in events:
            local = event.begin.to('Europe/Berlin')
            mdfile.write('* '+local.format('YYYY-MM-DD, HH:mm')+': '+event.name+'\n')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ics2hugo (markdown) conversion tool.')
    parser.add_argument('--url', required=True, help='url to ics calendar.')
    parser.add_argument('--path', required=True ,help='output path of markdown files.')
    args = parser.parse_args()
    try:
        ics = Calendar(requests.get(args.url).text)
        events = list(ics.timeline.start_after(arrow.now()))
        #events = list(ics.timeline)
        write_hugo(args.path,events)
    except:
        print("An exception occurred")
