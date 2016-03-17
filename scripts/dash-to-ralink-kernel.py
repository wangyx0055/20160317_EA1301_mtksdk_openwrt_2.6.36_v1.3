# auto patch script by hua.shao
# prefer python 3.x

import sys
import os
import re
import hashlib

v2_filelist = []
v1_filelist = []
v1_source_folder = ""
v2_source_folder = ""
test = True
quilt = "/usr/local/bin/quilt"

def quilt_add(path):
	file1 = path
	file2 = os.path.join(v2_source_folder, path)
	print("+++++ v2 add "+path)
	if test:
		if not os.path.exists(os.path.dirname(path)):
			print("mkdir -p "+os.path.dirname(path))
		print("cp "+file2+" "+file1)
	else:
		os.system(quilt+" add "+path)
		# make sure the path exists
		if os.path.dirname(path) != "" and not os.path.exists(os.path.dirname(path)):
			print("mkdir -p "+os.path.dirname(path))
			os.system("mkdir -p "+os.path.dirname(path))
		os.system("cp "+file2+" "+file1)
		#os.system("sed -i 's/[ \t]*$//g' "+file1)

def quilt_mod(path):
	file1 = path
	file2 = os.path.join(v2_source_folder, path)
	print("@@@@@ v2 mod "+path)
	if test:
		print("cp "+file2+" "+file1)
	else:
		os.system(quilt+" add "+path)
		os.system("cp "+file2+" "+file1)
		#os.system("sed -i 's/[ \t]*$//g' "+file2)

def quilt_del(path):
	global test
	print("----- v2 del %s"%(path))
	if test:
		print("rm "+path)
	else:
		os.system(quilt+" add "+path)
		os.system("rm "+path)
		pass

def quilt_refresh():
	print(quilt+" refresh --strip-trailing-whitespace")
	os.system(quilt+" refresh --strip-trailing-whitespace")

def same(path1, path2):
	if os.stat(path1).st_size != os.stat(path2).st_size:
		print("size r%d - o%d"%(os.stat(path1).st_size, os.stat(path2).st_size))
		return False
	else:
		m = hashlib.md5()
		with open(path1, "rb") as fp:
			data = fp.read()
			m.update(data)
		hash1 = m.digest()
		m = hashlib.md5()
		with open(path2, "rb") as fp:
			data = fp.read()
			m.update(data)
		hash2 = m.digest()
		if hash1 == hash2:
			print("skip "+path1)
			return True
		else:
			print("hash1", end=None)
			print(hash1)
			print("hash2", end=None)
			print(hash2)
			return False	

def build_filelist(path, filelist, prefix):
	all = os.listdir(path)
	for each in all:
		subpath = os.path.join(path, each)
		if os.path.isdir(subpath):
			build_filelist(subpath, filelist, prefix)
		elif os.path.isfile(subpath):
			filelist.append(os.path.relpath(subpath, prefix))
		else:
			print("warning! link? ==> "+subpath)
			filelist.append(os.path.relpath(subpath, prefix))


def make_patch(v1_folder, v2_folder):
	global v2_filelist
	global v1_filelist
	v2_eql=0 # number of files which remain unchanged 
	v2_add=0 # number of files added by v2
	v2_del=0 # number of files removed in v2
	v2_mod=0 # number of files modified in v2

	os.system("cp -rf "+v1_folder+" "+v1_folder+".backup")
	build_filelist(v1_folder, v1_filelist, v1_folder)
	build_filelist(v2_folder, v2_filelist, v2_folder)

	os.system(quilt+" new platform/0000-dash-to-ralink-2.6.36.patch")
	#for i,f in enumerate(v2_filelist):
	#	print("%d %s"%(i,f))

	#for i,f in enumerate(v1_filelist):
	#	print("%d %s"%(i,f))

	with open("v2_filelist", "w") as fp:
		fp.write("v2 files:\n")
		for each in v2_filelist:
			fp.write(each)
			fp.write("\n")

	with open("v1_filelist", "w") as fp:
		fp.write("v1 files\n")
		for each in v1_filelist:
			fp.write(each)
			fp.write("\n")

	for afile in v2_filelist:
		if afile not in v1_filelist:
			quilt_add(afile)
			v2_add = v2_add + 1
			continue
		if same(os.path.join(v2_folder, afile),os.path.join(v1_folder, afile)):
			v2_eql = v2_eql + 1
		else:
			quilt_mod(afile)
			v2_mod = v2_mod + 1
		# remove afile from v1_folder
		v1_filelist.remove(afile)
	# take care of files removed in v2 
	for afile in v1_filelist:
		if -1 != afile.find("Documentation/"):
			print("ignore "+afile)
			continue
		quilt_del(afile)
		v2_del = v2_del + 1

	print("v2_eql : %d"%(v2_eql))
	print("v2_add : %d"%(v2_add))
	print("v2_del : %d"%(v2_del))
	print("v2_mod : %d"%(v2_mod))
	quilt_refresh()



if __name__ == "__main__":
	#global test
	#global v1_source_folder
	#global v2_source_folder
	if len(sys.argv) > 1 and sys.argv[1] == "do":
		test = False 
	else:
		test = True

	print("test = %d"%(test))
	if v1_source_folder == "":
		v1_source_folder = input("v1 path:")
	if v2_source_folder == "":
		v2_source_folder = input("v2 path:")
	v1_source_folder = os.path.abspath(v1_source_folder)
	v2_source_folder = os.path.abspath(v2_source_folder)

	print("v1 path :" + v1_source_folder)
	print("v2 path :" + v2_source_folder)

	os.chdir(v1_source_folder)
	make_patch(v1_source_folder, v2_source_folder)


