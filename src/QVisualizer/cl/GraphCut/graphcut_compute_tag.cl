/**
 * COPYRIGHT NOTICE
 * Copyright (t) 2012, Institute of CG & CAD, Tsinghua University.
 * All Rights Reserved.
 * 
 * @file    *.cl
 * @brief   * functions definition.
 * 
 * This file defines *.
 * 
 * @version 1.0
 * @author  Jackie Pang
 * @e-mail  15pengyi@gmail.com
 * @date    2013/07/25
 */

#ifdef cl_image_2d

__kernel void graphcut_init_tag(
    const uint4 volumeSize, __global cl_cut *cutData,
    const uint4 groupSize, __global int* depthData
    )
{
    const int2 tid = (int2)(get_global_id(2) % groupSize.x, get_global_id(2) / groupSize.x);
    const int2 lid = (int2)(get_global_id(0), get_global_id(1));
    const int2 gid = lid + (int2)(cl_block_2d_x, cl_block_2d_y) * tid;
    if (gid.x >= volumeSize.x || gid.y >= volumeSize.y) return;

    const int gid1D = gid.x + volumeSize.x  * gid.y;
    const int lid1D = lid.x + cl_block_2d_x * lid.y;

    __local int localDone;
    if (lid1D == 0) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);
    
    __global cl_cut* cut = cutData + gid1D;
    if (cut->foreground > 0)
    {
        localDone = 1;
        cut->tag = CHAR_MAX;
    }
    else
    {
        cut->tag = 0;
    }
    barrier(CLK_LOCAL_MEM_FENCE);

    if (lid1D == 0) depthData[get_global_id(2)] = localDone ? (tid.x << cl_shift_2d_x) + (tid.y << cl_shift_2d_y) : (1 << 30) - 1;
}

