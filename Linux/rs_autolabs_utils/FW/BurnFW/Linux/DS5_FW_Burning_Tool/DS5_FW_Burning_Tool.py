#!/usr/bin/python

# Function definition
def run_progress_bar(finished_event):
    import sys
    import itertools
    chars = itertools.cycle(r'-\|/')
    while not finished_event.is_set():
        sys.stdout.write('\rWorking ' + next(chars))
        sys.stdout.flush()
        finished_event.wait(0.2)

def GetFixedSegment( segment ):
    retStr = ""
    for i in range(0, nextSegmentSize):    
        temp = format(ord(segment[i]), "x")
        if (len(temp) == 1):
            temp = "0" + temp
            
        if (len(retStr) == 0):
            retStr += temp
        else:
            retStr += " " + temp
            
    return retStr


def GetFixedParameter( hexParameter ):   
    parameter = format(int(hexParameter), 'x')
    parameterLen = len(parameter)
    retStr = ""
    lastIndex = parameterLen
    for i in range(0,8,2):
        if (i >= parameterLen):
            retStr += " " + "00"
            continue
        
        temp = None
        if ((lastIndex - 2) < 0):
            temp = parameter[0:lastIndex]
        else:
            temp = parameter[lastIndex - 2:lastIndex]
            
            
        if (len(temp) == 1):
            temp = "0" + temp
            

        if (len(retStr) == 0):
            retStr += temp
        else:
            retStr += " " + temp
            
        lastIndex-=2
            
    return retStr
    
    
def InvokeTerminal( params ):
    from subprocess import call
    filename = "rs-terminal"
    import platform
    extension = ".exe"
    FNULL = 0
    if (platform.system() == 'Linux'):
            extension = ""
            FNULL = open('/dev/null', 'w')

    returnCode = call(["./" + filename + extension, params], stdout=FNULL)
    return returnCode


# Main body
import sys
if (len(sys.argv) != 2):
    print("Failed!\nFW file not provided!\nPlease provide a FW filename as an application argument.")
    exit(1)


print("\n\n~DS5 Flash Burner~")
filePath = str(sys.argv[1])
data = None
file = None
fileSize = None
# Read FW from a file
print("\nReading bin file...")
import threading
finished_event = threading.Event()
progress_bar_thread = threading.Thread(target=run_progress_bar, args=(finished_event,))
progress_bar_thread.start()

try:
    file = open(filePath, mode='rb')
    with file as file:
        data = file.read()
except Exception:
    print("\n'" + filePath + "' not found!\nExiting...")
    exit(1)
finally:
    finished_event.set()
    progress_bar_thread.join()
    if (file):
        file.close()



scriptFileName = "script.txt"
outputFile = open(scriptFileName, "w")

# Disable power features: PFD
pfdRawData = "14 00 ab cd 3b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
outputFile.write(pfdRawData + "\n")

# Erase Flash: FEF 0xACE
fefRawData = "14 00 ab cd 0c 00 00 00 ce 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
outputFile.write(fefRawData + "\n")


# Burn data to flash
dataLength = len(data)
flashIndex = 0        
dataIndex = 0
segmentSize = 1000
cmdSizeMagicNumberOpCode = "ab cd 0a 00 00 00"
zeroParam = "00 00 00 00"
while (dataIndex < dataLength):
    
    nextSegmentSize = min(segmentSize - (flashIndex % segmentSize), dataLength - dataIndex)
    print("dataIndex",dataIndex)
    print("nextSegmentSize",nextSegmentSize)
    segment = data[dataIndex:dataIndex + nextSegmentSize]
    cmdSize = GetFixedParameter(str(nextSegmentSize + 20))[0:5]
    rawSegment = cmdSize + " " + cmdSizeMagicNumberOpCode        
    rawSegment += " " + GetFixedParameter(str(flashIndex)) + " " + GetFixedParameter(str(nextSegmentSize)) + " " + zeroParam + " " + zeroParam
    strSegment = GetFixedSegment(segment)        
    rawSegment += " " + strSegment
    # Write segment to Flash: FWB flashIndex nextSegmentSize segment
    outputFile.write(rawSegment + "\n")
    
    flashIndex += nextSegmentSize
    dataIndex += nextSegmentSize

    

# Reset device: RST
hwResetRawData = "14 00 ab cd 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
outputFile.write(hwResetRawData)

outputFile.close()

print("\n\nTry Burning")
import threading
finished_event = threading.Event()
progress_bar_thread = threading.Thread(target=run_progress_bar, args=(finished_event,))
progress_bar_thread.start()

try:
    if (InvokeTerminal("-r " + scriptFileName) != 0):
        import os
        print("\nBurning failed. Device not connected!\n")
        exit(1)
except Exception:
    print("\nAn unexpected error occurred!\nInvokeTerminal(...) Failed\n")
    exit(1)    
finally:
    import os
    os.remove(scriptFileName)
    finished_event.set()
    progress_bar_thread.join()


print("\nDone!\n")

