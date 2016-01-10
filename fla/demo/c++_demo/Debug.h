/*
 * eg:
 *   #include "Debug.h"
 *   Debug::log("log message");
 *
 */

class CharToWChar
{
public:
	CharToWChar(const char* pValue, UINT uCodePage = CP_ACP):m_pBuff(NULL)
	{
		Convert(pValue, uCodePage);
	}

	CharToWChar():m_pBuff(NULL)
	{

	}

	~CharToWChar()
	{
		if(m_pBuff != NULL)
			delete[] m_pBuff;
	}

	void ResetValue(const char* pValue, UINT uCodePage = CP_ACP)
	{
		m_pBuff = NULL;
		Convert(pValue, uCodePage);
	}

	const WCHAR* GetP()
	{
		return m_pBuff;
	}

private:
	void Convert(const char* pValue, UINT uCodePage)
	{
		if (pValue != NULL)
		{
			int nLen = strlen(pValue);
			if (nLen > 0)
			{
				int nNeed = MultiByteToWideChar(uCodePage, NULL, pValue, nLen, NULL, NULL);
				if (nNeed != 0)
				{
					m_pBuff = new WCHAR[nNeed+1];
					if (m_pBuff != NULL)
					{
						ZeroMemory(m_pBuff, nNeed+1);
						MultiByteToWideChar(uCodePage, NULL, pValue, nLen, m_pBuff, nNeed);
						m_pBuff[nNeed] = L'\0';
					}
				}
			}
			else
			{
				m_pBuff = new WCHAR[1];
				*m_pBuff = L'\0';
			}
		}
	}

private:
	WCHAR* m_pBuff;
};

class WCharToChar
{
public:
	WCharToChar(const WCHAR* pValue, UINT uCodePage = CP_ACP):m_pBuff(NULL)
	{
		Convert(pValue, uCodePage);
	}

	WCharToChar():m_pBuff(NULL)
	{

	}

	~WCharToChar()
	{
		if(m_pBuff != NULL)
			delete[] m_pBuff;
	}

	const char* GetP()
	{
		return m_pBuff;
	}

	void ResetValue(const WCHAR* pValue, UINT uCodePage = CP_ACP)
	{
		m_pBuff = NULL;
		Convert(pValue, uCodePage);
	}
private:
	void Convert(const WCHAR* pValue, UINT uCodePage)
	{
		if (pValue != NULL)
		{
			int nLen = wcslen(pValue);
			if (nLen > 0)
			{
				int nNeed = WideCharToMultiByte(uCodePage, NULL, pValue, nLen, NULL, NULL, NULL, NULL);
				if (nNeed != 0)
				{
					m_pBuff = new char[nNeed+1];
					if (m_pBuff != NULL)
					{
						ZeroMemory(m_pBuff, nNeed+1);
						WideCharToMultiByte(uCodePage, NULL, pValue, nLen, m_pBuff, nNeed, NULL, NULL);
						m_pBuff[nNeed] = '\0';
					}
				}
			}
			else
			{
				m_pBuff = new char[1];
				*m_pBuff = '\0';
			}
		}
	}

private:
	char* m_pBuff;
};

class Debug
{
private:
	const static int memSize;
	const static int listenersOffset;
	static char * buffer;
	static int listening;

	const static char listenerConnectionName[];
	const static char protocolName[];
	const static char listenerMethod[];
	static char msg_title[];

	static int checkListener(void);
	static void dumpMemory(int offset, int size);
	static int writeAMFString(const char * str, int pos);
	static int writeMessage(const char * msg);

public:
	static int log(const char * msg);
};

const int Debug::memSize = 65535;
const int Debug::listenersOffset = 40976;
int Debug::listening = 0;
char* Debug::buffer;

const char Debug::listenerConnectionName[] = "app#com.asfla.Checkbug:checkbug";
const char Debug::protocolName[] = "app#com.asfla.Checkbug";
const char Debug::listenerMethod[] = "debug";
char Debug::msg_title[] = "[C++ LOG] ";

int Debug::checkListener(void)
{
	int i = listenersOffset;
	int alreadyListening = 0;
	while ( (i<memSize) && buffer[i] ) {
		if (!alreadyListening && (strcmp(listenerConnectionName, (char*)&buffer[i]) == 0)) {
			alreadyListening = 1;
		}
		i += strlen((char*)&buffer[i])+1;
	}
	return (alreadyListening) ? -1 : i;
}

