cmake_minimum_required(VERSION 3.19)
set(CMAKE_CUDA_STANDARD 11)

project(HPC3_CrackCUDA C CUDA)

add_executable(HPC3_CrackCUDA
	Crack.cu Crack.cuh
	Crypt.cu Crypt.cuh
)

project(CryptProgram C)
add_executable(CryptProgram CryptProgram.c)

set_target_properties(HPC3_CrackCUDA PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
