#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


extern char* negatyw(char *obraz, unsigned int rozmiar);
extern char* negatywBEZ(char *obraz, unsigned int rozmiar);
extern char* negateImage(char *obraz, unsigned int rozmiar);

char* rotateOX(unsigned char * buf, int width, int height) {

  char *linia = (char*) calloc (3,width); // alokujemy pamiec na jeden wiersz
  int i ;
  int bytesPerRow = 3*(width) + width % 4;
  for(i = 0; i < height/2 ; i++){
    memcpy(linia, buf + (bytesPerRow*i) , bytesPerRow);   //skopiowanie do tmp
    memcpy(buf + (bytesPerRow * i), buf+((height - 1 - i) * bytesPerRow), bytesPerRow); //skopiowanie lini
    memcpy(buf+((height - 1 - i) * bytesPerRow), linia, bytesPerRow); //skopiowanie z tmp do lini
  }
  return buf;
}

char* rotateOY(unsigned char * buf, int width, int height) {

  char *pixel = (char*) calloc (3,1); // alokujemy pamiec na jeden pixel
  int i,j ;
  int bytesPerRow = 3*(width) + width % 4;;
  for(i = 0; i < height ; i++){
    for(j = 0; j< width/2; j++){
      memcpy(pixel, buf + (bytesPerRow*i) + 3*j , 3);   //skopiowanie do tmp
      memcpy(buf + (bytesPerRow*i) + 3*j, buf + (bytesPerRow*i) + (width-j)*3, 3);  //skopiowanie lini
      memcpy(buf + (bytesPerRow*i) + 3*(width-j), pixel, 3); //skopiowanie z tmp do lini
    }
  }
return buf;

}

struct NaglowekBMP{
  char bfType[2];
  unsigned int bfSize;
  short bfReserve1;
  short bfReserve2;
  unsigned int bfOffBits;
  unsigned int biSize;
  unsigned int biWidth;
  unsigned int biHeight;
  short biPlanes;
  short biBitCount;
  unsigned int biCompression;
  unsigned int biSizeImage;
  unsigned int biXPelsPerMeter;
  unsigned int biYPelsPerMeter;
  unsigned int biClrUsed;
  unsigned int biClrImportant;
} Naglowek;


int64_t timespecDiff(struct timespec *timeA_p, struct timespec *timeB_p)
{
  return ((timeA_p->tv_sec * 1000000000) + timeA_p->tv_nsec) -
           ((timeB_p->tv_sec * 1000000000) + timeB_p->tv_nsec);
}




int main(int argc, char *argv[]){
  FILE *source = fopen(argv[1], "rb");

  memset(&Naglowek, 0, sizeof(Naglowek));

  fread(&Naglowek.bfType, 2, 1, source);
  fread(&Naglowek.bfSize, 4, 1, source);
  fread(&Naglowek.bfReserve1, 2, 1, source);
  fread(&Naglowek.bfReserve2, 2, 1, source);
  fread(&Naglowek.bfOffBits, 4, 1, source);
  fread(&Naglowek.biSize, 4, 1, source);
  fread(&Naglowek.biWidth, 4, 1, source);
  fread(&Naglowek.biHeight, 4, 1, source);
  fread(&Naglowek.biPlanes, 2, 1, source);
  fread(&Naglowek.biBitCount, 2, 1, source);
  fread(&Naglowek.biCompression, 4, 1, source);
  fread(&Naglowek.biSizeImage, 4, 1, source);
  fread(&Naglowek.biXPelsPerMeter, 4, 1, source);
  fread(&Naglowek.biYPelsPerMeter, 4, 1, source);
  fread(&Naglowek.biClrUsed, 4, 1, source);
  fread(&Naglowek.biClrImportant, 4, 1, source);

  int HEADER_bfSize = Naglowek.biSize;
  int bfSize = Naglowek.biBitCount;
  int IMAGE_bfSize = Naglowek.biSizeImage;


  fseek(source, 0, 0);//powrot na poczatek pliku
  //przepisanie headera
  char *header = (char*) calloc(14+HEADER_bfSize, 1);
  int nread2 = fread(header, 1, 14+HEADER_bfSize, source);
  
  FILE *docelowy = fopen(argv[2], "wb");
  char *d;
  fseek(source, 14+HEADER_bfSize, 0);
  
  char *data = (char*) calloc(IMAGE_bfSize, 1);
  int nread = fread(data, 1, IMAGE_bfSize, source);
  fclose(source);
	
 

  printf("%s\n", "Dostepne opcje:\n l - odbicie w pionie\n k - odbicie w poziomie\n j - negatyw(mmx) \nh - negatyw(bez MMX)\n");	
  char choose;
  scanf("%c", &choose);
  struct timespec start, end;
  switch(choose){
    case 'l':
      printf("%s\n", "odbicie w pionie...");
      d = rotateOY(data, Naglowek.biWidth, Naglowek.biHeight);
    break;
    case 'k':
      printf("%s\n", "odbicie w poziomie...");
      d = rotateOX(data, Naglowek.biWidth, Naglowek.biHeight);
    break;
    case 'j':

     //  printf("%s\n", "Tworzenie negatywu");
     //   // start timer
     // clock_gettime(CLOCK_MONOTONIC, &start);

      d = negatyw(data, IMAGE_bfSize/8);
//       clock_gettime(CLOCK_MONOTONIC, &end);
  //    int timeElapsed = timespecDiff(&end, &start);
      
    //  printf("%d",timeElapsed);
      
    
    break;
    case 'h':
      printf("%s\n", "Tworzenie negatywu");
      //clock_gettime(CLOCK_MONOTONIC, &start);
     // d = negatywBEZ(data, IMAGE_bfSize);
      d = negatyw(data, IMAGE_bfSize/8);
      //clock_gettime(CLOCK_MONOTONIC, &end);
     // int timeElapsed = timespecDiff(&end, &start);

     // printf("%d",timeElapsed);

    break;
    default:
      printf("%s\n", "Niepoprawny wybor, konczenie programu..");
      return(0);
  }

  //printf("bfSize:%d, image bfSize: %d",bfSize, IMAGE_bfSize);
   
  fwrite(header, 1, nread2, docelowy);
  fseek(docelowy, 14+HEADER_bfSize, 0);
  fwrite(d, 1, nread, docelowy);
  fclose(docelowy);
  return 0;
}
