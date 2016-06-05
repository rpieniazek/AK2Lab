
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "SDL/SDL.h"
#include "SDL/SDL_image.h"

extern char* negatyw(char *obraz, unsigned int rozmiar);

void rotateOY(unsigned char * buf, int width,int height) {

	char *linia = (char*) calloc (3,width); // alokujemy pamiec na jeden wiersz
	int i ;
	int bytesPerRow = 3*(width);
	for(i = 0; i < height/2 ; i++){
		memcpy(linia, buf + (bytesPerRow*i) , bytesPerRow); 	//skopiowanie do tmp
		memcpy(buf + (bytesPerRow * i), buf+((height - 1 - i) * bytesPerRow), bytesPerRow);	//skopiowanie lini
		memcpy(buf+((height - 1 - i) * bytesPerRow), linia, bytesPerRow); //skopiowanie z tmp do lini
	}
}

void rotateOX(unsigned char * buf, int width,int height) {

	char *pixel = (char*) calloc (3,1); // alokujemy pamiec na jeden pixel
	int i,j ;
	int bytesPerRow = 3*(width);
	for(i = 0; i < height ; i++){
		for(j = 0; j< width/2; j++){
			memcpy(pixel, buf + (bytesPerRow*i) + 3*j , 3); 	//skopiowanie do tmp
			memcpy(buf + (bytesPerRow*i) + 3*j, buf + (bytesPerRow*i) + (width-j)*3, 3);	//skopiowanie lini
			memcpy(buf + (bytesPerRow*i) + 3*(width-j), pixel, 3); //skopiowanie z tmp do lini
		}
	}
}

SDL_Surface* Load_image(char *file_name)
{
		/* Open the image file */
		SDL_Surface* tmp = IMG_Load(file_name);
		if ( tmp == NULL ) {
			fprintf(stderr, "Couldn't load %s: %s\n",
			        file_name, SDL_GetError());
				exit(0);
		}
		return tmp;	
}

void Paint(SDL_Surface* image, SDL_Surface* screen)
{
		SDL_BlitSurface(image, NULL, screen, NULL);
		SDL_UpdateRect(screen, 0, 0, 0, 0);
};





int main(int argc, char *argv[])
{
	Uint32 flags;
	SDL_Surface *screen, *image;
	int depth, done;
	SDL_Event event;

	/* Check command line usage */
	if ( ! argv[1] ) {
		fprintf(stderr, "Usage: %s <image_file>, (int) size\n", argv[0]);
		return(1);
	}


	/* Initialize the SDL library */
	if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
		fprintf(stderr, "Couldn't initialize SDL: %s\n",SDL_GetError());
		return(255);
	}

	flags = SDL_SWSURFACE;
	image = Load_image( argv[1] );
	//printf( "\n\nImage properts:\n" );
	//printf( "BitsPerPixel = %i \n", image->format->BitsPerPixel );
	printf( "BytesPerPixel = %i \n", image->format->BytesPerPixel );
	printf( "width %d ,height %d \n\n", image->w, image->h );	 	
	
	SDL_WM_SetCaption(argv[1], "showimage");
	
	/* Create a display for the image */
	depth = SDL_VideoModeOK(image->w, image->h, 32, flags);
	/* Use the deepest native mode, except that we emulate 32bpp
	   for viewing non-indexed images on 8bpp screens */
	if ( depth == 0 ) {
		if ( image->format->BytesPerPixel > 1 ) {
			depth = 32;
		} else {
			depth = 8;
		}
	} else
	if ( (image->format->BytesPerPixel > 1) && (depth == 8) ) {
    		depth = 32;
	}
	if(depth == 8)
		flags |= SDL_HWPALETTE;
	screen = SDL_SetVideoMode(image->w, image->h, depth, flags);
	if ( screen == NULL ) {
		fprintf(stderr,"Couldn't set %dx%dx%d video mode: %s\n",
			image->w, image->h, depth, SDL_GetError());
	}

	/* Set the palette, if one exists */
	if ( image->format->palette ) {
		SDL_SetColors(screen, image->format->palette->colors,
	              0, image->format->palette->ncolors);
	}


	/* Display the image */
	Paint(image, screen);

	done = 0;

	while ( ! done ) {
		if ( SDL_PollEvent(&event) ) {
			switch (event.type) {
			    case SDL_KEYUP:
				switch (event.key.keysym.sym) {
				    case SDLK_ESCAPE:
				    case SDLK_TAB:
				    case SDLK_q:
					done = 1;
					break;
				    case SDLK_SPACE:
				    case SDLK_k:
						SDL_LockSurface(image);
						
						printf("Start filtering...  ");
						rotateOY(image->pixels,image->w,image->h); 
						printf("Done.\n");

						SDL_UnlockSurface(image);
						
						printf("Repainting after filtered...  ");
						Paint(image, screen);
						printf("Done.\n");
						break;

				    case SDLK_l:
						SDL_LockSurface(image);
						
						printf("Start filtering...  ");
						rotateOX(image->pixels,image->w,image->h); 
						printf("Done.\n");

						SDL_UnlockSurface(image);
						
						printf("Repainting after filtered...  ");
						Paint(image, screen);
						printf("Done.\n");
						break;
				   	
				   	 case SDLK_n:
						SDL_LockSurface(image);
						
						printf("Start filtering...  ");
						int size = image->w * image->h*3 ;
						printf("%d\n", size);
						negatyw(image->pixels,size); 
						printf("Done.\n");

						SDL_UnlockSurface(image);
						
						printf("Repainting after filtered...  ");
						Paint(image, screen);
						printf("Done.\n");
						break;

				   case SDLK_s:
					printf("Saving surface at nowy.bmp ...");
					SDL_SaveBMP(image, "nowy.bmp" ); 
					printf("Done.\n");
				    default:
					break;
				}
				break;
//			    case  SDL_MOUSEBUTTONDOWN:
//				done = 1;
//				break;
                case SDL_QUIT:
				done = 1;
				break;
			    default:
				break;
			}
		} else {
			SDL_Delay(10);
		}
	}
	SDL_FreeSurface(image);
	/* We're done! */
	SDL_Quit();
	return(0);
}

