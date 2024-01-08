#include "Crack.cuh"
#include "Crypt.cuh"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// Constants
#define CharIterations ('Z' - 'A') + 1
#define NumIterations  ('9' - '0') + 1
#define MaxIndex       CharIterations * CharIterations * NumIterations * NumIterations

// GPU Constants
__device__ const long CharIterations_CUDA = CharIterations;
__device__ const long NumIterations_CUDA = NumIterations;
__device__ const long MaxIndex_CUDA = MaxIndex;

__device__ char device_result[5];
__device__ bool result_found = false;

__global__ void CUDACrack(const char* encryptedPassword)
{
	// Get the current index & return if out of bounds
	long index = blockIdx.x * blockDim.x + threadIdx.x;
	if(index >= MaxIndex) return;
	
	// Create the string to encrypt
	char* str = "AA00";
	str[3] += (index) % NumIterations_CUDA;
	str[2] += (index / (NumIterations_CUDA)) % NumIterations_CUDA;
	str[1] += (index / (NumIterations_CUDA * NumIterations_CUDA)) % CharIterations_CUDA;
	str[0] += (index / (NumIterations_CUDA * NumIterations_CUDA * CharIterations_CUDA)) % CharIterations_CUDA;
	
	// Get the encrypted string
	char encrypted[11];
	CUDACrypt(str, encrypted);
	
	// strcomp()
	bool equal = true;
	for(int i = 0; i < 11; i++) equal &= encryptedPassword[i] == encrypted[i];
	
	if(equal)
	{
		// Copy string to result
		for(int i = 0; i < 4; i++) device_result[i] = str[i];
		device_result[4] = '\0';
		result_found = true;
	}
}

int main(int argc, char** argv)
{
	bool encrypted_allocated = false;
	char* encrypted = NULL;
	if(argc < 2)
	{
		printf("Enter encrypted password to crack: ");
		encrypted = (char*) malloc(128 * sizeof(char));
		encrypted[127] = '\0';
		scanf("%127s", encrypted);
		encrypted_allocated = true;
	}
	else encrypted = argv[1];
	
	const size_t encrypted_length = strlen(encrypted);
	const size_t encrypted_allocSize = encrypted_length + 1;
	
	char* encrypted_device;
	cudaMalloc((void**) &encrypted_device, sizeof(char) * encrypted_allocSize);
	cudaMemcpy(encrypted_device, encrypted, sizeof(char) * encrypted_allocSize, cudaMemcpyHostToDevice);
	
	// Schedule CUDA job
	CUDACrack<<<CharIterations * CharIterations, NumIterations * NumIterations>>>(encrypted);
	
	// Cleanup
	cudaFree(encrypted_device);
	if(encrypted_allocated) free(encrypted);
	
	// Copy result back
	bool resultFound;
	cudaMemcpyFromSymbol(&resultFound, "result_found", sizeof(bool), 0, cudaMemcpyDeviceToHost);
	
	if(resultFound)
	{
		char result[5];
		cudaMemcpyFromSymbol(result, "device_result", sizeof(char) * 5, 0, cudaMemcpyDeviceToHost);
		printf("%s\n", result);
	}
	else printf("Could not crack password.\n");
}
