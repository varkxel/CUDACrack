#ifndef HPC3_CRACKCUDA_CRYPT_CUH
#define HPC3_CRACKCUDA_CRYPT_CUH

/*
 * Password alloc size is 11.
 * Password size is 10.
 */

__device__ void CUDACrypt(const char* rawPassword, char newPassword[11]);

#endif