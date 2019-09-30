__kernel void bitonicsort(__global float *a, 
                        int j, int k)
{
    // get index of the work item
    int i = get_global_id(0);
    int ij=i^j;
//  printf("Working on %d %d\n",i,ij);
	if ((ij)>i) {
	  if ((i&k)==0 && a[i] > a[ij]) 
          {
              float t;
              t = a[i];
              a[i] = a[ij];
              a[ij] = t;
          }
	  if ((i&k)!=0 && a[i] < a[ij])
          {
              float t;
              t = a[i];
              a[i] = a[ij];
              a[ij] = t;
          }
	}
}

