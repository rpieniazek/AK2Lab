#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char* negatyw(char *obraz, unsigned int rozmiar);
extern char* negatywBEZ(char *obraz, unsigned int rozmiar);
extern char* negateImage(char *obraz, unsigned int rozmiar);

char* rotateOY(unsigned char * buf, int width, int height) {

  char *linia = (char*) calloc (3,width); // alokujemy pamiec na jeden wiersz
  int i ;
  int bytesPerRow = 3*(width);
  for(i = 0; i < height/2 ; i++){
    memcpy(linia, buf + (bytesPerRow*i) , bytesPerRow);   //skopiowanie do tmp
    memcpy(buf + (bytesPerRow * i), buf+((height - 1 - i) * bytesPerRow), bytesPerRow); //skopiowanie lini
    memcpy(buf+((height - 1 - i) * bytesPerRow), linia, bytesPerRow); //skopiowanie z tmp do lini
  }
  return buf;
}

char* rotateOX(unsigned char * buf, int width, int height) {

  char *pixel = (char*) calloc (3,1); // alokujemy pamiec na jeden pixel
  int i,j ;
  int bytesPerRow = 3*(width);
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
  char Type[2];
  unsigned int Size;
  short Reserve1;
  short Reserve2;
  unsigned int OffBits;
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


int main(int argc, char *argv[]){
  FILE *zrodlo = fopen(argv[1], "rb");

  memset(&Naglowek, 0, sizeof(Naglowek));

  fread(&Naglowek.Type, 2, 1, zrodlo);
  fread(&Naglowek.Size, 4, 1, zrodlo);
  fread(&Naglowek.Reserve1, 2, 1, zrodlo);
  fread(&Naglowek.Reserve2, 2, 1, zrodlo);
  fread(&Naglowek.OffBits, 4, 1, zrodlo);
  fread(&Naglowek.biSize, 4, 1, zrodlo);
  int HEADER_SIZE = Naglowek.biSize;
  fread(&Naglowek.biWidth, 4, 1, zrodlo);
  fread(&Naglowek.biHeight, 4, 1, zrodlo);
  fread(&Naglowek.biPlanes, 2, 1, zrodlo);
  fread(&Naglowek.biBitCount, 2, 1, zrodlo);
  
  fread(&Naglowek.biCompression, 4, 1, zrodlo);
  fread(&Naglowek.biSizeImage, 4, 1, zrodlo);
  
  fread(&Naglowek.biXPelsPerMeter, 4, 1, zrodlo);
  fread(&Naglowek.biYPelsPerMeter, 4, 1, zrodlo);
  fread(&Naglowek.biClrUsed, 4, 1, zrodlo);
  fread(&Naglowek.biClrImportant, 4, 1, zrodlo);

  int SIZE = Naglowek.biBitCount;
  int IMAGE_SIZE = Naglowek.biSizeImage;
  fseek(zrodlo, 0, 0);
//przepisanie headera
  char *header;
  header = (char*) calloc(14+HEADER_SIZE, 1);
  int nread2 = fread(header, 1, 14+HEADER_SIZE, zrodlo);
  printf("size:%d, image Size: %d",SIZE, IMAGE_SIZE);
  fseek(zrodlo, 14+HEADER_SIZE, 0);
  char *data;
  data = (char*) calloc(IMAGE_SIZE, 1);
  int nread = fread(data, 1, IMAGE_SIZE, zrodlo);
  fclose(zrodlo);
	
  FILE *docelowy = fopen(argv[2], "wb");
  char *d;
	
  //d = rotateOY(data, Naglowek.biWidth, Naglowek.biHeight);
  //d = negateImage(data,IMAGE_SIZE);
  d = negatywBEZ(data, IMAGE_SIZE);
 // d = negatyw(data, IMAGE_SIZE/8);
  fwrite(header, 1, nread2, docelowy);
  fseek(docelowy, 14+HEADER_SIZE, 0);
  fwrite(d, 1, nread, docelowy);
  fclose(docelowy);
  return 0;
}
