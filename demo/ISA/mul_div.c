#include <stdio.h>
#include <stdlib.h>

double e(int i);
double f(int i);
double g(int i);
double h(int i);

int main(int argc, char **argv)
{
    int i;
    int option=0;
    double result[4194304][2];
    float tmp;
    option = atoi(argv[1]);
    
    if(option)
    {
        for(i = 0; i < 4194304; i++)
        {
            result[i][0] = e(i)/g(i);
            result[i][1] = f(i)/h(i);
        }
    }
    else
    {
        for(i = 0; i < 4194304; i++)
        {
            tmp = 1/(g(i)*h(i));
            result[i][0] = e(i)*h(i)*tmp;
            result[i][1] = f(i)*g(i)*tmp;
        }
    }
}

double e(int i)
{
    return rand()*0.00001;
}
double f(int i)
{
    return rand()*0.00001;
}
double g(int i)
{
    return rand()*0.00001;
}
double h(int i)
{
    return rand()*0.00001;
}
