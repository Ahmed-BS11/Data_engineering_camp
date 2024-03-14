import sys
import pandas as pd

print(sys.argv)

# sys.argv[0]==> the name of the file
# sys.argv[1]==>whatever we pass in the run command exp docker run -it test:pandas 2021-01-15

day = sys.argv[1]
print(f'Job done! for day = {day}')
