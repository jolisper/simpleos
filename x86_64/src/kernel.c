void main() {
    // Create a pointer to char, and point it to the first tet cell of 
    // video memory (i.e. the top-left of the screen)
    char* video_memory = (char*) 0xb8000;
    // At the address pointed to by video_memory, store the character 'X'
    // (i.e. display 'X' in the top-left fo the screen).
    *video_memory = 'X';
}