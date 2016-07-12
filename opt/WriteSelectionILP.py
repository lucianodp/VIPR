import sys

def read_loss_matrix(filename):
    f = open(filename, 'rt')
    loss = list()
    n = 0
    for line in f:
        lossline = map(lambda x: float(x.strip().lower()), line.split(','))
        loss.append(lossline)
        m = len(lossline)
        n = n+1
    f.close()
    return [loss, n, m]

def write_selection_ilp(loss, n, m, k):
    #f = open(lpfilename)
    f = sys.stdout
    
    b = list()
    for i in range(n):
        b_line = list()
        for j in range(m):
            b_line.append('b_'+ str(i+1) + '_' + str(j+1))
        b.append(b_line)

    p = list()
    for j in range(m):
        p.append('p_' + str(j+1))

    # write objective
    s_obj = ''
    for i in range(n):
        for j in range(m):
            s_obj = s_obj + ' -' + str(loss[i][j]) + ' ' + b[i][j]
    f.write('max: ' + s_obj + ';\n')
    f.write('\n')

    # write line sum constraints
    for i in range(n):
        s_line_constr = ''
        for j in range(m):
            s_line_constr = s_line_constr + b[i][j]
            if (j < m-1):
                s_line_constr = s_line_constr + ' + '
        f.write(s_line_constr + ' = 1;\n')

    # write column constraints
    s_sum_col = ''
    for j in range(m):
        s_col_constr = ''
        for i in range(n):
            s_col_constr = s_col_constr + b[i][j]
            if (i < n-1):
                s_col_constr = s_col_constr + ' + '
        f.write(s_col_constr + ' - ' + str(n) + ' p_' + str(j+1) + ' <= 0;\n')
        s_sum_col = s_sum_col + p[j]
        if (j < m-1):
            s_sum_col = s_sum_col + ' + '
    f.write(s_sum_col + ' <= ' + str(k) + ';\n')

    # write limit constraints
    p_repeat = [x for i in range(n) for x in p]
    b_all = [x for b_line in b for x in b_line]
    map(lambda x: f.write(x[0]+x[1]+x[2]), zip(['-1 ' for i in range(len(b_all))], b_all, [' <= 0;\n' for i in range(len(b_all))]))
    map(lambda x: f.write(x[0]+x[1]+x[2]+x[3]), zip(b_all, [' <= ' for i in range(len(b_all))], p_repeat, [';\n' for i in range(len(b_all))]))
    map(lambda x: f.write(x[0]+x[1]), zip(p,[' <= 1;\n' for i in range(len(p))]))

    #write int variables
    f.write('\nint ' + ', '.join(b_all) + ', ' + ', '.join(p) + ';\n')
    #f.close()

if (len(sys.argv)!=3):
    print 'Usage ' + sys.argv[0] + ' number_of_submodels loss_matrix_file'
else:
    [loss, n, m] = read_loss_matrix(sys.argv[2])
    write_selection_ilp(loss, n, m, int(sys.argv[1]))