#! /bin/sh
#  auto release script by hua.shao

release_dir=`pwd | sed "s/.*\///"`
curtag=`git log --pretty=oneline | awk 'NR==1 {print}' | cut -c -8`
curdir=`pwd | sed "s/.*\///"`
curdate=`date +%Y%m%d`


if [ -d "${release_dir}" ] ; then
	echo "clean up ${release_dir}"
	rm -rf ${release_dir}
fi
mkdir ${release_dir}/ 2>/dev/null

for each in ${release_dir} ${curtag} ${curdir} ${curdate}; do
	if [ "${each}" = "" ]; then
		echo " empty! abort!"
		exit 1
	else
		echo "${each}"
	fi
done


# for mini sdk
cp -rf ./BSDmakefile ${release_dir}/
#cp -rf ./.config ${release_dir}/
cp -rf ./Config.in ${release_dir}/
cp -rf ./Config-kernel.in ${release_dir}/
cp -rf ./docs ${release_dir}/
cp -rf ./feeds.conf.default ${release_dir}/
cp -rf ./.gitattributes ${release_dir}/
cp -rf ./.gitignore ${release_dir}/
cp -rf ./include ${release_dir}/
cp -rf ./LICENSE ${release_dir}/
cp -rf ./Makefile ${release_dir}/
cp -rf ./package ${release_dir}/
cp -rf ./README ${release_dir}/
cp -rf ./rules.mk ${release_dir}/
make clean -C scripts/config # this colder contains prebuilt objs
cp -rf ./scripts ${release_dir}/
cp -rf ./target ${release_dir}/
cp -rf ./toolchain ${release_dir}/
cp -rf ./tools ${release_dir}/
mkdir -p ${release_dir}/dl

# ralink drivers
cp dl/mt76*.bz2 ./${release_dir}/dl/

echo -n "packing mini sdk, size before zip : "
du -sh ${release_dir}
tar cjf mtksdk-${curdir}-${curdate}-${curtag}.tar.bz2  ${release_dir}
ls -lh mtksdk-*

# for normal sdk
mv ./dl/* ${release_dir}/dl/
mv ./.git ${release_dir}/
mv ./feeds ${release_dir}/

#echo -n "packing normal sdk, size before zip : "
#du -sh ${release_dir}
#tar cjf mtksdk-${curdir}-${curdate}-${curtag}.full.tar.bz2  ${release_dir}
#ls -lh mtksdk-*

echo "copy prebuilt binary :"
cp ./bin/ramips/openwrt-ramips-*-squashfs-sysupgrade.bin ./
ls -lh mtksdk-*

# recover
echo "recover workspace!"
mv ${release_dir}/dl/* ./dl/
mv ${release_dir}/.git ./
mv ${release_dir}/feeds ./
echo "clean house"
rm -rf ${release_dir}

echo "job done!"
