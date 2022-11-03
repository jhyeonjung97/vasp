from sys import argv
from ase.io import read

def attach_charges(atoms, fileobj='ACF.dat', element='O'):
    """Attach the charges from the fileobj to the Atoms."""
    if isinstance(fileobj, str):
        fileobj = open(fileobj)

    sep = '---------------'
    i = 0 # Counter for the lines
    k = 0 # Counter of sep
    total = 0
    assume6columns = False
    for line in fileobj:
        if line[0] == '\n': # check if there is an empty line in the 
            i -= 1          # head of ACF.dat file   
        if i == 0:
            headings = line
            if 'BADER' in headings.split():
                j = headings.split().index('BADER')
            elif 'CHARGE' in headings.split():
                j = headings.split().index('CHARGE')
            else:
                print('Can\'t find keyword "BADER" or "CHARGE".' \
                +' Assuming the ACF.dat file has 6 columns.')
                j = 4
                assume6columns = True
        if sep in line: # Stop at last seperator line
            if k == 1:
                break
            k += 1
        if not i > 1:
            pass
        else:
            words = line.split()
            if assume6columns is True:
                if len(words) != 6:
                    raise IOError('Number of columns in ACF file incorrect!\n'
                                  'Check that Bader program version >= 0.25')
                
            atom = atoms[int(words[0]) - 1]
            atom.charge = float(words[j])
        i+=1
        
    for atom in atoms:
        if atom.symbol == element:
            print(f"{element}{atom.index} \t: {atom.charge}")
            total+=atom.charge
    print('\033[1m' + f"{element}_tot \t: {total}" + '\033[0m')

atoms = read('POSCAR')
fileobj = 'ACF.dat'
if len(argv) == 1:
    print('default element is oxygen')
    argv[1] = 'O'
for element in argv:
    attach_charges(atoms, 'ACF.dat', element)