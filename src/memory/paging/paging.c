#include "paging.h"
#include "memory/heap/kheap.h"

uint32_t* current_directory = 0;

void paging_load_directory(uint32_t* directory);

struct paging_4gb_chunk* paging_new_4gb(uint8_t flags) {
    // The page directory has 1024 total entries
    uint32_t* directory = kzalloc(sizeof(uint32_t) * PAGING_TOTAL_ENTRIES_PER_TABLE);
    int offset = 0;
    // Pages directories init loop
    for (int i = 0; i < PAGING_TOTAL_ENTRIES_PER_TABLE; i++) {
        // Page tables init loop
        uint32_t* entry = kzalloc(sizeof(uint32_t) * PAGING_TOTAL_ENTRIES_PER_TABLE);
        for (int j = 0; j < PAGING_TOTAL_ENTRIES_PER_TABLE; j++) {
            entry[j] = (offset + (j * PAGING_PAGE_SIZE)) | flags;
        }
        // Move offset to the next page
        offset += (PAGING_TOTAL_ENTRIES_PER_TABLE * PAGING_PAGE_SIZE);

        // The directory entry is writable at init
        directory[i] = (uint32_t) entry | flags | PAGING_IS_WRITEABLE; 
    }

    struct paging_4gb_chunk* chunk_4gb = kzalloc(sizeof(struct paging_4gb_chunk));
    chunk_4gb->directory_entry = directory;

    return chunk_4gb;
}

void paging_switch(uint32_t* directory) {
    paging_load_directory(directory);
    current_directory = directory;
}

uint32_t* paging_4gb_chunk_get_directory(struct paging_4gb_chunk* chunk) {
    return chunk->directory_entry;
}