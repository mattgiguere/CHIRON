import numpy as np
import sys
from scipy.io.idl import readsav

print "Hello World!"
s = readsav("/Users/matt/data/CHIRPS/starlogs/22049log.dat")
#print s

def main():
	"""
		Accept command line arguments
        """
	import argparse
    
	description = """
        Look at a list of spectral segments (sme files) looking for elements which
        have lines deeper then minLineDepth and don't have neighboring lines
        within blendDistance.
        You can also specify a list of desired elements to only get info for those
        instead of all elements.
        Default is to output to stdout, specifying a file will export to text file.
        """
	
	def existing_file(x):
		"""
            'Type' for argparse - checks that file exists but does not open.
            """
		if not os.path.exists(x):
			raise argparse.ArgumentTypeError("{0} does not exist".format(x))
		return x
	
	parser = argparse.ArgumentParser(description=description)
	
	parser.add_argument("-s","--segment", action="append", dest="segs",
                        metavar='SEGMENT_FILE',
                        default=[],
                        required=True,
                        type=existing_file,
                        help="Add SME file of wavelength segment to be looked at")

	parser.add_argument("-e","--element", action="append", dest="elems",
                        metavar='ELEMENT_ABV',
                        default=[],
                        help="Add element to be looked for in spectrum (default is all found)")
	
	parser.add_argument("-d","--linedepth", action="store", dest="minLineDepth",
                        metavar='MIN_LINE_DEPTH',
                        default=0.025,
                        type=float,
                        help="Specify minimum line depth to consider")
	
	parser.add_argument("-b","--blenddist", action="store", dest="blendDistance",
                        metavar='BLEND_DISTANCE',
                        default=0.04, # angstroms
                        type=float,
                        help="Specify distance (in angstroms) within which neighbor is considered a blend")
	
	args = parser.parse_args()
	# In argparse, the positional arguments are included in args rather than like in
	# optparse where they were a separate namespace.
	#
	
	ans = getMaskedElems(args.segs,minLineDepth=args.minLineDepth,blendDistance=args.blendDistance,desired=args.elems)
0

if __name__ == "__main__":
	sys.exit(main())
