#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char* _rozjasnienie(char *obraz, unsigned int rozmiar);
extern char* _rozjasnienie_bez_MMX(char *obraz, unsigned int rozmiar);
extern char* _negatyw(char *obraz, unsigned int rozmiar);
extern char* _negatyw_bez_MMX(char *obraz, unsigned int rozmiar);

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
  FILE *zrodlo = fopen(argv[2], "rb");

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
  int SIZE = Naglowek.biBitCount;
  fread(&Naglowek.biCompression, 4, 1, zrodlo);
  fread(&Naglowek.biSizeImage, 4, 1, zrodlo);
  int IMAGE_SIZE = Naglowek.biSizeImage;
  fread(&Naglowek.biXPelsPerMeter, 4, 1, zrodlo);
  fread(&Naglowek.biYPelsPerMeter, 4, 1, zrodlo);
  fread(&Naglowek.biClrUsed, 4, 1, zrodlo);
  fread(&Naglowek.biClrImportant, 4, 1, zrodlo);

  fseek(zrodlo, 0, 0);
  char *header;
  header = (char*) calloc(14+HEADER_SIZE, 1);
  int nread2 = fread(header, 1, 14+HEADER_SIZE, zrodlo);

  fseek(zrodlo, 14+HEADER_SIZE, 0);
  char *data;
  data = (char*) calloc(IMAGE_SIZE, 1);
  int nread = fread(data, 1, IMAGE_SIZE, zrodlo);
  fclose(zrodlo);

  FILE *docelowy = fopen(argv[3], "wb");
  char *d;
  switch(atoi(argv[1])){
  	case 1:
  		d = _rozjasnienie(data, IMAGE_SIZE/8);
  		break;
  	case 2:
  		d = _rozjasnienie_bez_MMX(data, IMAGE_SIZE);
  		break;
  	case 3:
  		d = _negatyw(data, IMAGE_SIZE/8);
  		break;
  	case 4:
  		d = _negatyw_bez_MMX(data, IMAGE_SIZE/4);
  		break;
  }
  fwrite(header, 1, nread2, docelowy);
  fseek(docelowy, 14+HEADER_SIZE, 0);
  fwrite(d, 1, nread, docelowy);
  fclose(docelowy);
  return 0;
}
