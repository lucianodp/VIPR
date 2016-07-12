import sys

def read_selection_variables(filename):
    f = open(filename, 'rt')
    for line in f:
        if 'Actual values of the variables:' in line:
            break
    sel_dict = dict()
    m = 0
    n = 0
    for line in f:
        sp_idx = line.find(' ')
        b = line[0:sp_idx]
        if 'b' in b:
            v = int(line[sp_idx:].strip())
            sel_dict[b] = v
            idx = b.split('_')
            n = max(n, int(idx[1]))
            m = max(m, int(idx[2]))
    f.close()
    sel = list()
    for i in range(n):
        sel.append([0]*m)
        for j in range(m):
            sel[i][j] = sel_dict['b_' + str(i+1) + '_' + str(j+1)]
    return sel

def write_selection_ilp(sel):
    sel_lines = [','.join(map(lambda y: str(y), x)) for x in sel]
    print '\n'.join(sel_lines)
#print sel

if (len(sys.argv)!=2):
    print 'Usage ' + sys.argv[0] + ' ilp_result_file'
else:
    sel = read_selection_variables(sys.argv[1])
    write_selection_ilp(sel)