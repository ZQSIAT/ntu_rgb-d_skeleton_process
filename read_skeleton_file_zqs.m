clear
clc
max_repeat=2;
max_people=40;
max_action=60;
max_camera=3;
max_set=17;
path_to_dataset = 'F:\ntu_rgbd_skeleton_process\ntu_rgbd_skeletons';
save_to_mat = 'F:\ntu_rgbd_skeleton_process\mat_ntu_skeleton';
for i=1:max_repeat
    for j=1:max_people
        for k=1:max_action
            for l=1:max_camera
                for m=1:max_set
                    r_i=sprintf('%03d',i);
                    p_j=sprintf('%03d',j);
                    a_k=sprintf('%03d',k);
                    c_l=sprintf('%03d',l);
                    s_m=sprintf('%03d',m);                    
                    file = sprintf('%s\\S%sC%sP%sR%sA%s.skeleton',path_to_dataset,s_m,c_l,p_j,r_i,a_k);
                    save_mat_file = sprintf('%s\\S%sC%sP%sR%sA%s.mat',save_to_mat,s_m,c_l,p_j,r_i,a_k);
                    if exist(file, 'file')                         
                        bodyinfo = read_skeleton_file(file);
                        temp_kb = [];
                        temp_kb2 = [];
                        for n=1:size(bodyinfo,2)
                            if ~isstruct(bodyinfo(n).bodies)
                                continue; 
                            end 
                            % two people skeleton case
                            if size(bodyinfo(n).bodies,2) > 1  
                                temp_kb = [temp_kb;bodyinfo(n).bodies(1).joints];
                                temp_kb2 = [temp_kb2;bodyinfo(n).bodies(2).joints];                                
                            % one people skeleton case 
                            else
                                temp_kb = [temp_kb;bodyinfo(n).bodies(1).joints];                                                               
                            end
                        end
                        if isstruct(temp_kb2)
                            flag_two_people = 0;
                            kb = [];
                            kb2 = [];
                            for ii=1:25                          
                                kb = [kb;[temp_kb(:,ii).x;temp_kb(:,ii).y;temp_kb(:,ii).z]];   
                                kb2 = [kb2;[temp_kb2(:,ii).x;temp_kb2(:,ii).y;temp_kb2(:,ii).z]];
                            end
                            kb = kb';
                            kb2 = kb2';
                            save(save_mat_file,'kb','kb2');
                        else
                            kb = [];
                            for ii=1:25                          
                                kb = [kb;[temp_kb(:,ii).x;temp_kb(:,ii).y;temp_kb(:,ii).z]];   
                            end
                            kb = kb';
                            save(save_mat_file,'kb');
                        end 
                                               
%                         % two people skeleton case
%                         if size(bodyinfo(1).bodies,2) > 1
%                             temp_kb = [];
%                             temp_kb2 = [];                            
%                             for n=1:size(bodyinfo,2)
%                                 temp_kb = [temp_kb;bodyinfo(n).bodies(1).joints];
%                                 if size(bodyinfo(n).bodies,2) > 1
%                                     temp_kb2 = [temp_kb2;bodyinfo(n).bodies(2).joints];  
%                                 end
%                                 % size(bodyinfo(n).bodies)
%                             end
%                             kb = [];
%                             kb2 = [];
%                             for ii=1:25                          
%                                 kb = [kb;[temp_kb(:,ii).x;temp_kb(:,ii).y;temp_kb(:,ii).z]];   
%                                 kb2 = [kb2;[temp_kb2(:,ii).x;temp_kb2(:,ii).y;temp_kb2(:,ii).z]];
%                             end
%                             kb = kb';
%                             kb2 = kb2';
%                             save(save_mat_file,'kb','kb2');
%                         % one people skeleton case 
%                         else
%                             temp_kb = [];
%                             for n=1:size(bodyinfo,2)                                
%                                 temp_kb = [temp_kb;bodyinfo(n).bodies(1).joints];                                
%                                 % size(bodyinfo(n).bodies)
%                             end
%                             kb = [];
%                             for ii=1:25                          
%                                 kb = [kb;[temp_kb(:,ii).x;temp_kb(:,ii).y;temp_kb(:,ii).z]];   
%                             end
%                             kb = kb';
%                             save(save_mat_file,'kb');
%                         end                                                
                    end
%                     break;
                end
%                 break;
            end
%             break;
        end
%         break;
    end
    
end


function bodyinfo = read_skeleton_file(filename)
% Reads an .skeleton file from "NTU RGB+D 3D Action Recognition Dataset".
% Argrument:
%   filename: full adress and filename of the .skeleton file.
fileid = fopen(filename);
framecount = fscanf(fileid,'%d',1); % no of the recorded frames
bodyinfo=[]; % to store multiple skeletons per frame
for f=1:framecount
    bodycount = fscanf(fileid,'%d',1); % no of observerd skeletons in current frame
    for b=1:bodycount
        clear body;
        body.bodyID = fscanf(fileid,'%ld',1); % tracking id of the skeleton        
        fscanf(fileid,'%d',6); % read 6 integers
        fscanf(fileid,'%f',2);
        fscanf(fileid,'%d',1);        
        body.jointCount = fscanf(fileid,'%d',1); % no of joints (25)
        joints=[];
        for j=1:body.jointCount
            jointinfo = fscanf(fileid,'%f',11);
            joint=[];            
            % 3D location of the joint j
            joint.x = jointinfo(1);
            joint.y = jointinfo(2);
            joint.z = jointinfo(3);
            fscanf(fileid,'%d',1);            
            body.joints(j)=joint;
        end
        bodyinfo(f).bodies(b)=body;
    end
end
fclose(fileid);
end