#ifndef GRID_H
#define GRID_H

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <time.h>
#include "simplex.h"
#include <glm/glm.hpp>

typedef struct {
    int width;
    int height;
    unsigned char ** mat;
} grid_t;

grid_t * create_grid(int width, int height) {
    grid_t * grid = new grid_t;
    grid->width = width;
    grid->height = height;
    grid->mat = new unsigned char*[height];
    int i = 0;
    for(; i < height; i++){
        grid->mat[i] = new unsigned char[width];
    }
    return grid;
}

grid_t * clone_grid(grid_t * grid) {
    grid_t * clone = create_grid(grid->width, grid->height);
    int i = 0;
    for(; i < clone->height; i++){
        int j = 0;
        for(; j < clone->width; j++){
            clone->mat[i][j] = grid->mat[i][j];
        }
    }
    return clone;
}

bool init_rand(grid_t * grid) {
    bool v = false;
    int i = 0;
    for(; i < grid->height; i++) {
        int j = 0;
        for(; j < grid->width; j++) {
            //grid->mat[i][j] = rand_2();
            int octaves = 8;
            float gain = 0.08f;
            float lacunarity = 0.08f;
            glm::vec2 pos = glm::vec2(i,j);

            //float n = Simplex::iqMatfBm(pos, octaves, glm::mat2(2.3f, -1.5f, 1.5f, 2.3f), gain);
            float n = Simplex::iqfBm(pos, octaves, lacunarity, gain)*0.5f;

            //octaves += 3;
            //gain += 0.5f;
            //lacunarity += 0.03f;
            //float m = Simplex::iqfBm(pos, octaves, lacunarity, gain);
            //printf("N: %f, ", n);
            //n += Simplex::ridgedMF(pos, 1.0f, octaves, 2.0f, gain+0.1f);
            //printf("N: %f, ", n);
            //n += Simplex::worleyfBm(pos, octaves, 2.0f, gain + 0.2f);
            //printf("N: %f \n", n);
            //glm::normalize(n);
            //grid->mat[i][j] = ((n*1.25+m*0.75)/2)*255;
            grid->mat[i][j] = n*255;
        }
    }
    v = true;
    return v;
}


void free_grid(grid_t * grid) {
    int i = 0;
    for(; i < grid->height; i++) {
        free(grid->mat[i]);
    }
    free(grid->mat);
}

#endif // GRID_H