__kernel void graphcut_compute_tag(
    const uint4 volumeSize, __global cl_cut *cutData,
    const uint4 groupSize, __global int4* listData,
    __global int* done
    )
{
    const int2 tid = listData[get_global_id(2)].xy;
    const int2 lid = (int2)(get_global_id(0), get_global_id(1));
    const int2 gid = lid + (int2)(cl_block_2d_x, cl_block_2d_y) * tid;
    if (gid.x >= volumeSize.x || gid.y >= volumeSize.y) return;
    
    const int lid1D = (lid.x + 1) + (cl_block_2d_x + 2) * (lid.y + 1);
    const int gid1D = (gid.x    ) + (volumeSize.x     ) * (gid.y    );

    __local char localDone;
    __local char tagDatat[(cl_block_2d_x + 2) * (cl_block_2d_y + 2)];
    __local char *tagt = tagDatat + lid1D;
    __local char *t0, *t1, *t2, *t3;

    __global cl_cut* cut = cutData + gid1D;
    __private char ot, t = ot = cut->tag;
    __private char o = cut->object;

    *tagt = t;

    if (o && t == 0)
    {
        t0 = tagt + 1,                   t3 = tagt - 1;
        t1 = tagt + (cl_block_2d_x + 2), t2 = tagt - (cl_block_2d_x + 2);
        
        if (gid.x == min(cl_block_2d_x * (tid.x + 1), (int)volumeSize.x) - 1)
            *t0 = gid.x < volumeSize.x - 1 ? (cut + 1)->tag : 0;
        if (lid.x == 0)
            *t3 = gid.x > 0                ? (cut - 1)->tag : 0;
        if (gid.y == min(cl_block_2d_y * (tid.y + 1), (int)volumeSize.y) - 1)
            *t1 = gid.y < volumeSize.y - 1 ? (cut + volumeSize.x)->tag : 0;
        if (lid.y == 0)
            *t2 = gid.y > 0                ? (cut - volumeSize.x)->tag : 0;
    }

    if (lid1D == cl_index_2d) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

    char globalDone = 1;
    while(!localDone)
    {
        barrier(CLK_LOCAL_MEM_FENCE);

        // if (lid1D == cl_index_2d) localDone = 1;
        localDone = 1;
        barrier(CLK_LOCAL_MEM_FENCE);

        if (o && t == 0)
        {
	        t |= *t0 | *t3 | *t1 | *t2;
            if (t == CHAR_MAX)
            {
                *tagt = t;
                localDone = globalDone = 0;
            }
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    if (!globalDone) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

    if (lid1D == cl_index_2d) if (!localDone) *done = 0;

    if (t != ot) cut->tag = t;
}

#else

__kernel void graphcut_init_tag(
    const uint4 volumeSize, __global cl_cut *cutData,
    const uint4 groupSize, __global int* depthData
    )
{
    int index = get_global_id(2);
    int3 tid = (int3)(0);
    tid.x = index % groupSize.x;
    index /= groupSize.x;
    tid.y = index % groupSize.y;
    index /= groupSize.y;
    tid.z = index;

    const int3 lid = (int3)(get_global_id(0), get_global_id(1) % cl_block_3d_y, get_global_id(1) / cl_block_3d_y);
    const int3 gid = lid + (int3)(cl_block_3d_x, cl_block_3d_y, cl_block_3d_z) * tid;
    if (gid.x >= volumeSize.x || gid.y >= volumeSize.y || gid.z >= volumeSize.z) return;

    const int lid1D = lid.x + cl_block_3d_x * (lid.y + cl_block_3d_y * lid.z);
    const int gid1D = gid.x + volumeSize.x  * (gid.y + volumeSize.y  * gid.z);

    __local int localDone;
    if (lid1D == 0) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);
    
    __global cl_cut* cut = cutData + gid1D;
    if (cut->foreground > 0)
    {
        localDone = 1;
        cut->tag = CHAR_MAX;
    }
    else
    {
        cut->tag = 0;
    }
    barrier(CLK_LOCAL_MEM_FENCE);

    if (lid1D == 0) depthData[get_global_id(2)] = localDone ? (tid.x << cl_shift_3d_x) + (tid.y << cl_shift_3d_y) + (tid.z << cl_shift_3d_z) : (1 << 30) - 1;
}

__kernel void graphcut_compute_tag(
    const uint4 volumeSize, __global cl_cut *cutData,
    const uint4 groupSize, __global int4* listData,
    __global int* done
    )
{
    const int3 tid = listData[get_global_id(2)].xyz;
    const int3 lid = (int3)(get_global_id(0), get_global_id(1) % cl_block_3d_y, get_global_id(1) / cl_block_3d_y);
    const int3 gid = lid + (int3)(cl_block_3d_x, cl_block_3d_y, cl_block_3d_z) * tid;
    if (gid.x >= volumeSize.x || gid.y >= volumeSize.y || gid.z >= volumeSize.z) return;

    const int lid1D = (lid.x + 1) + (cl_block_3d_x + 2) * ((lid.y + 1) + (cl_block_3d_y + 2) * (lid.z + 1));
    const int gid1D = (gid.x    ) + (volumeSize.x     ) * ((gid.y    ) + (volumeSize.y     ) * (gid.z    ));

    __local char localDone;
    __local char tagDatat[(cl_block_3d_x + 2) * (cl_block_3d_y + 2) * (cl_block_3d_z + 2)];
    __local char *tagt = tagDatat + lid1D;
    __local char *t0, *t1, *t2, *t3, *t4, *t5;

    __global cl_cut* cut = cutData + gid1D;
    __private char ot, t = ot = cut->tag;
    __private char o = cut->object;

    *tagt = t;

    if (o && t == 0)
    {
        t0 = tagt + 1,                   t5 = tagt - 1;
        t1 = tagt + (cl_block_3d_x + 2), t4 = tagt - (cl_block_3d_x + 2);
        t2 = tagt + (cl_block_3d_x + 2) * (cl_block_3d_y + 2);
        t3 = tagt - (cl_block_3d_x + 2) * (cl_block_3d_y + 2);
        
        const int volumeOffset = volumeSize.x * volumeSize.y;
        if (gid.x == min(cl_block_3d_x * (tid.x + 1), (int)volumeSize.x) - 1)
            *t0 = gid.x < volumeSize.x - 1 ? (cut + 1)->tag : 0;
        if (lid.x == 0)
            *t5 = gid.x > 0                ? (cut - 1)->tag : 0;
        if (gid.y == min(cl_block_3d_y * (tid.y + 1), (int)volumeSize.y) - 1)
            *t1 = gid.y < volumeSize.y - 1 ? (cut + volumeSize.x)->tag : 0;
        if (lid.y == 0)
            *t4 = gid.y > 0                ? (cut - volumeSize.x)->tag : 0;
        if (gid.z == min(cl_block_3d_z * (tid.z + 1), (int)volumeSize.z) - 1)
            *t2 = gid.z < volumeSize.z - 1 ? (cut + volumeOffset)->tag : 0;
        if (lid.z == 0)
            *t3 = gid.z > 0                ? (cut - volumeOffset)->tag : 0;
    }

    if (lid1D == cl_index_3d) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

    char globalDone = 1;
    while(!localDone)
    {
        barrier(CLK_LOCAL_MEM_FENCE);

        // if (lid1D == cl_index_3d) localDone = 1;
        localDone = 1;
        barrier(CLK_LOCAL_MEM_FENCE);
        
        if (o && t == 0)
        {
	        t |= *t0 | *t5 | *t1 | *t4 | *t2 | *t3;
            if (t == CHAR_MAX)
            {
                *tagt = t;
                localDone = globalDone = 0;
            }
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    if (!globalDone) localDone = 0;
    barrier(CLK_LOCAL_MEM_FENCE);

    if (lid1D == cl_index_3d) if (!localDone) *done = 0;

    if (t != ot) cut->tag = t;
}

#endif