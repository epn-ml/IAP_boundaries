from pymatreader import read_mat
import matplotlib.pyplot as plt
import pandas as pds
import numpy as np
import matplotlib
import datetime
import os

def filelists(cx,path):
    filelist = [filename for filename in os.listdir(path) if filename.startswith(cx)]
    return filelist

def loadfromlist(name,path):
    data = read_mat(path + '/' + name)
    return data

def get_cishia(year,sc):
    
    path = 'CAAMAT/hia_onboard_mom'
    cx = sc + '_cishia_onboard_mom__'+year
    
    filelist = sorted(filelists(cx,path))
    
    init = True
    
    while init == True:
        
        try:

            cishia = loadfromlist(filelist[0],path)

            time = matplotlib.dates.num2date(cishia['ttags'], tz=None)

            df = pds.DataFrame(cishia['data'][3,:].T, index=time, columns=['dens'])

            df.index = pds.to_datetime(df.index, format="%Y/%m/%d %H:%M")
            df.index = df.index.tz_localize(None)
            df.index = df.index - datetime.timedelta(366)

            df['tpar'] = cishia['data'][11,:]
            df['tperp'] = cishia['data'][12,:]
            df['vel_gse_x'] = cishia['data'][7,:]
            df['vel_gse_y'] = cishia['data'][8,:]
            df['vel_gse_z'] = cishia['data'][9,:]

            df['v_abs'] = np.sqrt(df['vel_gse_x']**2 + df['vel_gse_y']**2 + df['vel_gse_z']**2)
            
            init = False
        except IndexError:
            print('ERROR: NO INITIAL DataFrame for ' + str(filelist[0]))
            del filelist[0]
    
    for i in range(1,len(filelist)):
        cishia = loadfromlist(filelist[i],path)
    
        time = matplotlib.dates.num2date(cishia['ttags'], tz=None)
        try:
            df2 = pds.DataFrame(cishia['data'][3,:].T, index=time, columns=['dens'])

            df2.index = pds.to_datetime(df2.index, format="%Y/%m/%d %H:%M")
            df2.index = df2.index.tz_localize(None)
            df2.index = df2.index - datetime.timedelta(366)

            df2['tpar'] = cishia['data'][11,:]
            df2['tperp'] = cishia['data'][12,:]
            df2['vel_gse_x'] = cishia['data'][7,:]
            df2['vel_gse_y'] = cishia['data'][8,:]
            df2['vel_gse_z'] = cishia['data'][9,:]

            df2['v_abs'] = np.sqrt(df2['vel_gse_x']**2 + df2['vel_gse_y']**2 + df2['vel_gse_z']**2)
            df = pds.concat([df, df2])

        except IndexError:
            print('ERROR: NO DataFrame for ' + str(filelist[i]))
    
    print(df)
    df.to_pickle("IAP_Boundaries/data/"+ sc + "_cishia_onboard_mom_" + year + ".pkl")

    
def get_fgm_5vps(year, sc):
    
    path = 'CAAMAT/5vps'
    cx = sc + '_fgm_5vps__'+year
    
    filelist = sorted(filelists(cx,path))
    
    init = True
    
    while init == True:
        
        try:

            fgm = loadfromlist(filelist[0],path)

            time = matplotlib.dates.num2date(fgm['ttags'], tz=None)

            df = pds.DataFrame(fgm['data'][0:3,:].T, index=time, columns=['b_gse_x','b_gse_y','b_gse_z'])

            df.index = pds.to_datetime(df.index, format="%Y/%m/%d %H:%M")
            df.index = df.index.tz_localize(None)
            df.index = df.index - datetime.timedelta(366)

            df['b_abs'] = np.sqrt(df['b_gse_x']**2 + df['b_gse_y']**2 + df['b_gse_z']**2)
            
            init = False
        except IndexError:
            print('ERROR: NO INITIAL DataFrame for ' + str(filelist[0]))
            del filelist[0]
    
    for i in range(1,len(filelist)):
        fgm = loadfromlist(filelist[i],path)
    
        time = matplotlib.dates.num2date(fgm['ttags'], tz=None)
        try:
            df2 = pds.DataFrame(fgm['data'][0:3,:].T, index=time, columns=['b_gse_x','b_gse_y','b_gse_z'])

            df2.index = pds.to_datetime(df2.index, format="%Y/%m/%d %H:%M")
            df2.index = df2.index.tz_localize(None)
            df2.index = df2.index - datetime.timedelta(366)

            df2['b_abs'] = np.sqrt(df2['b_gse_x']**2 + df2['b_gse_y']**2 + df2['b_gse_z']**2)
            df = pds.concat([df, df2])

        except IndexError:
            print('ERROR: NO DataFrame for ' + str(filelist[i]))
    
    print(df)
    df.to_pickle("IAP_Boundaries/data/" + sc + '_fgm_5vps_' + year + ".pkl")
