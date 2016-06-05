#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
extern char *negatyw(char *bitmap, unsigned int rozmiar);// __asm__("_negatyw");
extern char *obroc(char *bitmap, unsigned int rozmiar);// __asm__("obroc");
extern char *rozjasnij(char *bitmap, unsigned int rozmiar);// __asm__("obroc");
extern char *mono(char *bitmap, unsigned int rozmiar);// __asm__("obroc");

struct BitMap
{
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
} Header;
 
int main( void )
{
  FILE *BMPFile = fopen ("Obrazek.bmp", "rb");
 
  memset(&Header, 0, sizeof(Header));
 
  fread(&Header.Type, 2, 1, BMPFile);
  fread(&Header.Size, 4, 1, BMPFile);
  fread(&Header.Reserve1, 2, 1, BMPFile);
  fread(&Header.Reserve2, 2, 1, BMPFile);
  fread(&Header.OffBits, 4, 1, BMPFile);
  fread(&Header.biSize, 4, 1, BMPFile);
  int HEADER_SIZE = Header.biSize;
  fread(&Header.biWidth, 4, 1, BMPFile);
  fread(&Header.biHeight, 4, 1, BMPFile);
  fread(&Header.biPlanes, 2, 1, BMPFile);
  fread(&Header.biBitCount, 2, 1, BMPFile);
  int SIZE = Header.biBitCount;
  fread(&Header.biCompression, 4, 1, BMPFile);
  fread(&Header.biSizeImage, 4, 1, BMPFile);
  int IMAGE_SIZE = Header.biSizeImage;
  fread(&Header.biXPelsPerMeter, 4, 1, BMPFile);
  fread(&Header.biYPelsPerMeter, 4, 1, BMPFile);
  fread(&Header.biClrUsed, 4, 1, BMPFile);
  fread(&Header.biClrImportant, 4, 1, BMPFile);
 
  printf("\nTyp: %s\n", Header.Type);
  printf("Rozmiar: %u\n", Header.Size);
  printf("Zarezerwowane 1: %hd\n", Header.Reserve1);
  printf("Zarezerwowane 2: %hd\n", Header.Reserve2);
  printf("Offset tablicy pikseli: %u\n", Header.OffBits);
  printf("Rozmiar naglowka DIB: %u\n", Header.biSize);
  printf("Szerokosc: %u\n", Header.biWidth);
  printf("Dlugosc: %u\n", Header.biHeight);
  printf("Wartstw: %hd\n", Header.biPlanes);
  printf("Bitow na piksel: %hd\n", Header.biBitCount);
  printf("Kompresja: %u\n", Header.biCompression);
  printf("Rozmiar bitmapy: %u\n", Header.biSizeImage);
  printf("Rozdzielczosc pozioma: %u\n", Header.biXPelsPerMeter);
  printf("Rozdzielczosc pionowa: %u\n", Header.biYPelsPerMeter);
  printf("Kolorow w palecie: %u\n", Header.biClrUsed);
  printf("Waznych kolorow: %u\n\n", Header.biClrImportant);
 
  printf("\n\n");
  fseek(BMPFile,0,0);
  char *header ;
  header = (char*) calloc (14+HEADER_SIZE, 1) ;
  int nread2 = fread (header, 1, 14+HEADER_SIZE,BMPFile) ;
  printf ("Przeczytano %d bajtow naglowka.\n", nread2) ;
 
  fseek(BMPFile, 14+HEADER_SIZE, 0);
  char *data ;
  data = (char*) calloc (IMAGE_SIZE, 1) ;
  int nread = fread (data, 1, IMAGE_SIZE,BMPFile) ;
  printf ("Przeczytano %d bajtow bitmapy.\n", nread) ;
  printf("\nWybierz operacje do wykonania:");
  printf("\n1. Negatyw");
  printf("\n2. Obroc");
  printf("\n3. Rozjasnij");
  printf("\n4. Zrob czaro biale");
  
  int wybor;
  scanf("%d",&wybor);
  if (wybor==1)
  {
  FILE *f = fopen ("negatyw.bmp", "wb");
  char *data2;
  data2 = negatyw(data,IMAGE_SIZE/8);
  fwrite(header,1,nread2,f);
  fseek(f,14+HEADER_SIZE,0);
  fwrite(data2,1,nread,f);
  fclose(f);
  }
  if (wybor==2)
  {
  FILE *f = fopen ("obrot.bmp", "wb");
  char *data2;
  data2 = obroc(data,IMAGE_SIZE/12);
  fwrite(header,1,nread2,f);
  fseek(f,14+HEADER_SIZE,0);
  fwrite(data2,1,nread,f);
  fclose(f);
  }
  if (wybor==3)
  {
  FILE *f = fopen ("rozjasnij.bmp", "wb");
  char *data2;
  data2 = rozjasnij(data,IMAGE_SIZE/8);
  fwrite(header,1,nread2,f);
  fseek(f,14+HEADER_SIZE,0);
  fwrite(data2,1,nread,f);
  fclose(f);
  }
  if (wybor==4)
  {
  FILE *f = fopen ("mono.bmp", "wb");
  char *data2;
  data2 = mono(data,IMAGE_SIZE/3);
  fwrite(header,1,nread2,f);
  fseek(f,14+HEADER_SIZE,0);
  fwrite(data2,1,nread,f);
  fclose(f);
  }
 
  fclose(BMPFile);
  return 0;
}