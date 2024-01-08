#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void Crypt(const char* rawPassword, char* newPassword)
{
	newPassword[0] = rawPassword[0];
	newPassword[0] += 2;
	
	newPassword[1] = rawPassword[0];
	newPassword[1] -= 2;
	
	newPassword[2] = rawPassword[0];
	newPassword[2] += 1;
	
	newPassword[3] = rawPassword[1];
	newPassword[3] += 3;
	
	newPassword[4] = rawPassword[1];
	newPassword[4] -= 3;
	
	newPassword[5] = rawPassword[1];
	newPassword[5] -= 1;
	
	newPassword[6] = rawPassword[2];
	newPassword[6] += 2;
	
	newPassword[7] = rawPassword[2];
	newPassword[7] -= 2;
	
	newPassword[8] = rawPassword[3];
	newPassword[8] += 4;
	
	newPassword[9] = rawPassword[3];
	newPassword[9] -= 4;
	
	newPassword[10] = '\0';
	
	for(int i = 0; i < 10; i++)
	{
		if(i >= 0 && i < 6)
		{
			// Checking all lower case letter limits
			if(newPassword[i] > 122)     newPassword[i] = (newPassword[i] - 122) + 97;
			else if(newPassword[i] < 97) newPassword[i] = (97 - newPassword[i]) + 97;
		}
		else
		{
			// Checking number section
			if(newPassword[i] > 57)      newPassword[i] = (newPassword[i] - 57) + 48;
			else if(newPassword[i] < 48) newPassword[i] = (48 - newPassword[i]) + 48;
		}
	}
}

int main(int argc, char** argv)
{
	bool password_allocated = false;
	char* password = NULL;
	if(argc < 2)
	{
		printf("Enter password to encrypt: ");
		password = (char*) malloc(5 * sizeof(char));
		password[4] = '\0';
		scanf("%4s", password);
		password_allocated = true;
	}
	else password = argv[1];
	
	char result[11];
	Crypt(password, result);
	if(password_allocated) free(password);
	
	printf("Result: \"%s\"\n", result);
}
