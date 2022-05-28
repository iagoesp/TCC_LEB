#include <string>
#include <vector>
#include <fstream>
#include "lodepng.h"
#include "simplex.h"

using namespace std;
typedef unsigned int uint;
int* read_png(const string path, uint& width, uint& height) {
    vector<u_char> img;
    lodepng::decode(img, width, height, path, LCT_RGB);
    int* data = new int[width*height];
    for(uint i=0; i<width*height; i++) {
        data[i] = img[3*i]<<16|img[3*i+1]<<8|img[3*i+2];
    }
    return data;
}
void write_png(const string path, const uint width, const uint height) {
    printf("write");
    u_char* img = new u_char[3*width*height];
    for(uint i=0; i<width*height; i++) {
        float t;
        t = Simplex::fBm(i, 32, 0.99f, 0.98f)*255;
        //printf("%i\n",i);
        const int color = t;
        img[3*i  ] = (color>>16)&255;
        img[3*i+1] = (color>> 8)&255;
        img[3*i+2] =  color     &255;
    }
    //printf("%i\n",i);
    lodepng::encode(path, img, width, height, LCT_RGB);
    delete[] img;
}

int main(){
    string path = "/home/iago/Desktop/UFBA/LongestEdgeBisection2D/assets/test.png";
    uint width = 3601;
    uint height = 3601;
    write_png(path, width, height);
    return 0 ;
}