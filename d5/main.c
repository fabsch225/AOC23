#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

int main(void) {
    FILE* filePointer;

    char* token;
    char* string;
    char* split;

    int bufferLength = 255;
    int at_line = 0;

    int indices[] = {3,33,36,82,85,129,132,174,177,196,199,215,218,235};
    long long int seeds[20];
    
    long long int paths[170];

    long long int vals[7][47][3];

    char buffer[bufferLength];

    filePointer = fopen("C:/Users/fschuller/Documents/advent_of_code/d5/in.txt", "r");

    while(fgets(buffer, bufferLength, filePointer)) {
        string = buffer;
        split = string;

        

        if (at_line == 0) {
            token = strtok(split, " ");
            int i;
            for (i = 0; i < 20; ++i) {
                token = strtok(NULL, " ");
                long long int num = atoll(token);
                seeds[i] = num;
            }
        }
        else {
            int i;
            for (i = 0; i < 7; ++i) {
                int s = indices[i * 2];
                int e = indices[i * 2 + 1];

                if (at_line <= e && at_line >= s) {
                    token = strtok(split, " ");
                    long long int num = atoll(token);
                    vals[i][at_line - s][0] = num;
                    token = strtok(NULL, " ");
                    num = atoll(token);
                    vals[i][at_line - s][1] = num;
                    token = strtok(NULL, " ");
                    num = atoll(token);
                    vals[i][at_line - s][2] = num;
                    //printf("AT %d %d %d  \n", at_line, s, e);
                    printf("%d \n", i);
                    printf("LINE %lld  %lld  %lld \n", vals[i][at_line - s][0], vals[i][at_line - s][1], vals[i][at_line - s][2]);
                }
            }
        }
        at_line = at_line + 1;
    }

    
    long long int end = LONG_LONG_MAX;
    long long int start = 60000000;
    printf("letsgo \n");

    long long int ev;

    for (ev = start; ev < end; ++ev) {
        int j;
        long long int v_ = ev;
        //printf("%lld \n", v_);
        for (j = 6; j >= 0; --j) {
            int len = indices[j * 2 + 1] - indices[j * 2];

            int k;
            for (k = 0; k < len; ++k) {
                long long int rs = vals[j][k][1];
                long long int rd = vals[j][k][0];
                long long int r = vals[j][k][2];
               
                if (v_ >= rd && v_ <= rd + r) {
                    //printf("%lld %lld \n", rs, r); 

                    v_ = rs + v_ - rd;
                    break;
                }
            }
        }
        
        int k;
        for (k = 0; k < 10; ++k) {
            long long int rs = seeds[k * 2];
            long long int r = seeds[k * 2 + 1];

            if (v_ >= rs && v_ <= rs + r) {                      
                printf("%lld %lld \n", rs, r);
                printf("%lld \n", v_);
                printf("%lld \n", ev);
                return 0;
            }
        }
    }

    printf("nothing");
    fclose(filePointer);
}

/*long long int translate(long long int value, long long int layer[47][3]) {
    int len = indices[j * 2 + 1] - indices[j * 2];
    long long int v_ = value;
    int k;
    for (k = 0; k < len; ++k) {
        long long int rs = layer[k][1];
        long long int r = layer[k][2];

        if (v_ >= rs && v_ <= rs + r) {                      
            v_ = layer[k][0] + v_ - rs;
            break;
        }
    }

    return v_;
}*/