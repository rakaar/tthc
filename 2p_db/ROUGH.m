data_path = 'G:\TTHC_2p_21032023_data';
dir_path = dir(data_path);
for i=3:length(dir_path)
   new_path = strcat(data_path, '\', dir_path(i).name);
   new_dir = dir(new_path);
   for j=3:length(new_dir)
       animal_path = strcat(new_path, '\', new_dir(j).name);
       animal_dir = dir(animal_path);
       for k=3:length(animal_dir)
           loc_path = strcat(animal_path, '\', animal_dir(k).name);
           loc_dir = dir(loc_path);
           found = 0;
           for p=3:length(loc_dir)
                if loc_dir(p).isdir == 1 && strcmp(loc_dir(p).name, 'analysed')
                    online_path = dir(strcat(loc_path,'\analysed'));
                        for q=3:length(online_path)
                            if online_path(q).isdir == 1 && strcmp(online_path(q).name, 'ONLINEANALYSISRESULTS')
                                found = 1;
                                break
                            end
                        end

                        if found == 1
                            break
                        end
                end
           end
           if found == 0
                disp(loc_path)
           end
       end
   end
end