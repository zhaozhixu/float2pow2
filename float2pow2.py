#! /usr/bin/python3

# fuction float2pow2_offline can (optionally) dump trainable variables
# to txt files and convert them from floats to nearest numbers that are the
# sums of combinations of power of 2s.
import os
import re
import numpy as np
import tensorflow as tf

def parse_tensor_str(tensor_str):
    # print (tensor_str)
    strre = r'(?<=\d)(?=\s)'
    parsed_str = re.sub(strre, ',', tensor_str)
    strre = r'\](\s*)\['
    m = re.search(strre, parsed_str)
    if m:
        parsed_str = re.sub(strre, '],' + m.group(1) + '[', parsed_str)
    # print (parsed_str)
    tensor = eval(parsed_str)
    return tensor

def savetheta(file_name, variable):
	#np.savetxt('data/'+file_name,variable)
	np.set_printoptions(threshold=np.nan)
	file = open(file_name,'w')
	file.write(str(variable));
	file.close()
	print(file_name + " has been saved")

def save_data(sess, savedir):
    for x in tf.trainable_variables():
        filename = savedir + '/' + re.sub(r'/', '_', x.op.name) + ':0.txt'
        savetheta(filename, x.eval(session=sess))

def load_from_dir(sess, datadir):
    fixed_ops = []
    for x in tf.trainable_variables():
        filename = datadir + '/' + re.sub(r'/', '_', x.op.name) + ':0.txt'
        try:
            fo = open(filename)
            fstr = fo.read()
            # fix_op = x.assign(parse_tensor_str(fstr))
            # op = x.assign(tf.Variable(parse_tensor_str(fstr)))
            op = tf.assign(x, tf.Variable(parse_tensor_str(fstr), dtype=tf.float32))
        except IOError:
            print ("No such file: " + filename)
            continue
        fo.close()
        fixed_ops.append(op)

    return tf.group(*fixed_ops)

def float2pow2_offline(bitwidth, pow_low, pow_high, datadir, sess, resave=False, recall=False, convert=False):
    if resave:
        save_data(sess, datadir)
    if recall:
        os.system("./scripts/restore.sh " + str(datadir))
    if convert:
        os.system("./scripts/float2pow2.sh -p 0 -b " + str(bitwidth) + " -r " + str(pow_low) + " " + str(pow_high) + " -f " + str(datadir) + "/*.txt")
    return load_from_dir(sess, datadir)
