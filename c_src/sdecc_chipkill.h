/*
 * Author: Mark Gottscho
 * Email: mgottscho@ucla.edu
 */

#include <stdint.h>

//[36,32,4]_16 SSCDSD ChipKill-correct (Kaneda1982) -- systematic form
//Everything in binary here
#define CODEWORD_SIZE 144
#define MESSAGE_SIZE 128
#define PARITY_SIZE (CODEWORD_SIZE - MESSAGE_SIZE)
#define SYMBOL_SIZE 4
#define ALPHABET_SIZE (1 << SYMBOL_SIZE)

#define CODEWORD_BITS_H_MASK ((uint64_t)(0xFFFF))
#define CODEWORD_BITS_M_MASK ((uint64_t)(0xFFFFFFFFFFFFFFFF))
#define CODEWORD_BITS_L_MASK ((uint64_t)(0xFFFFFFFFFFFFFFFF))

#define PARITY_BITS_H_MASK ((uint64_t)(0))
#define PARITY_BITS_M_MASK ((uint64_t)(0))
#define PARITY_BITS_L_MASK ((uint64_t)(0xFFFF))

#define MESSAGE_BITS_H_MASK CODEWORD_BITS_H_MASK
#define MESSAGE_BITS_M_MASK CODEWORD_BITS_M_MASK
#define MESSAGE_BITS_L_MASK (CODEWORD_BITS_L_MASK ^ PARITY_BITS_L_MASK)

typedef struct {
   uint64_t H;
   uint64_t M;
   uint64_t L;
} uint192_t;

typedef union {
   uint192_t val;
   char bytes[24];
} word_t;


//Kaneda1982 (144,128) H matrix
/*
1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   0   1   1   1   0   1   0   0   0   1   1   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   0   1   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   0   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0
0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   1   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   0   0   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0
0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   1   0   0   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0
0   1   1   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   1   1   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0
1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   0   1   1   0   0   0   0   1   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   0   0   0   1   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0
1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   1   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0
1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   1   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0
0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   0   1   1   1   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   0   0   0
0   1   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   0   0   0   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   0   1   1   0   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   0   0
0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   0   0   0   0   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   0   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   0
1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   0   0   0   0   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   0   0   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0
0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   0   1   1   1   1   0   0   0   0   1   1   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0
0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   1   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   0   1   0   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   0   1   1   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0
0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0   0   0   1   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   0   0   1   0   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   1   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   0
0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   0   0   1   0   1   0   0   0   0   1   0   0   0   0   1   1   0   0   0   1   1   0   0   1   1   1   0   1   1   1   1   0   0   0   1   1   1   1   1   1   1   1   0   1   1   0   0   1   0   0   0   0   0   0   1   0   0   1   0   0   1   0   0   1   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1
*/
uint192_t H_rows[16] = {
    {0x8888,0x8888100000000242,0x18cef747fec88000},
    {0x4444,0x4444900000000363,0x94218c6c81244000},
    {0x2222,0x2222400000000939,0x4218ce3ec8122000},
    {0x1111,0x1111200000000494,0x218cef9fec811000},
    {0x7fec,0x8124e88888888f00,0x00000074218c0800},
    {0xc812,0x4936144444444800,0x000000c639420400},
    {0xec81,0x2493822222222c00,0x000000e394210200},
    {0xfec8,0x1249c11111111e00,0x000000f942180100},
    {0x4218,0xcef707fec8124088,0x8888880000000080},
    {0x6394,0x218c0c8124936044,0x4444440000000040},
    {0x3942,0x18ce0ec812493022,0x2222220000000020},
    {0x9421,0x8cef0fec81249011,0x1111110000000010},
    {0x0000,0x000084218cef787f,0xec81248888880008},
    {0x0000,0x000046394218c4c8,0x1249364444440004},
    {0x0000,0x00002394218ce2ec,0x8124932222220002},
    {0x0000,0x0000194218cef1fe,0xc812491111110001}};

uint16_t H_columns[144] = {0x8710, 0x4fc0, 0x2b60, 0x1930, 0x8f20, 0x4b10, 0x29c0, 0x1860, 0x8b40, 0x4920, 0x2810, 0x14c0, 0x8980, 0x4840, 0x2420, 0x1210,
                           0x8890, 0x4480, 0x2240, 0x1120, 0x84b0, 0x4290, 0x2180, 0x1c40, 0x82f0, 0x41b0, 0x2c90, 0x1680, 0x8170, 0x4cf0, 0x26b0, 0x1390,
                           0x4b08, 0x2904, 0x1802, 0xc401, 0x0871, 0x04fc, 0x02b6, 0x0193, 0x08f2, 0x04b1, 0x029c, 0x0186, 0x08b4, 0x0492, 0x0281, 0x014c,
                           0x0898, 0x0484, 0x0242, 0x0121, 0x0889, 0x0448, 0x0224, 0x0112, 0x084b, 0x0429, 0x0218, 0x01c4, 0x082f, 0x041b, 0x02c9, 0x0168,
                           0x0817, 0x04cf, 0x026b, 0x0139, 0x2f08, 0x1b04, 0xc902, 0x6801, 0x1087, 0xc04f, 0x602b, 0x3019, 0x208f, 0x104b, 0xc029, 0x6018,
                           0x408b, 0x2049, 0x1028, 0xc014, 0x8089, 0x4048, 0x2024, 0x1012, 0x9088, 0x8044, 0x4022, 0x2011, 0xb084, 0x9042, 0x8021, 0x401c,
                           0xf082, 0xb041, 0x902c, 0x8016, 0x7081, 0xf04c, 0xb026, 0x9013, 0x1708, 0xcf04, 0x6b02, 0x3901, 0x7108, 0xfc04, 0xb602, 0x9301,
                           0xf208, 0xb104, 0x9c02, 0x8601, 0xb408, 0x9204, 0x8102, 0x4c01, 0x9808, 0x8404, 0x4202, 0x2101, 0x8908, 0x4804, 0x2402, 0x1201,
                           0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 0x0080, 0x0040, 0x0020, 0x0010, 0x0008, 0x0004, 0x0002, 0x0001};

#define SYNDROME_NO_ERROR 0

int parse_binary_string(const char* s, const size_t len, word_t* w);
int compute_syndrome(const word_t* received_string, uint64_t* syndrome);
word_t extract_message(const word_t codeword);
int compute_candidate_messages(const word_t received_string, word_t* candidate_messages, const size_t max_messages, size_t* num_messages);
int entropyZ_recovery(const word_t* candidate_messages, const size_t num_messages, const word_t* si, const size_t num_si, word_t* chosen_message);
