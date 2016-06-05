#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int* getBitmapInfo(char* buffer);
extern int negateImage(char* buffer, int fileLenght);

//odczyt wartosci bitmapy
char* getBitmapContent(char* buffer, int* info) {
	return buffer + info[2];
}

//zapis pliku skopiowany z internetu
void saveFile(char *buffer, int fileLenght, char* name) {
	FILE *file;

	file = fopen(name, "wb");
	if(file != NULL) {
		fwrite(buffer, fileLenght, 1, file);
		fclose(file);
	} else {
		printf("Brak pliku");
	}
}

//odczyt długosci skopiowany z internetu
int getLenghtOfFile(char* src) {
	FILE *file;
	int filelen;

	file = fopen(src, "rb");
	if(file != NULL) {
		fseek(file, 0, SEEK_END);
		filelen = ftell(file);
		rewind(file);
	
		fclose(file);
	} else {
		printf("Brak pliku");
	}
	
	return filelen;
}

//odczyt pliku skopiowany z internetu 
char *readFile(char* src, int fileLenght) {
    FILE *file;
	char *buffer;
	
	buffer = (char *) malloc((fileLenght + 1) * sizeof(char));
	file = fopen(src, "rb");
	if(file != NULL) {
		fread(buffer, fileLenght, 1, file);
		fclose(file);
	} else {
		printf("Brak pliku");
	}
	return buffer;
}


int main() {
	char *processedImageName = "processed.bmp";
	char *fileName = "test.bmp";

	int fileLenght = getLenghtOfFile(fileName);
	char *buffer = readFile(fileName, fileLenght);
	int* info = getBitmapInfo(buffer);

	printf("Szerokosc: %d\n", info[0]);
	printf("Wysokosc: %d\n", info[1]);
	printf("Poczatek danych: %d\n", info[2]);
	printf("Wielkosc pliku: %d bajtów\n", info[3]);
	printf("Bitów na pixel: %d-bits\n", info[4]);
	printf("Typ kompresji: %d\n", info[5]);

	char *data = getBitmapContent(buffer, info);

	remove(processedImageName);
    negateImage(data, fileLenght);
	saveFile(buffer, fileLenght, processedImageName);

	return 0;
}
