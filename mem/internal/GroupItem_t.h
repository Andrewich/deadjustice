/* Private header size for allocated memory block. */
#define BLOCK_HEADER_SIZE 48


typedef struct GroupItem
{
   char           groupName[12];
   int               id;
   int               size;
   struct GroupItem* next;
   struct GroupItem* prev;
   struct Group*     group;
} GroupItem_t;