void Debug::dumpMemory(int offset, int size)
{
	int i = 0;
	int c = 0;
	char b;
	while (i<size) {
		while ( (c < 16) && (i+c < size) ) {
			b = buffer[offset+i+c];
			printf("%X%X ", b/16 & 0x0f, b & 0x0f );
			c++;
		}
		while (c++ < 16) printf("   ");
		c = 0;
		while ( (c < 16) && (i+c < size) ) {
			b = buffer[offset+i+c];
			if (b > 31) printf("%c", (char)b );
			else printf(".");
			c++;
		}
		i += 16;
		c = 0;
		printf("\n");
	}
}
	
int Debug::writeAMFString(const char * str, int pos)
{
	int len = strlen(str);
	buffer[pos++] = 0x02;
	buffer[pos++] = 0;
	buffer[pos++] = (char)(len & 0xff);
	strcpy((char*)&buffer[pos], str);
	pos += len;
	return pos;
}

int Debug::writeMessage(const char * msg)
{
	DWORD *timestamp = (DWORD*)&buffer[8];
	DWORD *size = (DWORD*)&buffer[12];
	int pos = 16;
	if (*size) return 0;
	*timestamp = GetTickCount();
	pos = writeAMFString(listenerConnectionName, pos);
	pos = writeAMFString(protocolName, pos);
	pos = writeAMFString(listenerMethod, pos);
	pos = writeAMFString(msg, pos);
	*size = pos-16;
	printf("Written: timestamp=%d, size=%d\n", *timestamp, *size);
	//dumpMemory(0, *size+16);
	return 1;
}
int Debug::log(const char * msg)
{
	
	CharToWChar obj1(msg, CP_ACP);
	WCharToChar obj2(obj1.GetP(), CP_UTF8);
	msg = obj2.GetP();
	

	int nLen = strlen(msg);
	int nHead = strlen("[C++ LOG] ");
	if((nHead+nLen+1)>listenersOffset) return -1;
	char* p = new char[nHead+nLen+1];
	memset(p, 0, nHead+nLen+1);
	strcpy(p, "[C++ LOG] ");
	strcpy(p+nHead, msg);

	const char * message = p;
	
	HANDLE hMutex;
	HANDLE hMapFile;
	LPVOID lpMapAddress;
	DWORD dwWaitResult;
	int result = 0;

	hMutex = OpenMutex(MUTEX_ALL_ACCESS, false, L"MacromediaMutexOmega");

	dwWaitResult = WaitForSingleObject(
		hMutex,
		5000L);

	switch (dwWaitResult) {
		case WAIT_OBJECT_0:
			//__try {
				hMapFile = OpenFileMapping(FILE_MAP_ALL_ACCESS,  false, L"MacromediaFMOmega");

				lpMapAddress = MapViewOfFile(hMapFile,
					FILE_MAP_ALL_ACCESS,
					0,
					0,
					0);

				if (lpMapAddress != NULL) {
					buffer = (char*)lpMapAddress;

					//SENDING 
					if (checkListener() != -1) {
						//printf("Recipient not connected\n");
						Sleep(100);
					}
					else if (writeMessage(message)) {
						//printf("Message sent\n");
						result = 999;
					}
				}
				else {
					//printf("MapViewOfFile failed\n");
					result = -1;
				}

				if (!UnmapViewOfFile(lpMapAddress)) {
					//printf("UnmapViewOfFile failed\n");
					result = -2;
				}
				if(!CloseHandle(hMapFile)) {
					//printf("CloseHandle failed\n");
					result = -3;
				}
				if(!ReleaseMutex(hMutex)) {
					//printf("ReleaseMutex failed\n");
					result = 1;
				}
				if(!CloseHandle(hMutex)) {
					//printf("CloseHandle failed\n");
					result = 2;
				}
			//}
			break;
		case WAIT_TIMEOUT:
			//printf("Wait timeout\n");
			Sleep(100);
			break;
		case WAIT_ABANDONED:
			//printf("Wait abandoned\n");
			Sleep(100);
			break;
		default:
			//printf("No LocalConnection open\n");
			Sleep(100);
			break;
	}

	delete[] p;
	Sleep(10);
	return result;
}