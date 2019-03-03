# ntu_rgb-d_skeleton_process
This code is designed for the pretreatment of skeleton in NTU RGB+D action recognition datasets. If you find any bug, please contact me. Thanks!~
1、parameter settings：
“path_to_dataset” mean The storage path of the original skeleton data.
“save_to_mat” mean The storage path of the processed mat file
2、generated mat file：
Each skeleton file corresponds to a mat file, this mat file including one or two people skeleton data named "kb" or "kb2". Attention, The program will automatically ignore the skeleton data of the third person.
The form of each skeleton data is "F x 75", where "F" means the number of frame for this sample. "75" means "3 x 25" where "25" means the number of joint points included in each frame of skeleton data. Arranged form are: "x1 y1 z1 x2 y2 z2 x3 y3 z3 ... ... x25 y25 z25".
