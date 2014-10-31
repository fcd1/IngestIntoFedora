#! /bin/sh

tmp_directory='tmp_addTifExtensionToFilename'
if [ -d $tmp_directory ]; then
    # Control will enter here if $DIRECTORY exists.
    echo $tmp_directory already exists, please delete manually first
    exit 2
else
    mkdir $tmp_directory    
fi

backup_files=false
args=`getopt b: $*`
# you should not use `getopt abo: "$@"` since that would parse
# the arguments differently from what the set command below does.
if [ $? != 0 ] 
then
    echo 'Usage: ...'
    exit 2
fi
set -- $args
# You cannot use the set command with a backquoted getopt directly,
# since the exit code from getopt would be shadowed by those of set,
# which is zero by definition.
for i
do
    case "$i"
        in
        -b)
            echo backup directory is "'"$2"'"; backup_directory_arg="$2"; shift;
	    backup_files=true
            shift;;
        --)
            shift; break;;
    esac
done
echo single-char flags: "'"$sflags"'"
echo backup directory is "'"$backup_directory_arg"'"

backup_directory=${backup_directory_arg%/}
if [ ! -d $backup_directory ]; then
    mkdir $backup_directory    
fi

for x
do
    echo "editing $x: \c"
    if test -s $x; then 
	sed 's/\(<identifier type="local">\)\(.*\)\(<\/identifier>\)/\1peopleinbooks_\2\3/' $x > $tmp_directory/$x$$
	if test -s $tmp_directory/$x$$
	then 
	    if cmp -s $x $tmp_directory/$x$$
	    then
		echo "file not changed: \c"
            else
		if [ $backup_files == true ]
		then
	    # fcd1, 17Sep14: make the following optional via command line option which
	    # specifies the backup directory
		    mv $x $backup_directory/$x.bak  # save original, just in case
		fi
		cp $tmp_directory/$x$$ $x
            fi
            echo "done"
	else 
            echo "Sed produced an empty file\c"
            echo " - check your sedscript."
	fi
    else
	echo "original file is empty."
    fi
done

rm -r $tmp_directory

echo "all done"