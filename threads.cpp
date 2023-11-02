#include <iostream>
#include <cstdlib>
#include <thread>

using namespace std;

#define NUM_THREADS 5

void *PrintHello(void *threadid) {
   long tid;
   tid = (long)threadid;
   cout << "Hello World! Thread ID, " << tid << endl;
   pthread_exit(NULL);
}

void update(float *arr, int i){
    arr[i] = i;
}
void interval(float *arr, int i){
  for(int k = i; k < i + 1024; k++){
    cout<<"k = "<<k<<", ";
    update(arr,k);
  }
  cout<<endl;
}
int main () {
   float *arr = new float [4096];
   thread th1(interval, arr,0);
   thread th2(interval, arr,1024);
   thread th3(interval, arr,2048);
   thread th4(interval, arr,3072);
   th1.join();
   th2.join();
   th3.join();
   th4.join();

   for(int i = 0; i < 4096; i++){
      cout << arr[i] <<" ";
   }
   cout<<endl;/* 
   pthread_t threads[NUM_THREADS];
   int rc;
   int i;
   for( i = 0; i < NUM_THREADS; i++ ) {
    for( j = 0; j < )
      cout << "main() : creating thread, " << i << endl;
      rc = pthread_create(&threads[i], NULL, PrintHello, (void *)i);
      
      if (rc) {
         cout << "Error:unable to create thread," << rc << endl;
         exit(-1);
      }
   }
   pthread_exit(NULL); */
}