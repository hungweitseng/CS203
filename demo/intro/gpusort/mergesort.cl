__kernel void mergesort(__global float *data,
                       __global float *work,
                       int k,
                       int num_of_elements)
{
    // get index of the work item
    int index = get_global_id(0);
    
    int l = index * 2 * k;
    int m = (l + k) < num_of_elements ? l + k : num_of_elements;
    int r = (l + 2 * k) < num_of_elements ? l + 2 * k : num_of_elements;
    
    int first = l;
    int second = m;
    
    for (int i = l; i < r; i++)
    {
        if (first < m && (second >= r || data[first] <= data[second]))
        {
            work[i] = data[first];
            first += 1;
        }
        else
        {
            work[i] = data[second];
            second += 1;
        }
    }
}

