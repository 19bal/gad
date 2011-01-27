% demo gait analysis
clear all; close all;  clc;
dbg = true;

mkdir(pathos('_db/'));
dbnm = pathos('_db/original/'); 
dbnm_bw = pathos('_db/bw/');

bg = bgmodel(dbnm, dbg);
frm2bw_db(dbnm, dbnm_bw, bg, dbg);


