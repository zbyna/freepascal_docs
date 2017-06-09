#!/usr/bin/env bash
#
# Script to generate CHM docs. 
# (C) 2009 Marco van de Voort Initial version
# 
# Needs more errorchecking.

# export FPCSRCDIR=/fpc/fpc
export FPCSRCDIR=e:/Development/fpcsrc
export MAKEDIR=e:/Development/fpc/bin/i386-win32
export MAKESKEL=e:/Development/fpc/bin/i386-win32
# css file for rtl, fpc and fpcres  chms , default is $FPCSCRDIR/utils/fpdoc/fpdoc.css
export CSSFILE=css/main/fpdoc.css
# css dir for user, prog, ref and fpdoc chms
export CSSOTHERS=css/others

$MAKEDIR/make.exe HTMLFMT=chm html CSSFILE=$CSSFILE FPDOC=$MAKEDIR/fpdoc.exe FPCSRCDIR=$FPCSRCDIR MAKESKEL=$MAKEDIR | tee buildlog.txt

$MAKEDIR/fpc.exe relinkdocs.pp
$MAKEDIR/fpc.exe compilelatexchm.pp
$MAKEDIR/fpc.exe gentoc


./relinkdocs
rm -rf prog-old
rm -rf ref-old
rm -rf user-old
mv prog prog-old
mv ref ref-old
mv user user-old
mv prog-fixed  prog
mv ref-fixed ref
mv user-fixed user

cp prog-old/*.png prog
cp prog-old/*.kwd prog
cp prog-old/*.css prog
cp user-old/*.png user
cp user-old/*.kwd user
cp user-old/*.css user
cp ref-old/*.png ref
cp ref-old/*.kwd ref
cp ref-old/*.css ref

# copy custom css for user, prog, ref and fpdoc
cp $CSSOTHERS/user.css user
cp $CSSOTHERS/prog.css prog
cp $CSSOTHERS/ref.css ref
cp $CSSOTHERS/fpdoc.css fpdoc

./compilelatexchm prog "Programmer's Guide"
./compilelatexchm user "User's Guide"
./compilelatexchm ref "Reference Guide"  ref/ref.kwd
./compilelatexchm fpdoc "FPDoc documentation"
 
./gentoc . .
